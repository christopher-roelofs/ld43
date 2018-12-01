package drifter;


import flixel.FlxSprite;


class Object extends FlxSprite
{
	private var name:String;
    private var type:String;


    public function new(X:Float = 0, Y:Float = 0, Name:String, Type:String , ?SimpleGraphic) 
	{

		super(X, Y,SimpleGraphic);
        name = Name;
        type = Type;
        immovable = true;
	}

	public function getName() {
        return name;
    }

	public function getType() {
        return type;
    }

	
}