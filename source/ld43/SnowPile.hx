package ld43;

import flixel.FlxSprite;


class SnowPile extends FlxSprite
{

    public function new(X:Float = 0, Y:Float = 0) 
	{

		super(X, Y);
        loadGraphic(AssetPaths.snowpile__png, true, 117,117);
	}
	
}