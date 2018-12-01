package ld43;

import ld43.TiledLevel;
import ld43.Projectile;
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

class MapState extends FlxSubState {
	public var level:TiledLevel;
	public var file:String;
	public var projectiles:Array<Projectile>;

	#if mobile
	public static var virtualPad:FlxVirtualPad;
	#end

	override public function create():Void {
		#if desktop
		FlxG.mouse.visible = false;
		#end

		bgColor = FlxColor.WHITE;
		// Load the level tilemap
		// level = new TiledLevel("assets/tiled/level2.tmx", this);
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

		add(level.enemiesGroup);

		destroySubStates = false;

		projectiles = new Array<Projectile>();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		// Collide player with foreground tile layer
		level.collideWithLevel(level.player);
		level.collideWithObjects(level.player);
		//level.collideWithTriggers(level.player);

		level.collidPlayerWithEnemies();

		// Collide enemy with foreground tile layer
		level.collideWithLevel(level.enemiesGroup);
		level.collideWithObjects(level.enemiesGroup);
		for (sprite in level.enemiesGroup) {
			var enemy:Enemy = cast sprite;
			level.checkEnemyVision(enemy);
			level.collideWithEnemies(enemy);
		}

                
                var i = projectiles.length;
                while (i-- > 0) {
                        var projectile = projectiles[i];
                        projectile.update(elapsed);
                        if (projectile.isFinished()) {
                                projectiles.splice(i, 1);
                                projectile.kill();
                        }
                }
        }

        public function addProjectile(projectile:Projectile):Void {
                projectiles.push(projectile);
                add(projectile);
        }
        
}
