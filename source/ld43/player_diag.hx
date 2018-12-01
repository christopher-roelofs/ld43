package ld43;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;

class Player extends FlxSprite
{
	public var speed:Float = 120;
	private var _sndStep:FlxSound;
	
	
	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y);
		this.maxVelocity.set(85, 85);
		makeGraphic(16, 16, 0xffaa1111);
		drag.x = maxVelocity.x;
		drag.y = maxVelocity.y;
		
	}
	
	private function movement():Void
	{
		acceleration.set(0, 0);
			
			if (FlxG.keys.anyPressed([RIGHT, D]))
			{
				acceleration.x = drag.x;
				//facing = FlxObject.RIGHT;
			}
			else if (FlxG.keys.anyPressed([LEFT, A]))
			{
				acceleration.x = -drag.x;
				//facing = FlxObject.LEFT;
			}
			
			if (FlxG.keys.anyPressed([UP, W]))
			{
				acceleration.y = -drag.y;
				//facing = FlxObject.UP;
			}
			else if (FlxG.keys.anyPressed([DOWN, S]))
			{
				acceleration.y = drag.y;
				//facing = FlxObject.DOWN;
			}
	}

	override public function update(elapsed:Float):Void 
	{
		movement();
		super.update(elapsed);
	}
	
}