package ld43;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.ui.FlxVirtualPad;
import flixel.FlxBasic;
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

class StartState extends FlxState {
	public var file:String;

	var _btnLaunch:FlxSprite;

	override public function create():Void {

		var bgImage = new FlxSprite(0,0,Assets.getBitmapData("assets/images/startscreen.png"));
		add(bgImage);

		_btnLaunch = new FlxSprite(1260,60,Assets.getBitmapData("assets/images/play.png"));
		add(_btnLaunch);
		
		super.create();

		// FlxG.sound.playMusic(AssetPaths.start_soundtrack__ogg, .5, true);
	}

	private function clickLaunch():Void {
		var mapState = new MapState();
		mapState.file = "assets/tiled/level.tmx";
		FlxG.switchState(mapState);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (FlxG.mouse.overlaps(_btnLaunch)) {
			if (FlxG.mouse.justPressed) {
				clickLaunch();
			}
		}
	}
}
