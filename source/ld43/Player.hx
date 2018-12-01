package ld43;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.input.gamepad.FlxGamepad;

class Player extends FlxSprite
{
        var mapState:MapState;
	public var speed:Float = 200;
	private var _sndStep:FlxSound;

	public var _up:Bool;
	public var _down:Bool;
	public var _left:Bool;
	public var _right:Bool;
        
        public var walkSound:FlxSound;

        public var currentState:String;
	
	public function new(X:Float = 0, Y:Float = 0, state:MapState) 
	{
		super(X, Y);
                this.mapState = state;
		loadGraphic(AssetPaths.player__png, true, 15, 20);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		animation.add("d", [0, 1, 0, 2,0], 6, false);
		animation.add("lr", [3, 4, 3, 5,3], 6, false);
		animation.add("u", [6, 7, 6, 8,6], 6, false);
		drag.x = drag.y = 1600;
                walkSound = FlxG.sound.load(AssetPaths.snowman_walk_snow__ogg,.1);
                currentState="standing";
	}
	
	private function movement():Void
	{
		_up = false;
		_down = false;
		_left = false;
		_right = false;
		
		#if !FLX_NO_KEYBOARD
		_up = FlxG.keys.anyPressed([UP, W]);
		_down = FlxG.keys.anyPressed([DOWN, S]);
		_left = FlxG.keys.anyPressed([LEFT, A]);
		_right = FlxG.keys.anyPressed([RIGHT, D]);
		#end
		#if mobile
		var virtualPad = MapState.virtualPad;
		_up = _up || virtualPad.buttonUp.pressed;
		_down = _down || virtualPad.buttonDown.pressed;
		_left  = _left || virtualPad.buttonLeft.pressed;
		_right = _right || virtualPad.buttonRight.pressed;
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
                if (gamepad != null)
                {
                        _up = gamepad.pressed.DPAD_UP;
		        _down = gamepad.pressed.DPAD_DOWN;
		        _down = gamepad.pressed.DPAD_DOWN;
		        _left = gamepad.pressed.DPAD_LEFT;
		        _right = gamepad.pressed.DPAD_RIGHT;
                }
		
		if (_up && _down)
		_up = _down = false;
		if (_left && _right)
		_left = _right = false;

                
		if ( _up || _down || _left || _right)
		{
                        updateAssetState("walking");
			var mA:Float = 0;
			if (_up)
			{
				mA = -90;
				if (_left)
				mA -= 45;
				else if (_right)
				mA += 45;

				facing = FlxObject.UP;
			}
			else if (_down)
			{
				mA = 90;
				if (_left)
				mA += 45;
				else if (_right)
				mA -= 45;

				facing = FlxObject.DOWN;
			}
			else if (_left)
			{
				mA = 180;
				facing = FlxObject.LEFT;
			}
			else if (_right)
			{
				mA = 0;
				facing = FlxObject.RIGHT;
			}
			
			velocity.set(speed, 0);
			velocity.rotate(FlxPoint.weak(0, 0), mA);


                        
			if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE)
			{
				
				switch (facing)
				{
					case FlxObject.LEFT, FlxObject.RIGHT:
					animation.play("lr");
					
					case FlxObject.UP:
					animation.play("u");
					
					case FlxObject.DOWN:
					animation.play("d");
				}
                                
			} else {

                                if (animation.curAnim != null) {
			                animation.curAnim.curFrame = 0;
			                animation.curAnim.pause();
                                }
		        }
		} else {
                        updateAssetState("standing");                        
                }
                
	}

        public function playWalkSound() {
                trace("Playing walk sound");
                walkSound.play();
        }

        public function stopWalkSound() {
                trace("Stopping walk sound");
                walkSound.stop();
        }
        

        public function updateAssetState(state:String) {
                if(state == currentState) {
                        return;
                }
                trace("state: '" + currentState + "' -> '" + state + "'");
                currentState=state;
                
                switch(state) {
                        case "walking":
                        playWalkSound();
                        animation.play(state);
                        return;
                        case "standing":
                        stopWalkSound();
                }
        }
        
	override public function update(elapsed:Float):Void 
	{
		movement();                
		super.update(elapsed);
	}
	
}