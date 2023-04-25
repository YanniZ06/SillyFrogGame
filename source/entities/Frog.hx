package entities;

import flixel.math.FlxPoint;
import flixel.FlxSprite;
import AssetUtil as Spr;

class Frog extends AssetUtil.SpriteBase {
    public function new(x:Float, y:Float) {
		super(x, y);

        frames = Spr.animFrames('frog/frog');
		for (name in ["idle", "eat", "grab", "throw", "croak", "pet"]) animation.addByPrefix(name, name, 30, name == "pet"); //Init all the animations (and loop pet)
        animation.play("idle");
    }


	public function playAnim(name:String = "idle", force:Bool = true, reverse:Bool = false):Bool {
        if(!canPlayAnim(name)) return false;

        animation.play(name, force, reverse);
        return true;
    }

    public function canPlayAnim(name:String = "idle"):Bool {
		switch (name) //Logic to check if one animation cannot be played goes riiight here
		{
			case "idle":
			default:
				//trace('animation "$name" is [CURRENTLY UNIMPLEMENTED!!]!'); //! CHANGE THIS LATER
				//return false;  //! UNCOMMENT LATER
		}
        return true;
    }
}