package;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.Assets as OpenFlAssets;

enum Resetables {
	SPRITE;
	POS;
}

/**
 * A very basic asset utility system due to time constraints lmao!!
 */
class AssetUtil
{
	public static var currentTrackedAssets:Array<String> = [];

	// Quickly janked stffs from denpa lmaoo (seperate project im on)
	inline static public function animFrames(key:String) 
		return FlxAtlasFrames.fromSparrow(getGraphic(key), 'assets/$key.xml');

	public static function getGraphic(key:String, persist:Bool = true):FlxGraphic
	{
		var path:String = 'assets/$key.png';
		if (OpenFlAssets.exists(path, IMAGE))
		{
			if (!currentTrackedAssets.contains(path) && !FlxG.bitmap.checkCache(path))
			{
				var newGraphic:FlxGraphic = FlxG.bitmap.add(path, false, path);
				newGraphic.persist = persist;
				currentTrackedAssets.push(path);
			}
			return FlxG.bitmap.get(path);
		}

		trace('img is null assets/$key.png ');
		return null;
	}
}

class SpriteBase extends flixel.FlxSprite {
	var defaultScale:flixel.math.FlxPoint = new flixel.math.FlxPoint(4, 4);
	public function new(x:Float, y:Float, ?customScale:flixel.math.FlxPoint = null)
	{
		super(x, y);
		final usedScale = customScale != null ? customScale : defaultScale;
		scale.set(usedScale.x, usedScale.y);
		antialiasing = false;
	}
}
