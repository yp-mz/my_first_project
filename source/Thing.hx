package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.macro.Expr.Case;

class Thing extends FlxSprite
{
	public var state:PlayState;

	public var random:Float;

	// pea
	public var damage:Int;
	public var PLANT:Plant;

	// card
	public var card:FlxSprite;
	public var sunshineText:FlxText;
	public var plantNum:Int;
	public var needSunshine:Int;
	public var cd:Float;
	public var cardType:String = 'normal';
	public var placingPlant:Thing;
	public var havePlant:Bool = false;
	public var canPut:Bool = true;

	// placingPlant
	public var CARD:Thing;

	public var whitePlant:FlxSprite;

	public var thingType:String;
	public var type:String;
	public var plantType:String;

	public var gravity:Float;
	public var power:Float;

	public function new(x, y, thingType:String, ?type:String, ?plant:Plant, ?zombie:Zombie, ?plantNum:Int, ?state:PlayState, ?card:Thing)
	{
		super(x, y);
		this.type = type;
		this.plantNum = plantNum;
		this.state = state;
		this.thingType = thingType;
		this.CARD = card;
		this.PLANT = plant;
		switch (thingType)
		{
			case 'pea':
				switch (plant.bulletType)
				{
					case 'normal':
						loadGraphic('assets/images/things/ProjectilePea.png');
						gravity = 0;
						damage = 1;
				}
				state.bulletBox[plant.line].add(this);
			// state.bullets.add(this);
			case 'sunshine':
				frames = Tools.getFrames('assets/images/things/sunshine');
				animation.addByPrefix('idle', 'sun', 20, true);
				animation.play('idle');
				state.add(this);
				if (type != 'flower')
				{
					setGraphicSize(Std.int(width * 1.2), Std.int(height * 1.2));
					random = new FlxRandom().float(y + 100, 480);
					FlxTween.linearMotion(this, x, y, x, random, (random - y) / 100);
					new FlxTimer().start(((random - y) / 100) + 6, function(a:FlxTimer)
					{
						state.remove(this);
					});
				}
				else
				{
					alpha = 0;
					FlxTween.tween(this, {alpha: 1}, 0.5, {ease: FlxEase.sineOut});
					FlxTween.quadMotion(this, x - 50, y - 50, x - new FlxRandom().int(60, 65), y - 150, x - new FlxRandom().int(70, 80), y - 20, 0.5);
					new FlxTimer().start(6.5, function(a:FlxTimer)
					{
						state.remove(this);
					});
				}
			case 'placingPlant':
				buildPlacingPlant(plantNum);
				state.add(this);
			case 'card':
				buildCard(plantNum);
				state.add(this);
			// case 'effect':
			// 	switch (type)
			// 	{
			// 		case 'pea':
			// 			loadGraphic('assets/images/things/pea_splats.png', true, 24, 24);
			// 			animation.add('run', [3, 2, 1, 0], 24, false);
			// 			animation.play('run');
			// 			setGraphicSize(Std.int(width * 2), Std.int(height * 2));
			// 			new FlxTimer().start(0.3, function(a:FlxTimer)
			// 			{
			// 				state.remove(this);
			// 			});
			// 	}
			// 	state.add(this);废弃,不会用flxel做粒子效果
			case 'limb':
				switch (zombie.type)
				{
					case 'normal':
						switch (zombie.limbType)
						{
							case 'arm':
								loadGraphic('assets/images/things/ZombieArm.png');
								gravity = 0;
								FlxTween.linearMotion(this, x, y, x + 15, y + 50, 0.3, {ease: FlxEase.bounceOut});
								FlxTween.angle(this, angle, 90, 0.3, {ease: FlxEase.sineIn});
								new FlxTimer().start(1, function(a:FlxTimer)
								{
									FlxTween.tween(this, {alpha: 0}, 0.3);
									new FlxTimer().start(0.3, function(a:FlxTimer)
									{
										state.remove(this);
									});
								});
							case 'head':
								loadGraphic('assets/images/things/ZombieHead.png');
								gravity = 0;
								setGraphicSize(Std.int(width * 0.85), Std.int(height * 0.85));
								FlxTween.quadMotion(this, x, y, zombie.x + 8, zombie.y - 120, zombie.x + 10, y + 80, 1, {
									ease: FlxEase.bounceOut
								});
								FlxTween.angle(this, angle, 24, 0.5, {ease: FlxEase.sineIn});
								new FlxTimer().start(1.7, function(a:FlxTimer)
								{
									FlxTween.tween(this, {alpha: 0}, 0.3);
									new FlxTimer().start(0.3, function(a:FlxTimer)
									{
										state.remove(this);
									});
								});
						}
				}
				state.add(this);
			case 'armor':
				switch (zombie.armorType)
				{
					case 'cone':
						loadGraphic('assets/images/things/cone.png');
						setGraphicSize(Std.int(width * 2), Std.int(height * 2));
						FlxTween.quadMotion(this, x, y, x + 20, y - 80, x + 40, y + 120, 1, {
							ease: FlxEase.bounceOut
						});
						FlxTween.angle(this, angle, 24, 1, {ease: FlxEase.sineIn});
						new FlxTimer().start(1, function(a:FlxTimer)
						{
							FlxTween.tween(this, {alpha: 0}, 0.3);
							new FlxTimer().start(0.3, function(a:FlxTimer)
							{
								state.remove(this);
							});
						});
					case 'bucket':
						loadGraphic('assets/images/things/bucket.png');
						setGraphicSize(Std.int(width * 2), Std.int(height * 2));
						FlxTween.quadMotion(this, x, y, x + 20, y - 80, x + 40, y + 120, 1, {
							ease: FlxEase.bounceOut
						});
						FlxTween.angle(this, angle, 24, 1, {ease: FlxEase.sineIn});
						new FlxTimer().start(1, function(a:FlxTimer)
						{
							FlxTween.tween(this, {alpha: 0}, 0.3);
							new FlxTimer().start(0.3, function(a:FlxTimer)
							{
								state.remove(this);
							});
						});
				}
				state.add(this);
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		switch (thingType)
		{
			case 'pea':
				peaFunc();
			case 'card':
				cardFunc();
			case 'placingPlant':
				placingPlantFunc();
			case 'sunshine':
				sunshineFunc();
		}
		/* if (gravity != 0)
			y += gravity; */
	}

	function sunshineFunc()
	{
		if (FlxG.mouse.x > x && FlxG.mouse.x < x + width && FlxG.mouse.y > y && FlxG.mouse.y < y + height && FlxG.mouse.justPressed) // 卡片高140,宽100
		{
			// plant[0] = new Plant(100, 100, 1);
			// add(plant[0]);
			state.sunshine += 25;
			FlxG.sound.play('assets/sounds/points.ogg');
			FlxTween.linearMotion(this, x, y, state.seedbank.x - 70, state.seedbank.y - 40,
				/* Math.sqrt((x - (state.seedbank.x - 70)) * (x - (state.seedbank.x - 70))
					+ (y - (state.seedbank.y - 40)) * (y - (state.seedbank.y - 40))) / 1000 */ 1, // 太耗性能了
				true, {
					ease: FlxEase.expoOut
				}); // 勾股定理求出斜边长除以速度(100)求出时间,可以使阳光进入银行时的运动规律有序

			FlxTween.tween(this, {alpha: 0}, /* Math.sqrt((x - (state.seedbank.x - 70)) * (x - (state.seedbank.x - 70))
				+ (y - (state.seedbank.y - 40)) * (y - (state.seedbank.y - 40))) / 1000 */ 1, {
					ease: FlxEase.expoIn
				});

			new FlxTimer().start(/* (Math.sqrt((x - (state.seedbank.x - 70)) * (x - (state.seedbank.x - 70))
				+ (y - (state.seedbank.y - 40)) * (y - (state.seedbank.y - 40))) / 1000 */ 1, function(a:FlxTimer)
			{
				state.remove(this);
			});
			// });
		}
		new FlxTimer().start((random - y) / 100 + 6, function(a:FlxTimer)
		{
			state.remove(this);
		});
	}

	function placingPlantFunc()
	{
		x = FlxG.mouse.x - 30;
		y = FlxG.mouse.y - 30;
		var gardenX = state.bg.x + 260;
		var gardenY = state.bg.y + 80;
		var line:Int;
		var column:Int;
		/* if (FlxG.mouse.x >= gardenX && FlxG.mouse.x <= gardenX + 720 || FlxG.mouse.y >= gardenY && FlxG.mouse.y <= gardenY + 500)
			{ */
		// whitePlant.visible = true;
		column = Std.int((FlxG.mouse.x - gardenX) / 80);
		line = Std.int((FlxG.mouse.y - gardenY) / 100);
		if (line < 0)
			line = 0;
		else if (column < 0)
			column = 0;
		else if (line > 4)
			line = 4;
		else if (column > 8)
			column = 8;
		whitePlant.x = column * 80 + gardenX;
		whitePlant.y = line * 100 + gardenY + 20;
		// }
		/* if (FlxG.mouse.x >= state.bg.x + 280 && FlxG.mouse.x <= state.bg.x + 910 && FlxG.mouse.y >= state.bg.y + 100 && FlxG.mouse.y <= state.bg.y + 500)
			{
				whitePlant.visible = true;
				whitePlant.x = Std.int(FlxG.mouse.x - 30);
		}*/
		/* if (havePlant)
			{
				// trace(FlxG.mouse.justPressed);
				new FlxTimer().start(0.03, function(tmr:FlxTimer)
				{ */
		if ((((state.place[line * 9 + column] == 0 || state.place[line * 9 + column] == 2) && plantType == 'normal') // 植物能放在地上也能放在南瓜头上
			|| ((state.place[line * 9 + column] == 1 || state.place[line * 9 + column] == 0) && plantType == 'armor') // 南瓜头能放在植物上也能放在地上
			|| (state.place[line * 9 + column] == -1 && plantType == 'buoy')
			|| (state.place[line * 9 + column] == -1 && plantType == 'water')
			|| (state.place[line * 9 + column] == -2 && plantType == 'pot')) && state.place[line * 9 + column - 1] != -3)
		{ // 不同的地形能放不同植物
			whitePlant.visible = true;
			if (FlxG.mouse.justPressed)
			{
				new Plant(whitePlant.x, whitePlant.y, plantNum, line, column, plantType, state);
				/*var c:Int = Std.int((plant[0].x - 270) / 80);
					var l:Int = Std.int((plant[0].y - 90) / 100);
					plant[9 * (l - 1) + c] = new Plant(c * 80 + 270, l * 100 + 90, 1);
					plant[9 * (l - 1) + c].isDown = true; */
				CARD.canPut = false;
				CARD.havePlant = false;
				CARD.cdFunc();
				switch (plantType)
				{
					case 'normal':
						state.place[line * 9 + column] += 1;
						FlxG.sound.play('assets/sounds/plant.ogg');
					case 'armor':
						state.place[line * 9 + column] += 2;
						FlxG.sound.play('assets/sounds/plant.ogg');
					case 'water':
						state.place[line * 9 + column] = 4;
						FlxG.sound.play('assets/sounds/plant_water.ogg');
					case 'buoy':
						state.place[line * 9 + column] = 0;
						FlxG.sound.play('assets/sounds/plant_water.ogg');
					case 'pot':
						state.place[line * 9 + column] = 0;
						FlxG.sound.play('assets/sounds/plant2.ogg');
				}
				state.remove(whitePlant);
				state.remove(this);
			}

			// new FlxTimer().start(0.03, function(a:FlxTimer)
			// {
			// CARD.havePlant = false;
			// }); // 按下鼠标会有0.03秒的缓冲,如果直接定义,则另一边的鼠标检测也会触发
			// 我是傻逼
		}
		else
			whitePlant.visible = false;
		/* }); */
	}

	function peaFunc()
	{
		x += 3;
		if (x >= state.bg.x + 1800)
		{
			state.bulletBox[PLANT.line].remove(this, true);
		}
		// FlxG.collide(this, state.zombieBox[PLANT.line], function(a:Thing, b:Zombie)
		// {
		// 	b.body.setColorTransform(1.3, 1.3, 1.3);
		// 	b.head.setColorTransform(1.3, 1.3, 1.3);
		// 	b.arm.setColorTransform(1.3, 1.3, 1.3);
		// 	if (b.haveLimbs[0])
		// 		b.armor.setColorTransform(1.3, 1.3, 1.3);
		// 	new FlxTimer().start(0.1, function(a:FlxTimer)
		// 	{
		// 		b.body.setColorTransform(1, 1, 1);
		// 		b.head.setColorTransform(1, 1, 1);
		// 		b.arm.setColorTransform(1, 1, 1);
		// 		if (b.haveLimbs[0])
		// 			b.armor.setColorTransform(1, 1, 1);
		// 	});
		// 	if (b.haveLimbs[0])
		// 	{
		// 		b._armorHealth -= damage;
		// 	}
		// 	else
		// 		b._health -= damage;
		// 	state.bulletBox[PLANT.line].remove(this);
		// 	state.bullets.remove(this);
		// }); // FlxFlicker.flicker(this, 0.2, 0.04, true);
	}

	function cardFunc()
	{
		if (needSunshine <= state.sunshine && !havePlant && canPut)
		{
			setColorTransform(1, 1, 1);
			card.setColorTransform(1, 1, 1);
		}
		else
		{
			setColorTransform(0.7, 0.7, 0.7);
			card.setColorTransform(0.7, 0.7, 0.7);
		}
		if (canPut)
		{
			if (needSunshine <= state.sunshine)
			{
				if (!havePlant && FlxG.mouse.x > card.x && FlxG.mouse.x < card.x + card.width && FlxG.mouse.y > card.y
					&& FlxG.mouse.y < card.y + card.height && FlxG.mouse.justPressed) // 卡片高140,宽100
				{
					// plant[0] = new Plant(100, 100, 1);
					// add(plant[0]);
					state.sunshine -= needSunshine;
					FlxG.sound.play('assets/sounds/seedlift.ogg');
					new FlxTimer().start(0.03, function(a:FlxTimer)
					{
						placingPlant = new Thing(0, 0, 'placingPlant', plantNum, state, this);
						// new FlxTimer().start(0.2, function(tmr:FlxTimer)
						// {
						// placingPlant.havePlant = true;
						havePlant = true;
					}); // });// 按下鼠标会有0.03秒的缓冲,如果直接定义,则另一边的鼠标检测也会触发
				}
			}
			if (havePlant && FlxG.mouse.x > card.x && FlxG.mouse.x < card.x + card.width && FlxG.mouse.y > card.y && FlxG.mouse.y < card.y + card.height
				&& FlxG.mouse.justPressed) // 卡片高140,宽100
			{
				// plant[0] = new Plant(100, 100, 1);
				// add(plant[0]);
				state.remove(placingPlant.whitePlant);
				state.remove(placingPlant);
				state.sunshine += needSunshine;
				havePlant = false;
				// });
			}
		}
		// if (havePlant)
		// {
		// 	// trace(FlxG.mouse.justPressed);
		// 	new FlxTimer().start(0.03, function(tmr:FlxTimer)
		// 	{
		// 		if (FlxG.mouse.justPressed)
		// 		{
		// 			/*var c:Int = Std.int((plant[0].x - 270) / 80);
		// 				var l:Int = Std.int((plant[0].y - 90) / 100);
		// 				plant[9 * (l - 1) + c] = new Plant(c * 80 + 270, l * 100 + 90, 1);
		// 				plant[9 * (l - 1) + c].isDown = true; */
		// 			plant.isWorking = true;
		// 			plant.isDone = true;
		// 			havePlant = false;
		// 		}
		// 	});
		// }
	}

	function buildPlacingPlant(plantNum:Int)
	{
		whitePlant = new FlxSprite();
		switch (plantNum)
		{
			case 1:
				loadGraphic('assets/images/plants/$plantNum.png', true, 74, 73);
				whitePlant.loadGraphic('assets/images/plants/$plantNum.png', true, 74, 73);
				plantType = 'normal';
			case 2:
				loadGraphic('assets/images/plants/$plantNum.png', true, 63, 64);
				whitePlant.loadGraphic('assets/images/plants/$plantNum.png', true, 63, 64);
				plantType = 'normal';
			case 3:
				loadGraphic('assets/images/plants/$plantNum.png', true, 71, 73);
				whitePlant.loadGraphic('assets/images/plants/$plantNum.png', true, 71, 71);
				plantType = 'normal';
			case 4:
				loadGraphic('assets/images/plants/$plantNum.png', true, 99, 78);
				whitePlant.loadGraphic('assets/images/plants/$plantNum.png', true, 99, 78);
				plantType = 'normal';
		}
		whitePlant.alpha = 0.7;
		state.add(whitePlant);
	}

	function buildCard(num:Int)
	{
		switch (num)
		{
			case 1:
				loadGraphic('assets/images/plants/$num.png', true, 74, 73);
				setGraphicSize(Std.int(width * 0.7), Std.int(height * 0.7));
				needSunshine = 100;
				cardType = 'normal';
				cd = 5;
			case 2:
				loadGraphic('assets/images/plants/$num.png', true, 63, 64);
				setGraphicSize(Std.int(width * 0.7), Std.int(height * 0.7));
				needSunshine = 50;
				cardType = 'normal';
				cd = 5;
			case 3:
				loadGraphic('assets/images/plants/$num.png', true, 71, 73);
				setGraphicSize(Std.int(width * 0.7), Std.int(height * 0.7));
				needSunshine = 50;
				cardType = 'normal';
				cd = 30;
			case 4:
				loadGraphic('assets/images/plants/$num.png', true, 99, 78);
				setGraphicSize(Std.int(width * 0.4), Std.int(height * 0.4));
				needSunshine = 100;
				cardType = 'normal';
				cd = 5;
		}
		var _needSunshine:Int = needSunshine;
		var _cardType = ['gray', 'epic', 'normal', 'tool1', 'tool2', 'tool3', 'tool4', 'zombie', 'cup'];

		card = new FlxSprite(x /*  - width / 2 */, y /*  - height / 2 */);
		card.frames = Tools.getFrames('assets/images/things/seeds');
		card.setGraphicSize(Std.int(card.width * 1.2), Std.int(card.height * 1.2));
		card.antialiasing = true;
		for (i in 1..._cardType.length)
		{
			card.animation.addByPrefix('$i', 'card$i' + ' 0000');
			if (_cardType[i - 1] == cardType)
			{
				card.animation.play('$i');
				break;
			}
		}

		sunshineText = new FlxText(0, 0, 100, '$needSunshine', 12);
		sunshineText.color = FlxColor.BLACK;

		/* x -= width * 0.58; // 乱写的数据,为的是让植物看起来居中
			y -= height * 0.58; */ // 我是傻逼

		x -= width * 0.1;
		y -= height * 0.1;
		antialiasing = true;

		var i = 0;
		while (_needSunshine != 0)
		{
			_needSunshine = Std.int(_needSunshine / 10);
			i++;
			sunshineText.x = card.x + 2 * i;
			sunshineText.y = card.y + card.height * 0.8;
		}

		state.add(card);
		state.add(sunshineText);
	}

	public function cdFunc()
	{
		var _cd = new FlxSprite(card.x - 5, card.y - 10);
		state.add(_cd);
		_cd.makeGraphic(Std.int(50 * 1.2), Std.int(70 * 1.2), FlxColor.BLACK); // 卡的长宽,因为变量类型为Int,所以没法直接放卡的长宽
		_cd.alpha = 0.5;
		var i = 1;
		new FlxTimer().start(cd / 35, function(a:FlxTimer)
		{
			++i;
			_cd.setGraphicSize(Std.int(_cd.width), Std.int(_cd.height - (card.height / 35) * i));
			_cd.y -= card.height / 70;
			// _cd.setGraphicSize height -= (card.height / 14);
		}, 35);
		new FlxTimer().start(cd, function(a:FlxTimer)
		{
			state.remove(_cd);
			canPut = true;
		});
	}
}
