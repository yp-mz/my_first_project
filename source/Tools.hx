package;

class Tools
{
	public static function getFrames(way:String)
	{
		return flixel.graphics.frames.FlxAtlasFrames.fromSparrow(way + '.png', way + '.xml');
	}

	public static function getTxt(way:String)
	{
		return lime.utils.Assets.getText(way);
	}
}
