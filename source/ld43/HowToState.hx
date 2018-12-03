package ld43;

import flash.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.util.FlxDestroyUtil;
using flixel.util.FlxSpriteUtil;
import openfl.Assets;
import ld43.StartState;


/**
 * A FlxState which can be used for the game's menu.
 */
class HowToState extends FlxState
{
	var _btnPlay:FlxSprite;
	var _btnExit:FlxSprite;


	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{

		FlxG.mouse.visible = true;

		var bgImage = new FlxSprite(0,0,Assets.getBitmapData("assets/images/howtoplay.png"));
		add(bgImage);

		_btnPlay = new FlxSprite(630,630,Assets.getBitmapData("assets/images/play.png"));
		add(_btnPlay);

		// FlxG.sound.playMusic(AssetPaths.end_soundtrack__ogg, .5, true);
		
		super.create();
	}
	

	private function clickPlay():Void
	{
		var mapState = new MapState();
		mapState.file = "assets/tiled/level.tmx";
		FlxG.switchState(mapState);
	}


	override public function update(elapsed:Float):Void
   {
      super.update(elapsed);

   		if (FlxG.mouse.overlaps(_btnPlay)) {
			if (FlxG.mouse.justPressed) {
				clickPlay();
			}
		}

   }


	

	
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
		//_txtTitle = FlxDestroyUtil.destroy(_txtTitle);
	}
}