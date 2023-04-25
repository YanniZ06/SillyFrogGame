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
		addChild(new FlxGame(0, 0, PlayState));

		FlxG.autoPause = false;
		preloadAssets();
		//FlxG.mouse.visible = false;
	}

	function preloadAssets() {
		var rawAssetPaths = FileTools.readDirectoryFull('assets', true);
		for (path in rawAssetPaths) {
			if(FileSystem.isDirectory(path) || path.contains('unpackedImages')) continue;
			if(path.endsWith('.png')) AssetUtil.getGraphic(path.replace('.png', '')); //Preload these all into the cache mm yummy
		}
	}
}
