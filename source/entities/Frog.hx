package entities;

import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.math.FlxPoint;
//import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import AssetUtil as Spr;

class Frog extends AssetUtil.SpriteBase {
    public function new(x:Float, y:Float) {
		super(x, y);

        frames = Spr.animFrames('frog/frog');
		for (name in ["idle", "eat", "grab", "throw", "croak", "pet"]) animation.addByPrefix(name, name, 30, false/*, name == "pet"*/); //Init all the animations (and loop pet)
        animation.play("idle");

		animation.finishCallback = (name:String) ->
		{
			switch (name)
			{
				case "pet":
					playAnim("idle");
					busy = false;
					bounce(true);
					PlayState.cur.cursor.visible = true;
				case "croak" | "eat":
					playAnim("idle");
					busy = false;
					if (name == "eat") bounce(false);
			}
		}
    }

	public function playAnim(name:String = "idle", force:Bool = true, reverse:Bool = false):Bool {
        //if(!canPlayAnim(name)) return false;

        animation.play(name, force, reverse);
        return true;
    }

    var curChance:Float = 6;
    public function bounce(bounceStep:Bool) {
        if(busy) return;

		final vals:FlxPoint = bounceStep ? new FlxPoint(defaultScale.x + 0.25, defaultScale.y - 0.25) : new FlxPoint(defaultScale.x - 0.25, defaultScale.y + 0.25);
        scale.set(vals.x, vals.y);
		FlxTween.tween(this, {"scale.x": defaultScale.x, "scale.y": defaultScale.y}, 0.6, {ease: FlxEase.sineOut,
            onComplete: (_) -> bounce(!bounceStep)
        });
		if (FlxG.random.bool(curChance / (15 * FlxG.random.float(0.7, 2)))) {
			playAnim("croak", false);
            FlxG.sound.play(Spr.getSound('frog/croak'), 0.8);
			curChance = FlxG.random.int(3, 6);
        }
		else curChance *= 2;
    }

    public var busy = false;
    public function pet():Bool {
        if(busy) return false;

		busy = true;
		FlxTween.tween(this, {"scale.x": defaultScale.x, "scale.y": defaultScale.y}, 0.2, {
			ease: FlxEase.cubeOut
		});

		FlxG.sound.play(Spr.getSound('frog/happyCroak'), 0.8);
        playAnim("pet");
		return true;
    }

    /*public function canPlayAnim(name:String = "idle"):Bool {
		switch (name) //Logic to check if one animation cannot be played goes riiight here
		{
			case "idle":
			default:
				//trace('animation "$name" is [CURRENTLY UNIMPLEMENTED!!]!'); //! CHANGE THIS LATER
				//return false;  //! UNCOMMENT LATER
		}
        return true;
    }*/
}