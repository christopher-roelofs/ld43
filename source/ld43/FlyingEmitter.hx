package ld43;

import flixel.graphics.frames.FlxFilterFrames;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxColor;
import flixel.util.helpers.FlxBounds;
import flixel.util.FlxDestroyUtil;
import openfl.filters.GlowFilter;
import flixel.system.FlxSound;
import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class FlyingEmitter extends FlxEmitter
{
        
	public function new(projectile:Projectile) 
	{	
                maxSize = 40;
		super(projectile.x + projectile.width / 2, projectile.y + projectile.height / 2, maxSize);		

                this.lifespan = new FlxBounds<Float>(1);

                makeParticles(4, 4, 0xAAAAAAAA, maxSize);
		//collides = false;
                this.focusOn(projectile);
                super.start(false, .1, 40);
                                trace("Starting emitter at " + x + "," + y + " with " + countLiving() + " living particles");

	}

        

	public override function update(elapsed:Float):Void {
                super.update(elapsed);
        }

}