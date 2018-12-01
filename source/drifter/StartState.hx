	
package drifter;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.ui.FlxVirtualPad;
import flixel.FlxBasic;


class StartState extends FlxState
{
	
	public var file:String;
	
	
	override public function create():Void 
	{

        var mapState = new MapState();
        mapState.file = "assets/tiled/level.tmx" ;
        FlxG.switchState(mapState);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);		
	}	
}
