package ld43;

import openfl.Assets;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.system.FlxSound;


class Projectile extends FlxSprite
{

        private var launchSound:FlxSound;

        private var flyingSound:FlxSound;

        private var groundImpactSound:FlxSound;

        private var targetImpactSound:FlxSound;

        public var collided:Bool;

        private var nextAnimation:String;
        
        public function new(X:Float = 0, Y:Float = 0, playerFacing:Int) 
	{

                trace("Creating projectile");
                super(X, Y);

                trace("Loading graphic");
                loadGraphic(AssetPaths.snowball__png, true, 20, 20);
                setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

                //animation.add("launch",[0,1,2,3],5,true);
                animation.add("flying",[0],5,true);
                //animation.add("groundImpact",[4,5,6,7,8,9],12,true);
                //animation.add("targetImpact",[10],1,true);                

                //load audio
                trace("Loading audio");
                flyingSound = FlxG.sound.load(AssetPaths.snowball_flying__ogg,.1);

                launchSound = FlxG.sound.load(AssetPaths.snowball_launch__ogg,.1);
                launchSound.looped = false;

                groundImpactSound = FlxG.sound.load(AssetPaths.snowball_ground__ogg,.1);
                groundImpactSound.looped = false;
                
                targetImpactSound = FlxG.sound.load(AssetPaths.snowball_target__ogg,.1);
                targetImpactSound.volume = .6;
                targetImpactSound.looped = false;

                trace("Setting velocity from player facing");
                setVelocityFromPlayerFacing(playerFacing);

                this.drag.x = this.drag.y = 400;
                
                collided = false;
                
	}

        public function setVelocityFromPlayerFacing(playerFacing:Int) {
                var speed=800;
                angularVelocity=720;
                switch(playerFacing) {
                        case FlxObject.UP:
                        velocity.set(0,0-speed);
                        x+=136;
                        return;
                        case FlxObject.DOWN:
                        velocity.set(0,speed);
                        return;
                        case FlxObject.LEFT:
                        velocity.set(0-speed,0);
                        x+=136;
                        return;
                        case FlxObject.RIGHT:
                        velocity.set(speed,0);
                        return;
                }
        }
        
        public function doLaunch() {
                //animation.play("flying");
                
                launchSound.play();
                //flyingSound.play();
                
        }

        public function doGroundImpact() {
                //animation.play("groundImpact");
                //flyingSound.stop();
                groundImpactSound.play();
                collided=true;
        }

        public function doTargetImpact() {
                //animation.play("targetImpact");
                //flyingSound.stop();
                targetImpactSound.play();
                collided=true;
        }

        public override function update(elapsed:Float):Void {
                if(nextAnimation != null && animation.finished) {
                        animation.play(nextAnimation);
                        nextAnimation = null;
                }            
                if (velocity.x == 0 && velocity.y == 0 && !collided) {
                        doGroundImpact();
                }
                super.update(elapsed);
        }

        public function handleEnemyCollision(enemy:Enemy):Void {
                doTargetImpact();
        }
        
        public function isFinished():Bool {
                return collided && animation.finished;
        }
}