package;

import flixel.FlxG;
import flixel.math.FlxPoint;
import entities.*;
import flixel.FlxState;
import flixel.FlxCamera;
import AssetUtil.Resetables as Resetables; //Avoid stupid misconcenption with Spr

class PlayState extends FlxState
{
	public var frog:Frog;
	public static var cur:PlayState = null;
	public var cursor:CursorHand;
	override public function create()
	{
		super.create();
		cur = this;

		frog = new Frog(0,0);
		frog.screenCenter();
		add(frog);
		frog.playAnim("pet");

		cursor = new CursorHand(FlxG.mouse);
		add(cursor);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	//This might not even be necessary lol!!
	public function resetFrog(toReset:Array<Resetables>):Void {
		for(rVal in toReset) {
		switch(rVal) 
		{
		case SPRITE:
			final oldPos:FlxPoint = new FlxPoint(frog.x, frog.y);
			frog = new Frog(oldPos.x, oldPos.y);
		case POS:
			frog.screenCenter();
		}
		}
	}
}
