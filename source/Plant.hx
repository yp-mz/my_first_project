package;

import flixel.FlxSprite;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;

class Plant extends FlxSprite
{
	public var state:PlayState;

	public var isWorking:Bool = false;
	public var _isInHurt:Bool = false;

	public var num:Int;
	public var line:Int;
	public var column:Int;
	public var buildHealth:Int;
	public var _health:Int;

	public var power:Float;
	public var cd:Float;
	public var toX:Float;
	public var toY:Float;

	public var plantType:String;
	public var bulletType:String;
	public var directive:String;

	public function new(x:Float, y:Float, num:Int, line:Int, column:Int, plantType:String, state:PlayState)
	{
		super();
		toX = x;
		toY = y;
		this.line = line;
		this.column = column;
		this.num = num;
		this.state = state;
		this.plantType = plantType;
		switch (num)
		{
			case 1: // 豌豆射手
				bulletType = 'normal';
				frames = Tools.getFrames('assets/images/plants/$num');
				animation.addByPrefix('idle', 'idle', 24, true);
				animation.play('idle');
				buildHealth = 5;
				directive = 'attack1';
				cd = 2;
			case 2: // 向日葵
				frames = Tools.getFrames('assets/images/plants/$num');
				animation.addByPrefix('idle', 'idle', 24, true);
				animation.play('idle');
				buildHealth = 5;
				directive = 'buildSun';
				isWorking = true;
				new FlxTimer().start(new FlxRandom().int(6, 8), function(tmr:FlxTimer)
				{
					isWorking = false;
				}); // 不这样的话,向日葵一出场就会生产一个阳光
			case 3: // 坚果
				frames = Tools.getFrames('assets/images/plants/$num');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('willDie', 'willDie', 24, false);
				animation.play('idle');
				directive = 'idle';
				buildHealth = 72;
				isWorking = true;
				// case 4: // 玉米投手
				// 	bulletType = 'com';
				// 	frames = Tools.getFrames('assets/images/plants/$num');
				// 	animation.addByPrefix('idle', 'idle', 10, false);
				// 	animation.addByPrefix('throw1', 'throw1', 10, false);
				// 	animation.addByPrefix('throw2', 'throw2', 10, false);
				// 	animation.play('idle');
				// 	directive = 'throw';
				// 	buildHealth = 5;
				// 	cd = 2;
		}
		_health = buildHealth;
		state.plantBox[line].add(this);
		// state.plants.add(this);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (state.place[line * 9 + column] == -3 || _health <= 0)
		{
			switch (plantType)
			{
				case 'normal':
					state.place[line * 9 + column] = 0;
					state.plantBox[line].remove(this, true);
				case 'water':
					state.place[line * 9 + column] = -1;
					state.plantBox[line].remove(this, true);
				case 'pot':
					state.place[line * 9 + column] = -2;
					state.plantBox[line].remove(this, true);
				case 'armor':
					if (state.place[line * 9 + column] == -3)
					{
						state.plantBox[line].remove(this, true);
					}
					else
					{
						state.plantBox[line].remove(this, true);
						state.place[line * 9 + column] -= 2;
					}
			}
		}
		// 	'normal'
		// )
		// 	|| (state.place[line * 9 + column] == 1 && plantType == 'armor')
		// 	|| (state.place[line * 9 + column] == -1 && plantType == 'buoy')
		// 	|| (state.place[line * 9 + column] == -1 && plantType == 'water')
		// 	|| (state.place[line * 9 + column] == -2 && plantType == 'pot'
		// if (!isDone)
		// {
		// 	toX = FlxG.mouse.x - 30;
		// 	toY = FlxG.mouse.y - 30;
		// }
		// else
		// {
		// 	if (FlxG.collide(this, zombies, function(a:Plant, b:Zombie)
		// 	{
		// 		trace(1);
		// 		zombie = b;
		// 		if (b.zState != 'eating')
		// 		{
		// 			b.zState = 'eating';
		// 			b.stateUpDate();
		// 		}
		// 		// b.eat(true);
		// 		if (!_isInHurt)
		// 		{
		// 			_isInHurt = true;
		// 			_health -= 10;
		// 			setColorTransform(1.3, 1.3, 1.3);
		// 			new FlxTimer().start(0.1, function(a:FlxTimer)
		// 			{
		// 				setColorTransform(1, 1, 1);
		// 				new FlxTimer().start(0.3, function(a:FlxTimer)
		// 				{
		// 					_isInHurt = false;
		// 				});
		// 			});
		// 		}
		// 	})) {}
		// 	else
		// 	{
		// 		if (this.zombie != null)
		// 		{
		// 			if (this.zombie.zState != 'walking')
		// 			{
		// 				this.zombie.zState = 'walking';
		// 				this.zombie.stateUpDate();
		// 			}
		// 		}
		// 	}
		// }
		x = toX;
		y = toY;
		if (!isWorking)
		{
			work(directive);
			// isWorking = true;
		}
		if (directive == 'idle')
		{
			switch (num)
			{
				case 3:
					if (_health <= buildHealth * 0.4)
					{
						animation.play('willDie');
					}
					else
						animation.play('idle');
			}
		}

		// FlxG.collide(this, zombies, function(a:Thing, b:Zombie)
		// {
		// 	if (!isInHurt)
		// 	{
		// 		b.zState = 'eating';
		// 		b.stateUpDate = true;
		// 		isInHurt = true;
		// 		_health -= 10;
		// 		setColorTransform(1.3, 1.3, 1.3);
		// 		new FlxTimer().start(0.1, function(a:FlxTimer)
		// 		{
		// 			setColorTransform(1, 1, 1);
		// 			isInHurt = false;
		// 		}); // FlxFlicker.flicker(this, 0.2, 0.04, true);
		// 	}
		// 	if (_health <= 0)
		// 	{
		// 		b.zState = 'walking';
		// 		b.stateUpDate = true;
		// 	}
		// });
	}

