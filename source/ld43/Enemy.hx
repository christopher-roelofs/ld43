package ld43;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.math.FlxAngle;
import flixel.util.FlxDestroyUtil;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxVelocity;

using flixel.util.FlxSpriteUtil;

class Enemy extends FlxSprite {
	public var speed:Float = 140;

	var _brain:FSM;
	var _idleTmr:Float;
	var _moveDir:Float;

	public var seesPlayer:Bool = false;
	public var playerPos(default, null):FlxPoint;

	public function new(X:Float = 0, Y:Float = 0) {
		super(X, Y);
		loadGraphic(AssetPaths.squirel__png, true, 78,78);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		animation.add("d", [0, 1, 0, 1], 6, false);
		animation.add("lr", [2, 3, 2, 3], 6, false);
		animation.add("u", [4, 5, 4, 5], 6, false);
		animation.add("idle", [6, 7, 6, 7], 6, false);
		animation.add("dead", [8], 1, false);
		drag.x = drag.y = 10;
		_brain = new FSM(idle);
		_idleTmr = 0;
		playerPos = FlxPoint.get();
	}

	override public function draw():Void {
		if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE) {
			if (Math.abs(velocity.x) > Math.abs(velocity.y)) {
				if (velocity.x < 0)
					facing = FlxObject.LEFT;
				else
					facing = FlxObject.RIGHT;
			} else {
				if (velocity.y < 0)
					facing = FlxObject.UP;
				else
					facing = FlxObject.DOWN;
			}

			switch (facing) {
				case FlxObject.LEFT, FlxObject.RIGHT:
					animation.play("lr");

				case FlxObject.UP:
					animation.play("u");

				case FlxObject.DOWN:
					animation.play("d");
			}
		}
		super.draw();
	}

	public function idle():Void {
		if (seesPlayer) {
			_brain.activeState = chase;
		} else if (_idleTmr <= 0) {
			if (FlxG.random.bool(1)) {
				_moveDir = -1;
				velocity.x = velocity.y = 0;
			} else {
				animation.play("idle");
				_moveDir = FlxG.random.int(0, 8) * 45;
				velocity.set(speed * 0.5, 0);
				velocity.rotate(FlxPoint.weak(), _moveDir);
			}
			_idleTmr = FlxG.random.int(1, 4);
		} else
			_idleTmr -= FlxG.elapsed;
	}

	public function chase():Void {
		if (!seesPlayer) {
			_brain.activeState = idle;
		} else {
			FlxVelocity.moveTowardsPoint(this, playerPos, Std.int(speed*1.5));
		}
	}

        public function handleProjectileCollision(projectile:Projectile):Void {
                this.kill();
        }

	override public function update(elapsed:Float):Void {
		_brain.update();
		super.update(elapsed);
	}
}
