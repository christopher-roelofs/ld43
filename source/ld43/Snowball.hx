package ld43;

import openfl.Assets;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.system.FlxSound;


class Object extends FlxSprite
{
        private var name:String;
        private var type:String;


        var playState:PlayState;
        
        public function new(X:Float = 0, Y:Float = 0, Name:String, Type:String , ?SimpleGraphic) 
	{

                
                loadGraphic(AssetPaths.player__png, true, 129, 178);
                setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
                
                animation.add("standing",[0,1,2,3],5,true);
                animation.add("running",[4,5,6,7,8,9],12,true);
                animation.add("jumping",[10],1,true);
                animation.add("landing",[11],1,false);
                animation.add("terminalActivate",[12,13,13,13],2,false);
                animation.add("terminalDeactivate",[13,12],2,false);
                
                animation.add("dancing",[0,10,0,11],5,true);
                
                animation.play("standing");
                this.maxVelocity.x = 650;
		this.maxVelocity.y = 800;
                this.xAcceleration = 2000;
                this.drag.x = 100;

                //gravity
		this.acceleration.y = 1000;

                //how fast the player must be falling to trigger the landing animation
		this.landingThreshhold = 75;

                setTerminalActivationState(0);


                //load audio
                runSound = FlxG.sound.load(AssetPaths.running_ice__ogg,.1);
                jumpSound = FlxG.sound.load(AssetPaths.jump__ogg);
                jumpSound.looped = false;        


		FlxG.camera.follow(this);
		playState.player = this;
                resetLetterCount();

	}

	public function getName() {
                return name;
        }

	public function getType() {
                return type;
        }
	
}