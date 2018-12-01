
import ld43.StartState;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(1600, 900, StartState,1,60,true,false));
	}
}