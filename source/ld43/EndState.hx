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
class EndState extends FlxState
{
	var _btnRestart:FlxSprite;
	var _btnExit:FlxSprite;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{

		FlxG.mouse.visible = true;

		var bgImage = new FlxSprite(0,0,Assets.getBitmapData("assets/images/endscreen.png"));
		add(bgImage);

		_btnRestart = new FlxSprite(280,200,Assets.getBitmapData("assets/images/playagain.png"));
		add(_btnRestart);


		//_btnExit = new FlxSprite(800,800,Assets.getBitmapData("assets/images/exit.png"));
		//add(_btnExit);
		
		// FlxG.sound.playMusic(AssetPaths.end_soundtrack__ogg, .5, true);
		
		super.create();
	}
	

	private function clickRestart():Void
	{
		// FlxG.switchState(new StartState());

		var mapState = new MapState();
		mapState.file = "assets/tiled/level.tmx";
		FlxG.switchState(mapState);
	}

	private function clickExit():Void
	{
		System.exit(0);
	}

	override public function update(elapsed:Float):Void
   {
      super.update(elapsed);

   		if (FlxG.mouse.overlaps(_btnRestart)) {
			if (FlxG.mouse.justPressed) {
				clickRestart();
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