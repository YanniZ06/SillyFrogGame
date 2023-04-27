package;

import sys.FileSystem;
import sys.FileTools;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

using StringTools;
class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, PlayState,60,60,true));

		FlxG.autoPause = false;
		preloadAssets();
		@:privateAccess FlxG.mouse.visible = CursorHand.mousePosDebug; //We override it anyways sooo
	}

	function preloadAssets() {
		var rawAssetPaths = FileTools.readDirectoryFull('assets', true);
		for (path in rawAssetPaths) {
			if(FileSystem.isDirectory(path) || path.contains('unpackedImages')) continue;
			final pathDiv = path.split('.');
			switch(pathDiv[1]) { //File Extension
				case "png": AssetUtil.getGraphic(pathDiv[0]); // Preload these all into the cache mm yummy
				case "ogg": AssetUtil.getSound(pathDiv[0]);
			}
		}
	}
}
