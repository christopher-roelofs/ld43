package drifter;

import flixel.FlxSubState;

class Trigger extends Object
{
	private var state:MapState;
	
	public function new(X, Y, W, H, Name, Type) 
	{
		super(X, Y,Name,Type);
		makeGraphic(W, H, 0xffaa1111);
	}

	public function setState(State) {
        state = State ;
    }

	public function getState() {
        return state;
    }  
}