package ld43;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.input.gamepad.FlxGamepad;
import ld43.EndState;

class Player extends FlxSprite {
	public var mapState:MapState;

	public var speed:Float = 400;

	private var _sndStep:FlxSound;

	public var score:Int = 0;
	public var _up:Bool;
	public var _down:Bool;
	public var _left:Bool;
	public var _right:Bool;
	public var walkSound:FlxSound;
	public var currentState:String;
        public var firing:Bool = false;
	private var currentScale:Float = 1;
	var actions = {
		up: false,
		left: false,
		right: false,
		down: false,
		slide: false,
		fire: false,
                moving: false
	};
	var lastActions = {
		up: false,
		left: false,
		right: false,
		down: false,
		slide: false,
		fire: false,
                moving: false
	};

	public function new(X:Float = 0, Y:Float = 0, state:MapState) {
		super(X, Y);
		loadGraphic(AssetPaths.snowman__png, true, 312, 312);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
                animation.add("lr", [4, 5], 4, true);
                
                animation.add("lrthrow", [6,7], 10, false);
                animation.add("u", [8, 9], 4, true);
                animation.add("uthrow", [10,11],10,false);
		animation.add("d", [12, 13], 4, true);
                animation.add("dthrow", [14,15], 10, false);
                animation.add("dead", [16,17,16,17,16,17,16,16], 4, false);

		drag.x = drag.y = 1600;
		walkSound = FlxG.sound.load(AssetPaths.snowman_walk_snow__ogg, .1);
		currentState = "standing";
		this.mapState = state; 

		var newScale:Float = this.currentScale - .5;
		scale.set(newScale, newScale);
		updateHitbox();
		this.currentScale = newScale;
                alive=true;
	}

	private function increaseMass() {
		// trace(currentScale);
		if (currentScale < .7) {
			var newScale:Float = this.currentScale + .03;
			scale.set(newScale, newScale);
			updateHitbox();
			this.currentScale = newScale;
		} else {
			score += 5;
		}
	};

	public function handleSnowPileCollision() {
		this.increaseMass();
	};
        
	public function takeDamage() {
		if (currentScale > .3) {
			// trace(currentScale);
			var newScale:Float = this.currentScale - .0005;
			scale.set(newScale, newScale);
			updateHitbox();
			this.currentScale = newScale;
		} else {
                        doDeath();
		}
	};

                
        
	public function decreaseMass() {
		if (currentScale > .3) {
			// trace(currentScale);
			var newScale:Float = this.currentScale - .005;
			scale.set(newScale, newScale);
			updateHitbox();
			this.currentScale = newScale;
		} else {
		        doDeath();
		}
	};

	private function checkInput():Void {
		var _up = false;
		var _down = false;
		var _left = false;
		var _right = false;
		var _fire = false;

		#if !FLX_NO_KEYBOARD
		_up = FlxG.keys.anyPressed([UP, W]);
		_down = FlxG.keys.anyPressed([DOWN, S]);
		_left = FlxG.keys.anyPressed([LEFT, A]);
		_right = FlxG.keys.anyPressed([RIGHT, D]);
		_fire = FlxG.keys.pressed.SPACE;
		#end
		#if mobile
		var virtualPad = MapState.virtualPad;
		_up = _up || virtualPad.buttonUp.pressed;
		_down = _down || virtualPad.buttonDown.pressed;
		_left = _left || virtualPad.buttonLeft.pressed;
		_right = _right || virtualPad.buttonRight.pressed;
		// _fire = _fire ||
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
		if (gamepad != null) {
			_up = gamepad.pressed.DPAD_UP;
			_down = gamepad.pressed.DPAD_DOWN;
			_left = gamepad.pressed.DPAD_LEFT;
			_right = gamepad.pressed.DPAD_RIGHT;
			_fire = gamepad.pressed.A;
		}

		if (_up && _down)
			_up = _down = false;
		if (_left && _right)
			_left = _right = false;

		actions.up = _up;
		actions.down = _down;
		actions.left = _left;
		actions.right = _right;
		actions.fire = _fire;
                actions.moving = _up || _down || _left || _right;
	}

	public function movement():Void {
                if(actions.moving) {
			var mA:Float = 0;
			if (actions.up) {
				mA = -90;
				if (actions.left)
				mA -= 45;
				else if (actions.right)
				mA += 45;

				facing = FlxObject.UP;
			} else if (actions.down) {
				mA = 90;
				if (actions.left)
				mA += 45;
				else if (actions.right)
				mA -= 45;

				facing = FlxObject.DOWN;
			} else if (actions.left) {
				mA = 180;
				facing = FlxObject.LEFT;
			} else if (actions.right) {
				mA = 0;
				facing = FlxObject.RIGHT;
			}

			velocity.set(speed, 0);
			velocity.rotate(FlxPoint.weak(0, 0), mA);

                        if(!firing) {       
			        if ((velocity.x != 0 || velocity.y != 0)) {
                                        doWalk();
			        } else {
				        if (animation.curAnim != null) {
					        animation.curAnim.curFrame = 0;
					        animation.curAnim.pause();
				        }
			        }
                        }
		} else if (!firing) {
			doStand();
		}
	}

        
        
	private function updateLastActions() {
		lastActions.up = actions.up;
		lastActions.down = actions.down;
		lastActions.left = actions.left;
		lastActions.right = actions.right;
		lastActions.fire = actions.fire;
                lastActions.moving = actions.moving;
	}

	override public function update(elapsed:Float):Void {

                if(alive) {
                                                
		        updateLastActions();                
		        checkInput();

		        // fire key down
		        if (actions.fire && !lastActions.fire) {
                                doFire();
		        }

                        if(firing && animation.finished) {
                                firing = false;
                                doStand();
                        }

                        movement();

                } else if(animation.finished) {
                        transitionAfterDeath();
                }
		super.update(elapsed);
	}

        public function transitionAfterDeath() {
                var endState:EndState = new EndState();
		endState.score = score;
                this.kill();
		FlxG.switchState(endState);
        }


        public function setNormalAnimation() {
                switch (facing) {
			case FlxObject.LEFT, FlxObject.RIGHT:
			animation.play("lr");
                        
			case FlxObject.UP:
			animation.play("u");
                        
			case FlxObject.DOWN:
			animation.play("d");
		}                
        }

        public function setFiringAnimation() {
                switch (facing) {
			case FlxObject.LEFT, FlxObject.RIGHT:
			animation.play("lrthrow");

			case FlxObject.UP:
			animation.play("uthrow");

			case FlxObject.DOWN:
			animation.play("dthrow");
                }                
        }

        private function doStand() {
                if (currentState == "stand") return;
                currentState = "stand";
                trace("standing");
		walkSound.stop();
                setNormalAnimation();
		if (animation.curAnim != null) {
			animation.curAnim.curFrame = 0;
			animation.curAnim.pause();
		}
        }

        private function doWalk() {
                if (currentState == "walk") return;
                currentState = "walk";
                trace("walking");
		walkSound.play();
                setNormalAnimation();
		return;
	}

        
        private function doFire() {
                currentState = "firing";
                firing=true;
                trace("firing");
                var snowball = new Projectile(this);
                setFiringAnimation();
                animation.curAnim.curFrame = 0;
		mapState.addProjectile(snowball);
		snowball.doLaunch();
                setFiringAnimation();
		this.decreaseMass();
        }

        private function doDeath() {
                if (currentState == "death") return;
                trace("dying");
                currentState = "death";
                alive=false;
                scale.set(.5, .5);
                animation.play("dead");
        }

}
