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

        private var flyingEmitter:FlyingEmitter;
        private var impactEmitter:ImpactEmitter;

        private var player:Player;
        
        public function new(player:Player) 
	{

                trace("Creating projectile");
                this.player = player;
                var x = player.x;
                var y = player.y;
                
                if(player.facing == FlxObject.LEFT || player.facing == FlxObject.DOWN) {
                        x += player.width - 20;
		}                
                
                super(x, y);

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
                setVelocityFromPlayerFacing(player.facing);

                this.drag.x = this.drag.y = 400;
                
                collided = false;
                flyingEmitter = new FlyingEmitter(this);
                player.mapState.add(flyingEmitter);
	}

        public function setVelocityFromPlayerFacing(playerFacing:Int) {
                var speed=800;
                angularVelocity=720;
                switch(playerFacing) {
                        case FlxObject.UP:
                        velocity.set(0,0-speed);
                        return;
                        case FlxObject.DOWN:
                        velocity.set(0,speed);
                        return;
                        case FlxObject.LEFT:
                        velocity.set(0-speed,0);
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

        public function addImpactParticles() {
                impactEmitter = new ImpactEmitter(this);
                player.mapState.add(impactEmitter);
        }

        public function doGroundImpact() {
                //animation.play("groundImpact");
                //flyingSound.stop();
                groundImpactSound.play();
                addImpactParticles();
                collided=true;
        }

        public function doTargetImpact() {
                //animation.play("targetImpact");
                //flyingSound.stop();
                targetImpactSound.play();
                addImpactParticles();
                collided=true;
        }

        public override function update(elapsed:Float):Void {
                flyingEmitter.focusOn(this);
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
                if(collided) {
                        trace("Particles: " + impactEmitter.countLiving());
                }
                return collided;
        }

}