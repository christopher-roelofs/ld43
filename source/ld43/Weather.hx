package ld43;

import flixel.graphics.frames.FlxFilterFrames;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import openfl.filters.GlowFilter;
import flixel.system.FlxSound;
import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class Weather extends FlxEmitter
{
        	
	public function new(X:Float=0, Y:Float=0, Size:Int=20) 
	{	
		Size = 20;
                maxSize = 40;
		super(X, Y, Size);		
	        
		for (i in 0...(Std.int(maxSize))) 
		{
			var whitePixel = new FlxParticle();
			whitePixel.makeGraphic(4, 4, 0xAAAAAAAA);
			whitePixel.visible = true; 
			whitePixel.width = 2;
			whitePixel.height = 2;
			add(whitePixel);
			
		}		
		//collides = false;
                super.start(false, 0.1, -1);
	}
        

	public override function update(elapsed:Float):Void {
                super.update(elapsed);
        }

}