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
class ImpactEmitter extends FlxEmitter
{
        
	public function new(projectile:Projectile) 
	{	
                maxSize = 40;
		super(projectile.x + projectile.width / 2, projectile.y + projectile.height / 2, maxSize);		

                this.lifespan = new FlxBounds<Float>(1);

                makeParticles(4, 4, 0xAAAAAAAA, maxSize);
		//collides = false;
                super.start(true, 0.1, -1);
                                trace("Starting emitter at " + x + "," + y + " with " + countLiving() + " living particles");

	}

        

	public override function update(elapsed:Float):Void {
                super.update(elapsed);
        }

}