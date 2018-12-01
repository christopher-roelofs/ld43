package drifter;


import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;


class Popup extends FlxTypedGroup<FlxSprite>
{
	
	private var _sprBack:FlxSprite;	// this is the background sprite
    private var myText:FlxText;
    private var 
	
	public function new(X:Float=0,Y:Float=0) 
	{
		super();

        visible = false; // default to hide until we want to show it
        active = false; // keeps object from being updared until we want   
	
		_sprBack = new FlxSprite(X,Y).makeGraphic(150, 40, FlxColor.BLACK);
        _sprBack.screenCenter();
		add(_sprBack);


        myText = new FlxText(X,Y); // x, y, width
        myText.text = "Hello World";
        myText.setFormat("assets/monsterrat.ttf", 10, FlxColor.WHITE, CENTER);
        //myText.setBorderStyle(OUTLINE, FlxColor.RED, 1);
        myText.screenCenter();
        add(myText);
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}


