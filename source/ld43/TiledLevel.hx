package ld43;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.addons.editors.tiled.TiledImageLayer;
import flixel.addons.editors.tiled.TiledImageTile;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import haxe.io.Path;
import haxe.Json;
import openfl.Assets;
import flixel.input.gamepad.FlxGamepad;
import flash.display.BitmapData;

/**
 * @author Samuel Batista
 */
class TiledLevel extends TiledMap {
	// For each "Tile Layer" in the map, you must define a "tileset" property which contains the name of a tile sheet image
	// used to draw tiles in that layer (without file extension). The image file must be located in the directory specified bellow.
	private inline static var c_PATH_LEVEL_TILESHEETS = "assets/tiled/";

	// Array of tilemaps used for collision
	public var foregroundTiles:FlxGroup;
	public var objectsLayer:FlxGroup;
	public var triggersLayer:FlxGroup;
	public var backgroundLayer:FlxGroup;

	private var collidableTileLayers:Array<FlxTilemap>;
	private var mapJson:Json;
	private var levelState:MapState;
	private var _a:Bool;

	public var player:Player;
	public var enemy:Enemy;
	// Sprites of images layers
	public var imagesLayer:FlxGroup;
	public var enemiesGroup:FlxGroup;
	private var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

	public function new(tiledLevel:Dynamic, state:MapState) {
		super(tiledLevel);
		imagesLayer = new FlxGroup();
		foregroundTiles = new FlxGroup();
		objectsLayer = new FlxGroup();
		triggersLayer = new FlxGroup();
		backgroundLayer = new FlxGroup();
		levelState = state;

		// FlxG.log.redirectTraces = true;

		FlxG.camera.setScrollBoundsRect(0, 0, fullWidth, fullHeight, true);

		loadImages();
		loadObjects(state);

		// Load Tile Maps
		for (layer in layers) {
			if (layer.type != TiledLayerType.TILE)
				continue;
			var tileLayer:TiledTileLayer = cast layer;

			var tileSheetName:String = tileLayer.properties.get("tileset");

			if (tileSheetName == null)
				throw "'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";

			var tileSet:TiledTileSet = null;
			for (ts in tilesets) {
				if (ts.name == tileSheetName) {
					tileSet = ts;
					break;
				}
			}

			if (tileSet == null)
				throw "Tileset '" + tileSheetName + " not found. Did you misspell the 'tilesheet' property in " + tileLayer.name + "' layer?";

			var imagePath = new Path(tileSet.imageSource);
			var processedPath = c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;

			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.loadMapFromArray(tileLayer.tileArray, width, height, processedPath, tileSet.tileWidth, tileSet.tileHeight, OFF, tileSet.firstGID, 1, 1);

			if (tileLayer.properties.contains("nocollide")) {
				backgroundLayer.add(tilemap);
			} else {
				if (collidableTileLayers == null)
					collidableTileLayers = new Array<FlxTilemap>();

				foregroundTiles.add(tilemap);
				collidableTileLayers.push(tilemap);
			}
		}
	}

	public function loadObjects(state:MapState) {
		var layer:TiledObjectLayer;

		for (layer in layers) {
			if (layer.type != TiledLayerType.OBJECT)
				continue;
			var objectLayer:TiledObjectLayer = cast layer;

			// collection of images layer
			if (layer.name == "images") {
				for (o in objectLayer.objects) {
					loadImageObject(o);
				}
			}

			// objects layer
			if (layer.name == "objects") {
				var fileContent:String = Assets.getText(layer.properties.keys['mapjson']);
				mapJson = Json.parse(fileContent);
				for (o in objectLayer.objects) {
					loadObject(state, o, objectLayer, objectsLayer);
				}
			}
		}
	}

	private function loadImageObject(object:TiledObject) {
		var tilesImageCollection:TiledTileSet = this.getTileSet("imageCollection");
		var tileImagesSource:TiledImageTile = tilesImageCollection.getImageSourceByGid(object.gid);

		// decorative sprites
		var levelsDir:String = "assets/tiled/";

		var decoSprite:FlxSprite = new FlxSprite(0, 0, levelsDir + tileImagesSource.source);
		if (decoSprite.width != object.width || decoSprite.height != object.height) {
			decoSprite.antialiasing = true;
			decoSprite.setGraphicSize(object.width, object.height);
		}
		decoSprite.setPosition(object.x, object.y - decoSprite.height);
		decoSprite.origin.set(0, decoSprite.height);
		if (object.angle != 0) {
			decoSprite.angle = object.angle;
			decoSprite.antialiasing = true;
		}

		// Custom Properties
		if (object.properties.contains("depth")) {
			var depth = Std.parseFloat(object.properties.get("depth"));
			decoSprite.scrollFactor.set(depth, depth);
		}

		backgroundLayer.add(decoSprite);
	}

