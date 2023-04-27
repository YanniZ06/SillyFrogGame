package;

import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.FlxG;
import openfl.events.MouseEvent;
import openfl.events.KeyboardEvent;
import flixel.input.mouse.FlxMouse;
import AssetUtil as Spr;

class CursorHand extends AssetUtil.SpriteBase {
    public var ref:FlxMouse;
	final mouse_listeners:Array<openfl.events.EventType<openfl.events.MouseEvent>> = [
		MouseEvent.MOUSE_DOWN,
		MouseEvent.MOUSE_MOVE,
		MouseEvent.MOUSE_UP
	];

	final offsets:Map<String, FlxPoint> = [
		"main" => new FlxPoint(13, -14.5),
		"pet" => new FlxPoint(29, 16),
		"grab" => new FlxPoint(25, 10),
		"fly" => new FlxPoint(18, -6)
	];

	var curAnim:Int = 0;
    public function new(refMouse:FlxMouse) {
        super(0,0);
		ref = refMouse;

		frames = Spr.animFrames('cursor/cursor');
		for (name in ["main", "fly", "grab", "pet"]) animation.addByPrefix(name, name, 1); // Init all the animations
		animation.play("main");
        offset.set(13, -14.5); //So the finger is actually where the mouse points to!! (FOR MAIN ANIM ONLY RN,, GET WAY FOR ALL OF THEM QUICKLY)
		this.setPosition(ref.screenX, ref.screenY); //Make sure to snap it in on init
		
		for (listener in mouse_listeners) FlxG.stage.addEventListener(listener, inputCheck);

		#if debug
		setUpMouseDebug(); // Debug mouse positioning tool!! (Scuffy ik but time crunch and allat)
		#end
    }

	public function changeAnim(anim:String, force:Bool = true, reverse:Bool = false) {
		animation.play(anim, force, reverse);

		final curOffset = offsets.get(anim);
		offset.set(curOffset.x, curOffset.y);
	}
	//Would be cool,, but its not 100% functional as inteded so fuck it i guess!
	inline function forcePos(x:Float, y:Float)
		openfl.Lib.application.window.warpMouse(Std.int(y), Std.int(y));

	public function inputCheck(event:MouseEvent) {
        switch(event.type) {
			case MouseEvent.MOUSE_DOWN:
				if (ref.overlaps(PlayState.cur.frog)) { 
					visible = false;
					PlayState.cur.frog.pet();
				}
            case MouseEvent.MOUSE_UP:
            case MouseEvent.MOUSE_MOVE:
                this.setPosition(ref.screenX, ref.screenY);
				if (ref.overlaps(PlayState.cur.frog)) changeAnim("pet");
				else if(animation.curAnim.name == "pet") changeAnim("main");
        }
    }

	static inline final mousePosDebug:Bool = false;
	#if debug
	private function setUpMouseDebug() {
		if(!mousePosDebug) return;
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, (event:KeyboardEvent) -> {
			final realKey = event.keyCode;
			final oldOffset = offsets[animation.curAnim.name];
			inline function setOff(x:Float, y:Float)
				offsets.set(animation.curAnim.name, new FlxPoint(oldOffset.x + x, oldOffset.y + y));

			switch(realKey) {
				case COMMA: 
					final anims = animation.getNameList();
					curAnim = curAnim+1 < 3 ? curAnim+1 : 0;
					changeAnim(anims[curAnim]);
				case FlxKey.LEFT: setOff(-1, 0);
				case FlxKey.UP: setOff(0, 1);
				case FlxKey.DOWN: setOff(0, -1);
				case FlxKey.RIGHT: setOff(1, 0);
			}
			changeAnim(animation.curAnim.name);
			this.setPosition(ref.screenX, ref.screenY);
			trace(offsets[animation.curAnim.name]);
		});
	}
	#end
}