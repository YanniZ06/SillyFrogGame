package;

import flixel.math.FlxPoint;
import flixel.FlxG;
import openfl.events.MouseEvent;
import flixel.input.mouse.FlxMouse;
import AssetUtil as Spr;

class CursorHand extends AssetUtil.SpriteBase {
    var ref:FlxMouse;
	final mouse_listeners:Array<openfl.events.EventType<openfl.events.MouseEvent>> = [
		MouseEvent.MOUSE_DOWN,
		MouseEvent.MOUSE_MOVE,
		MouseEvent.MOUSE_UP
	];

    public function new(refMouse:FlxMouse) {
        super(0,0);
		ref = refMouse;

		frames = Spr.animFrames('cursor/cursor');
		for (name in ["main", "fly", "grab", "pet"]) animation.addByPrefix(name, name, 1); // Init all the animations
		animation.play("main");
        offset.add(13, -14.5); //So the finger is actually where the mouse points to!! (FOR MAIN ANIM ONLY RN,, GET WAY FOR ALL OF THEM QUICKLY)
		this.setPosition(ref.screenX, ref.screenY); //Make sure to snap it in on init

		for (listener in mouse_listeners) FlxG.stage.addEventListener(listener, inputCheck);
    }

	public function inputCheck(event:MouseEvent) {
        switch(event.type) {
			case MouseEvent.MOUSE_DOWN:
                animation.play("pet");
            case MouseEvent.MOUSE_UP:
            case MouseEvent.MOUSE_MOVE:
                this.setPosition(ref.screenX, ref.screenY);
        }
    }
}