	private function loadObject(state:MapState, o:TiledObject, g:TiledObjectLayer, group:FlxGroup) {
		var x:Int = o.x;
		var y:Int = o.y;
		var h:Int = o.height;
		var w:Int = o.width;

		// objects in tiled are aligned bottom-left (top-left in flixel)
		if (o.gid != -1)
			y -= g.map.getGidOwner(o.gid).tileHeight;

		switch (o.type.toLowerCase()) {
			case "player_start":
				player = new Player(x, y);
				FlxG.camera.follow(player);
				group.add(player);

			case "enemy_spawn":
				enemy = new Enemy(x, y);
				group.add(enemy);

			case "entrance", "exit":
				// get object properties from map json by object name
				var trigger = new Trigger(x, y, w, h, o.name, o.type);
				var objProps = Reflect.field(mapJson, o.name);
				var mapState = new MapState();
				mapState.file = objProps.map;
				trigger.setState(mapState);
				trigger.alpha = .3;
				triggersLayer.add(trigger);

			case "object":
				var objectLayerTileSet:TiledTileSet = this.getTileSet(g.properties.get("tileset"));
				var tileImagesSource:TiledImageTile = objectLayerTileSet.getImageSourceByGid(o.gid);
				var objectImage = new FlxSprite().loadGraphic(c_PATH_LEVEL_TILESHEETS + objectLayerTileSet.imageSource, true, objectLayerTileSet
					.tileHeight, objectLayerTileSet.tileWidth);
				var bitmap:BitmapData = new BitmapData(objectLayerTileSet.tileHeight, objectLayerTileSet.tileWidth);
				objectImage.frames.getByIndex(o.gid - 1).paint(bitmap);
				var object = new Object(x, y, o.name, o.type, bitmap);
				group.add(object);
				objectImage.destroy();
				// get object properties from map json by object name
				var trigger = new Trigger(x - 1, y - 1, w + 2, h + 2, o.name, o.type);
				// var objProps = Reflect.field(mapJson,o.name);
				// var mapState = new MapState();
				// mapState.file = objProps.map;
				// trigger.setState(mapState);
				trigger.alpha = .3;
				triggersLayer.add(trigger);
		}
	}

	public function loadImages() {
		for (layer in layers) {
			if (layer.type != TiledLayerType.IMAGE)
				continue;

			var image:TiledImageLayer = cast layer;
			var sprite = new FlxSprite(image.x, image.y, c_PATH_LEVEL_TILESHEETS + image.imagePath);
			imagesLayer.add(sprite);
		}
	}

	public function collideWithLevel(obj, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool {
		// collide tile layers
		if (collidableTileLayers == null)
			return false;

		for (map in collidableTileLayers) {
			// IMPORTANT: Always collide the map with objects, not the other way around.
			//			  This prevents odd collision errors (collision separation code off by 1 px).
			if (FlxG.overlap(map, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate)) {
				return true;
			}
		}
		return false;
	}

	public function collideWithObjects(obj, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool {
		//	collide triggers layer
		//	IMPORTANT: Always collide the map with objects, not the other way around.
		//	This prevents odd collision errors (collision separation code off by 1 px).
		if (FlxG.overlap(objectsLayer, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate)) {
			return true;
		}

		return false;
	}

	public function collideWithTriggers(obj, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool {
		//	collide triggers layer
		function collide(object:Object, player:FlxObject):Bool {
			var buttonPressed:Bool = FlxG.keys.justReleased.E || (gamepad != null && gamepad.justReleased.A);

			if (object.getType() == "object") {
				if (buttonPressed) {
					trace(object.getName());
				}
				return true;
			}

			if (object.getType() == "entrance") {
				if (buttonPressed) {
					var trigger:Trigger = cast object;
					levelState.openSubState(trigger.getState());
				}
				return true;
			}

			if (object.getType() == "exit") {
				if (buttonPressed) {
					levelState.close();
				}
				return true;
			}

			return true;
		}

		// 	IMPORTANT: Always collide the map with objects, not the other way around.
		//	This prevents odd collision errors (collision separation code off by 1 px).
		FlxG.overlap(triggersLayer, obj, collide);

		return false;
	}

	public function checkEnemyVision(e:Enemy):Void {
		if (FlxMath.distanceBetween(e,player) < 400) {
			e.seesPlayer = true;
			e.playerPos.copyFrom(player.getMidpoint());
		} else
			e.seesPlayer = false;
	}
}
