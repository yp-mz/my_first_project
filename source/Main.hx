package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		// var zDate = Tools.getTxt('assets/data/ZombieData.txt');
		// var plan = zDate.split('\n');
		addChild(new FlxGame(0, 0, PlayState));
	}
}
