	
package drifter;

import drifter.TiledLevel;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.ui.FlxVirtualPad;
import flixel.FlxSubState;
import flixel.util.FlxColor;


class MapState extends FlxSubState
{
	public var level:TiledLevel;
	public var file:String;
	

	#if mobile
	public static var virtualPad:FlxVirtualPad;
	#end
	
	override public function create():Void 
	{

		#if desktop
		FlxG.mouse.visible = false;
		#end

		bgColor = 0xffaaaaaa;
		// Load the level's tilemap
		//level = new TiledLevel("assets/tiled/level2.tmx", this);
		level = new TiledLevel(file, this);
		
		// Add backgrounds
		add(level.backgroundLayer);

		// Add static images
		add(level.imagesLayer);
		
		// Add foreground tiles after adding level objects, so these tiles render on top of player
		add(level.foregroundTiles);

		// Load objects
		add(level.objectsLayer);

		// Load triggers
		add(level.triggersLayer);

		destroySubStates = false;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);

		// Collide with foreground tile layer
		level.collideWithLevel(level.player);
		level.collideWithObjects(level.player);
		level.collideWithTriggers(level.player);
	}	
}
