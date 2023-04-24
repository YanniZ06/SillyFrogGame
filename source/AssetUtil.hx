package;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.Assets as OpenFlAssets;

/**
 * A very basic asset utility system due to time constraints lmao!!
 */
class AssetUtil
{
	public static var currentTrackedAssets:Array<String> = [];

	// Quickly janked from denpa lmaoo
	inline static public function animFrames(key:String)
		return FlxAtlasFrames.fromSparrow(getGraphic(key), 'assets/$key.xml');
}

inline public static function getGraphic(key:String, ?noPersist:Bool = false):FlxGraphic
{
	var path:String = 'assets/$key.png';
	if (OpenFlAssets.exists(path, IMAGE))
	{
		if (!currentTrackedAssets.contains(path) && !FlxG.bitmap.checkCache(path))
		{
			var newGraphic:FlxGraphic = FlxG.bitmap.add(path, false, path);
			newGraphic.persist = !noPersist;
			currentTrackedAssets.push(path);
		}
		return FlxG.bitmap.get(path);
	}

	trace('img is null assets/$key.png ');
	return null;
}
}
