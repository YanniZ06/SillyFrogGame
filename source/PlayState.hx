package;

import flixel.input.keyboard.FlxKey;
import openfl.events.KeyboardEvent;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import cpp.Pointer;
import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.math.FlxPoint;
import entities.*;
import flixel.FlxState;
import flixel.FlxCamera;
import AssetUtil.Resetables as Resetables; //Avoid stupid misconcenption with Spr

typedef BimText = {
	var text:String;
	var readTime:Float;
}
class PlayState extends FlxState
{
	public var frog:Frog;
	//public var music:FrogMusic;
	public static var cur:PlayState = null;
	public var cursor:CursorHand;
	
	var helpTxt:FlxText;
	var instructions:FlxText;
	var curText:Int = -1;
	var texts:Array<BimText> = [
		{text: "Hey Bimi :)", readTime: 3},
		{text: "Du sagtest du wolltest unbedingt einen Froschi..", readTime: 6},
		{text: "..also dachte ich mach dir einen kleinen digitalen!!", readTime: 4},
		{text: "Wenn du die Hand über ihn führst und die Maus drückst..", readTime: 6},
		{text: "Kannst du ihn sogar streicheln!!", readTime: 5},
		{text: "In ferner Zukunft wirst du noch viel mehr mit ihm machen können :)", readTime: 6},
		{text: "Auf jeden fall hoffe ich, dass du dich mindestens etwas freuen konntest..", readTime: 7},
		{text: "Na dann, viel spaß ihr beiden <3 Loyu - Nannick", readTime: 9}
	];
	var pic:FlxSprite;
	var curPic:Int = 1;
	override public function create() {
		super.create();
		cur = this;

		frog = new Frog(0,0);
		frog.screenCenter();
		add(frog);
		frog.bounce(false);

		pic = new FlxSprite(0,0);
		pic.loadGraphic(AssetUtil.getGraphic('gallery/frog1'));
		pic.setGraphicSize(400, 0);
		pic.screenCenter();
		pic.visible = false;
		add(pic);

		helpTxt = new FlxText(0, 0, FlxG.width, "", 18);
		helpTxt.color = FlxColor.CYAN;
		helpTxt.screenCenter();
		helpTxt.y -= 125;
		helpTxt.antialiasing = false;
		add(helpTxt);
		bimiText();

		instructions = new FlxText(0, 0, FlxG.width, "", 18);
		instructions.screenCenter();
		instructions.color = FlxColor.LIME;
		instructions.text = "M - Ein Froschi Bild zeigen!\nV - Nächstes Bild!!\nF - Füttern :)";
		instructions.y += 165;
		instructions.antialiasing = false;
		add(instructions);

		cursor = new CursorHand(FlxG.mouse); //Later add this to a seperate camera!!
		add(cursor);

		FlxG.sound.playMusic(AssetUtil.getSound('frogging_around'));

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, (event:KeyboardEvent) ->
		{
			final realKey = event.keyCode;
			function frogDesc(picture:Int) {
				final standard:String = "\nV - Nächstes Bild!!\nM - Ein Froschi Bild verstecken!";
					if (pic.visible) switch(picture) {
							case 1: instructions.text = 'Ein Desert Frog (glaube ich), quitschiger Froschi :)$standard';
							case 2: instructions.text = 'Ein handhablicher froschi!!$standard';
							case 3: instructions.text = 'Ein ganz dicker froschi, lustig!!$standard';
							case 4: instructions.text = 'Ein Pacman Frog, deine Lieblings froschiiss :))$standard';
							case 5: instructions.text = 'Die Bimis (hab ich selbst gemacht hihi <3)\nV - Zurück zum ersten bild!!\nM - Ein Froschi Bild verstecken!';
					}
			}
			switch (realKey)
			{
				case M:
					pic.visible = !pic.visible;
					if(pic.visible) frogDesc(curPic);
					else instructions.text = "M - Ein Froschi Bild zeigen!\nV - Nächstes Bild!!\nF - Füttern :)";					
				case V: 
					curPic++;
					if(curPic > 5) curPic = 1;
					frogDesc(curPic);

					pic.loadGraphic(AssetUtil.getGraphic('gallery/frog$curPic'));
					pic.setGraphicSize(400, 0);
					pic.screenCenter();
				case F:
					if(frog.busy) return;
					frog.playAnim("eat");
					frog.busy = true;
					FlxG.sound.play(AssetUtil.getSound('frog/croak'), 0.8);
			}
		});

		//music = new FrogMusic(0);
		//FlxTween.tween(music, {m_volume: 1}, 1.2);
	}

	function bimiText() {
		curText++;
		if(curText >= texts.length) {
			FlxTween.tween(helpTxt, {alpha: 0}, 1, {onComplete: (_) -> remove(helpTxt)});
			return;
		}
		final select = texts[curText];
		helpTxt.text = select.text;
		new FlxTimer().start(select.readTime, (_) -> {
			bimiText();
		});
	}

	override public function update(elapsed:Float) {
		//music.update();
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

//TIME VARIABLE CEASES TO WORK FOR NO REASON, IMPLEMENT THIS IN LATER BUILDS
class FrogMusic {
	public var current:Pointer<FlxSound>; //Pointer since it wont WORK otherwise
	var curString:String = "a";
	var snd_a:FlxSound;
	var snd_b:FlxSound;
	public var m_volume(default, set):Float;
	function set_m_volume(vol:Float):Float {
		m_volume = vol;

		snd_a.volume = snd_b.volume = vol;
		return vol;
	}

	public function new(vol:Float, playOnInit:Bool = true) {
		//this.visible = false;
		snd_a = snd_b = new FlxSound();
		snd_a.loadEmbedded(AssetUtil.getSound('frogging_around'));
		snd_b.loadEmbedded(AssetUtil.getSound('frogging_around'));

		current = Pointer.addressOf(snd_a);
		play();
		
		m_volume = vol;
	}

	public function play(forceRestart:Bool = false) current.ref.play(forceRestart);

	public function pause() current.ref.pause();

	var halt:Bool = false; //ensure it doesnt fuck up!!
	public function update() {
		@:privateAccess FlxG.watch.addQuick("songtime", current.ref);
		if (current.ref.time > 76832 && !halt)
		{
			halt = true;

			curString == "a" ? snd_b.play() : snd_a.play();
			curString = curString == "a" ? "b" : "a";
			current = curString == "a" ? Pointer.addressOf(snd_b) : Pointer.addressOf(snd_a);

			halt = false;
		}
	}
}