	/* function bump()
		{
			if (FlxG.collide(this, zombies, function(a:Plant, b:Zombie)
			{
				trace(1);
				zombie = b;
				// b.eat(true);
				if (!_isInHurt)
				{
					_isInHurt = true;
					_health -= 10;
					setColorTransform(1.3, 1.3, 1.3);
					new FlxTimer().start(0.1, function(a:FlxTimer)
					{
						setColorTransform(1, 1, 1);
						new FlxTimer().start(0.3, function(a:FlxTimer)
						{
							_isInHurt = false;
						});
					});
				}
			})) {}
			else
				// zombie.eat(false);
	}*/
	function work(type:String)
	{
		switch (type)
		{
			case 'attack1':
				if (state.zombieBox[line].length != 0)
				{
					attack(1);
					isWorking = true;
				}
			case 'buildSun':
				build('sunshine', 1);
				isWorking = true;

			case 'throw':
				_throw();
				isWorking = true;
		}
	}

	// public function isInHurt()
	// {
	// 	if (!_isInHurt)
	// 	{
	// 		_isInHurt = true;
	// 		_health -= 10;
	// 		setColorTransform(1.3, 1.3, 1.3);
	// 		new FlxTimer().start(0.1, function(a:FlxTimer)
	// 		{
	// 			setColorTransform(1, 1, 1);
	// 			new FlxTimer().start(0.3, function(a:FlxTimer)
	// 			{
	// 				_isInHurt = false;
	// 			});
	// 		});
	// 	} // FlxFlicker.flicker(this, 0.2, 0.04, true);
	// }

	function attack(length:Int)
	{
		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			new Thing(x, y, 'pea', this, state);
		}, length);
		new FlxTimer().start(cd + 0.2 * length, function(tmr:FlxTimer)
		{
			isWorking = false;
		});
	}

	function build(type:String, length:Int)
	{
		switch (type)
		{
			case 'sunshine':
				var i:Float = 1;
				new FlxTimer().start(0.04, function(tmr:FlxTimer)
				{
					i += 0.08;
					setColorTransform(i, i, i);
				}, 5);
				new FlxTimer().start(0.2, function(tmr:FlxTimer)
				{
					new Thing(x, y, 'sunshine', 'flower', state);
				}, length);
				new FlxTimer().start(0.1 + 0.2 * length, function(tmr:FlxTimer)
				{
					new FlxTimer().start(0.04, function(tmr:FlxTimer)
					{
						i -= 0.08;
						setColorTransform(i, i, i);
					}, 5);
				});
				new FlxTimer().start(new FlxRandom().int(6, 8) + (0.2 * length + 1), function(tmr:FlxTimer)
				{
					isWorking = false;
				});
		}
	}

	function _throw()
	{
		switch (bulletType)
		{
			case 'com':
				var i = new FlxRandom().int(1, 2);
				var type = ['com', 'butter'];
				animation.play('throw$i');
				new Thing(x, y, 'throw', type[i - 1], state);
				new FlxTimer().start(cd, function(tmr:FlxTimer)
				{
					isWorking = false;
				});
		}
	}
}
