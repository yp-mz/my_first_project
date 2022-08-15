package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	public var camHUD = new FlxCamera();

	public var thing:Thing;

	public var sunshine:Int = 1000;
	public var num_of_zombies:Int = 0;

	public var seedbank:FlxSprite = new FlxSprite(270, 0);
	public var bg:FlxSprite = new FlxSprite(0, 0);
	public var sunshineText:FlxText = new FlxText(230, 60, 100, null, 24);

	public var place:Array<Int> = [
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	]; // 1为有植物,2为有南瓜头,3有南瓜头保护的植物,4为水上植物,0为能放植物的地形,-1是水,-2是屋顶,-3是弹坑

	public var zombieBox = [
		new FlxTypedGroup<Zombie>(100),
		new FlxTypedGroup<Zombie>(100),
		new FlxTypedGroup<Zombie>(100),
		new FlxTypedGroup<Zombie>(100),
		new FlxTypedGroup<Zombie>(100)
	];
	public var plantBox = [
		new FlxTypedGroup<Plant>(19),
		new FlxTypedGroup<Plant>(19),
		new FlxTypedGroup<Plant>(19),
		new FlxTypedGroup<Plant>(19),
		new FlxTypedGroup<Plant>(19)
	];
	public var bulletBox = [
		new FlxTypedGroup<Thing>(100),
		new FlxTypedGroup<Thing>(100),
		new FlxTypedGroup<Thing>(100),
		new FlxTypedGroup<Thing>(100),
		new FlxTypedGroup<Thing>(100)
	];

	var havePlant:Bool = false;
	var canBuildSunshine:Bool = false;
	var canBuildZombie:Bool = false;
	var finishBuildZombie = true;
	var start = false;

	var randomX:Int;
	var randomY:Int;
	var num_of_attacks:Int = 1;

	var zombieType = ['normal', 'cone', 'bucket'];

	override public function create()
	{
		super.create();
		// add(zombies);
		FlxG.worldBounds.set(0, 0, 1400, 600);

		bg.loadGraphic('assets/images/backgrounds/1.png');
		add(bg);

		camera.width = 1400;
		camera.height = 600;
		// chooseCard();
		// camera.x -= 200;
		new FlxTimer().start(1.5, function(a:FlxTimer)
		{
			FlxTween.tween(camera, {x: -600}, 1.5, {ease: FlxEase.cubeInOut});
			new FlxTimer().start(1.8, function(a:FlxTimer)
			{
				chooseCard();
			});
		});

		seedbank.loadGraphic('assets/images/things/SeedBank.png');
		seedbank.setGraphicSize(Std.int(seedbank.width * 1.2), Std.int(seedbank.height * 1.2));
		// seedbank.cameras = [camera];
		add(seedbank);

		sunshineText.color = FlxColor.BLACK;
		// sunshineText.cameras = [camera];
		add(sunshineText);

		// add(zombies);
		for (i in 1...6)
		{
			add(zombieBox[i - 1]);
			add(plantBox[i - 1]);
			add(bulletBox[i - 1]);
		}
		for (i in 1...4)
		{
			thing = new Thing(seedbank.x + /* thing.card.width */ 60 * i, seedbank.y + 10, 'card', i, this);
			// thing.cameras = [camera];
			add(thing);
		}
		// var zombie = new Zombie(1000, 500, 'normal', 4, 'normal', this);
		// add(zombie);
		// zombie = new Zombie(800, 500, 'normal', 4, 'normal', this);
		// zombies.add(zombie);
		// zombie.kill();
		// add(zombies);
		// add(bullets);
		canBuildSunshine = true;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (num_of_zombies == 0 && finishBuildZombie && start)
		{
			buildZombie();
		}
		sunshineText.text = '$sunshine';
		var _sunshine:Int = sunshine;
		var i = 0;
		while (_sunshine != 0)
		{
			_sunshine = Std.int(_sunshine / 10);
			i++;
			sunshineText.x = seedbank.x - 9 * i;
			sunshineText.y = seedbank.y + 60;
		}
		if (sunshine == 0)
		{
			sunshineText.x = seedbank.x - 9;
			sunshineText.y = seedbank.y + 60;
		}
		if (canBuildSunshine && start)
		{
			randomX = new FlxRandom().int(250, 900);
			randomY = new FlxRandom().int(0, 90);
			var sunshine = new Thing(randomX, randomY, 'sunshine', this);
			// sunshine.cameras = [camera];
			canBuildSunshine = false;
			new FlxTimer().start(new FlxRandom().int(5, 8), function(a:FlxTimer)
			{
				canBuildSunshine = true;
			});
		}
		/*if (FlxG.keys.justPressed.X && !havePlant)
			{
				// plant[0] = new Plant(100, 100, 1);
				// add(plant[0]);
				plant = new Plant(100, 100, 1, this);
				add(plant);
				havePlant = true;
				trace(1);
			}
			if (FlxG.mouse.justPressed && havePlant)
			{
				/*var c:Int = Std.int((plant[0].x - 270) / 80);
					var l:Int = Std.int((plant[0].y - 90) / 100);
					plant[9 * (l - 1) + c] = new Plant(c * 80 + 270, l * 100 + 90, 1);
					plant[9 * (l - 1) + c].isDown = true; 
				plant.isDown = true;
				havePlant = false;
		}*/
		/*for (i in 1...46)
				if (plant[i] != null && plant[i].isWork)
				{
					add(plant[i].thing);
				}
			trace(1); */
	}

	function buildZombie()
	{
		finishBuildZombie = false;
		var buildNum = num_of_attacks * new FlxRandom().int(1, 5);
		var num = buildNum;
		num_of_zombies = buildNum;
		new FlxTimer().start(new FlxRandom().int(2, 5), function(a:FlxTimer)
		{
			var i = new FlxRandom().int(0, num_of_attacks - 1);
			trace(i);
			if (i > 2)
				i = new FlxRandom().int(0, 2);
			var line = new FlxRandom().int(0, 4);
			var type = zombieType[i];
			new Zombie(0, 0, 'normal', line, type, this);
			num--;
			if (num == 0)
			{
				finishBuildZombie = true;
				num_of_attacks++;
			}
		}, buildNum);
	}

	function chooseCard()
	{
		FlxTween.tween(camera, {x: -210}, 1.5, {ease: FlxEase.cubeInOut});
		new FlxTimer().start(1.5, function(a:FlxTimer)
		{
			start = true;
			camera.width = 1050; // 限制一下摄像机,不然会看到僵尸生成
		});
	}
}
