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
	public var projectiles:FlxGroup;

	
	public static var virtualPad:FlxVirtualPad;
	

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

		add(level.snowpileGroup);

		// Add foreground tiles after adding level objects, so these tiles render on top of player
		add(level.foregroundTiles);

		// Load objects
		add(level.objectsLayer);

		// Load triggers
		add(level.triggersLayer);

		add(level.enemiesGroup);


		destroySubStates = false;

		projectiles = new FlxGroup();
                add(projectiles);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		// Collide player with foreground tile layer
		level.collideWithLevel(level.player);
		level.collideWithObjects(level.player);
		level.collideWithTriggers(level.player);

		level.collidePlayerWithEnemies();

		// Collide enemy with foreground tile layer
		level.collideWithLevel(level.enemiesGroup);
		level.collideWithObjects(level.enemiesGroup);
		for (sprite in level.enemiesGroup) {
			var enemy:Enemy = cast sprite;
			level.checkEnemyVision(enemy);
			level.collideWithEnemies(enemy);
		}

                for (sprite in projectiles) {
                        var projectile:Projectile = cast sprite;
                        projectile.update(elapsed);
                        if (projectile.isFinished()) {
                                projectile.kill();
                        }
                }
                FlxG.overlap(projectiles, level.enemiesGroup, projectileEnemyCollision);

        }

        public function projectileEnemyCollision(projectile:Projectile, enemy:Enemy) {
                enemy.handleProjectileCollision(projectile);
                projectile.handleEnemyCollision(enemy);
        }
                
        public function addProjectile(projectile:Projectile):Void {
                projectiles.add(projectile);
                
        }

        
        
}
