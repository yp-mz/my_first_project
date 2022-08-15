package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRandom;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import haxe.display.Position;

class Zombie extends FlxSprite
{
	public var state:PlayState;

	public var armor:FlxSprite;
	public var arm:FlxSprite;
	public var head:FlxSprite;
	public var body:FlxSprite;

	public var type:String;
	public var limbType:String;
	public var armorType:String;
	public var zState:String = 'walking';

	public var buildHealth:Int;
	public var armorHealth:Int;
	public var _armorHealth:Int;
	public var _health:Int;
	public var line:Int;
	public var damage:Int;
	public var random = new FlxRandom().int(1, 2);

	public var toX:Float;
	public var toY:Float;
	public var cd:Float;

	public var isInHurt:Bool = false;
	public var isHiting:Bool = false;
	public var haveLimbs:Array<Bool> = [false, true, true]; // 护具,手,头

	public function new(x:Float, y:Float, type:String, line:Int, ?_type:String, state:PlayState)
	{
		super();
		this.toX = state.bg.x + 1150;
		this.toY = line * 100 + 100;
		this.state = state;
		this.type = type;
		this.line = line;
		switch (type)
		{
			case 'normal':
				body = new FlxSprite(x, y);
				body.frames = Tools.getFrames('assets/images/zombies/normalBody');
				body.animation.addByPrefix('walk1', 'walkA', 24, true);
				body.animation.addByPrefix('walk2', 'walkB', 24, true);
				body.animation.addByPrefix('eat', 'eat', 24, true);
				body.animation.addByPrefix('die1', 'dieA', 24, false);
				body.animation.addByPrefix('die2', 'dieB', 24, false);
				body.animation.play('walk$random');
				damage = 1;
				cd = 0.8;

				// animation.play('walk');
				switch (_type)
				{
					case 'normal':
						haveLimbs = [false, true, true];
						head = new FlxSprite(x - 45, y - 54);
						arm = new FlxSprite(x - 25, y + 5);
						head.frames = Tools.getFrames('assets/images/zombies/normalHead');
						head.animation.addByPrefix('walk1', 'HwalkA', 24, true);
						head.animation.addByPrefix('walk2', 'HwalkB', 24, true);
						head.animation.addByPrefix('eat', 'Heat', 24, true);
						head.animation.play('walk$random');

						arm.frames = Tools.getFrames('assets/images/zombies/normalArm');
						arm.animation.addByPrefix('walk1', 'AwalkA', 24, true);
						arm.animation.addByPrefix('walk2', 'AwalkB', 24, true);
						arm.animation.addByPrefix('eat', 'Aeat', 24, true);
						arm.animation.play('walk$random');
						buildHealth = 10;
					case 'cone':
						haveLimbs = [true, true, true];
						head = new FlxSprite(x - 45, y - 54);
						arm = new FlxSprite(x - 25, y + 5);
						armor = new FlxSprite(x - 45, y - 57);
						head.frames = Tools.getFrames('assets/images/zombies/normalHead');
						head.animation.addByPrefix('walk1', 'HwalkA', 24, true);
						head.animation.addByPrefix('walk2', 'HwalkB', 24, true);
						head.animation.addByPrefix('eat', 'Heat', 24, true);
						head.animation.play('walk$random');

						arm.frames = Tools.getFrames('assets/images/zombies/normalArm');
						arm.animation.addByPrefix('walk1', 'AwalkA', 24, true);
						arm.animation.addByPrefix('walk2', 'AwalkB', 24, true);
						arm.animation.addByPrefix('eat', 'Aeat', 24, true);
						arm.animation.play('walk$random');
						buildHealth = 10; // 一颗豌豆一点伤害

						armor.frames = Tools.getFrames('assets/images/zombies/cone');
						armor.animation.addByPrefix('walk1', 'CwalkA', 24, true);
						armor.animation.addByPrefix('walk2', 'CwalkB', 24, true);
						armor.animation.addByPrefix('eat', 'Ceat', 24, true);
						armor.animation.play('walk$random');
						armorHealth = 19;
						armorType = 'cone';
					case 'bucket':
						haveLimbs = [true, true, true];
						head = new FlxSprite(x - 45, y - 54);
						arm = new FlxSprite(x - 25, y + 5);
						armor = new FlxSprite(x - 45, y - 57);
						head.frames = Tools.getFrames('assets/images/zombies/normalHead');
						head.animation.addByPrefix('walk1', 'HwalkA', 24, true);
						head.animation.addByPrefix('walk2', 'HwalkB', 24, true);
						head.animation.addByPrefix('eat', 'Heat', 24, true);
						head.animation.play('walk$random');

						arm.frames = Tools.getFrames('assets/images/zombies/normalArm');
						arm.animation.addByPrefix('walk1', 'AwalkA', 24, true);
						arm.animation.addByPrefix('walk2', 'AwalkB', 24, true);
						arm.animation.addByPrefix('eat', 'Aeat', 24, true);
						arm.animation.play('walk$random');
						buildHealth = 10;

						armor.frames = Tools.getFrames('assets/images/zombies/bucket');
						armor.animation.addByPrefix('walk1', 'BwalkA', 24, true);
						armor.animation.addByPrefix('walk2', 'BwalkB', 24, true);
						armor.animation.addByPrefix('eat', 'Beat', 24, true);
						armor.animation.play('walk$random');
						armorHealth = 55;
						armorType = 'bucket';
				}
				setSize(20, 60);
				offset.set(10, 20);
		}
		visible = false;
		_health = buildHealth;
		_armorHealth = armorHealth;
		state.zombieBox[line].add(this);
		state.add(body);
		state.add(head);
		if (haveLimbs[0])
			state.add(armor);
		state.add(arm);
		// state.zombies.add(this);
		// updateHitbox();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		x = toX;
		y = toY;
		if (zState != 'death')
		{
			// trace(state.bulletBox[line].length);
			FlxG.collide(this, state.bulletBox[line], function(a:Zombie, b:Thing)
			{
				nZPositionUpDate(); // 碰到子弹的时候僵尸会被强制偏移,及时调整位置
				isInHurt = true;
				if (armorType != null && armorType == 'bucket' && haveLimbs[0])
				{
					var i = new FlxRandom().int(1, 2);
					FlxG.sound.play('assets/sounds/shieldhit$i.ogg');
				}
				else
				{
					var i = new FlxRandom().int(1, 3);
					FlxG.sound.play('assets/sounds/splat$i.ogg');
				}

				// var effect = new Thing(toX, toY, 'effect', 'pea', state);
				state.bulletBox[line].remove(b, true);
				if (haveLimbs[0])
				{
					_armorHealth -= b.damage;
				}
				else
					_health -= b.damage;
			});
			if (FlxG.collide(this, state.plantBox[line], function(a:Zombie, b:Plant)
			{
				nZPositionUpDate(); // 碰到植物的时候因碰撞箱碰撞时会反弹的缘故,僵尸的offset会被强制偏移,导致body也偏移而body矫正得在下一帧所以会看到body瞬间后退然后回到原来的位置,加了这个后能在offset偏移的第一时间矫正,闪现就不会存在
				if (zState != 'eating' && zState != 'death')
				{
					zState = 'eating';
					stateUpDate();
				}
				if (!isHiting)
				{
					var i = new FlxRandom().int(1, 2);
					FlxG.sound.play('assets/sounds/chomp$i.ogg');
					isHiting = true;
					b._health -= damage;
					b.setColorTransform(1.3, 1.3, 1.3);
					new FlxTimer().start(0.1, function(a:FlxTimer)
					{
						b.setColorTransform(1, 1, 1);
						new FlxTimer().start(cd, function(a:FlxTimer)
						{
							isHiting = false;
						});
					});
				}
			})) {}
			else
			{
				if (zState != 'walking' && zState != 'death')
				{
					// nZPositionUpDate();
					zState = 'walking';
					stateUpDate();
				}
			}
		}

		// if (stateUpDate)
		// {
		if (_armorHealth <= 0 && haveLimbs[0] == true)
		{
			new Thing(armor.x, armor.y, 'armor', null, this, state);
			haveLimbs[0] = false;
			FlxG.sound.play('assets/sounds/limbs_pop.ogg');
			state.remove(armor);
		}
		if (_health <= buildHealth * 0.4 && haveLimbs[1] == true)
		{
			limbType = 'arm';
			new Thing(arm.x, arm.y, 'limb', null, this, state);
			FlxG.sound.play('assets/sounds/limbs_pop.ogg');
			haveLimbs[1] = false;
			state.remove(arm);
		}
		if (_health <= 0 && haveLimbs[2] == true)
		{
			limbType = 'head';
			new Thing(head.x, head.y, 'limb', null, this, state);
			FlxG.sound.play('assets/sounds/limbs_pop.ogg');
			haveLimbs[2] = false;
			state.remove(head);
			new FlxTimer().start(new FlxRandom().int(1, 2), function(a:FlxTimer)
			{
				zState = 'death';
				stateUpDate();
				FlxG.sound.play('assets/sounds/zombie_falling_$random');
				state.zombieBox[line].remove(this, true);
				new FlxTimer().start(3, function(a:FlxTimer)
				{
					FlxTween.tween(this, {alpha: 0}, 0.3);
					new FlxTimer().start(0.3, function(a:FlxTimer)
					{
						state.remove(body);
						state.num_of_zombies--;
						state.zombieBox[line].remove(this, true);
					});
				});
			});
		}
		if (x <= state.bg.x + 20)
		{
			_health = 0;
		}
		if (isInHurt)
		{
			body.setColorTransform(1.3, 1.3, 1.3);
			head.setColorTransform(1.3, 1.3, 1.3);
			arm.setColorTransform(1.3, 1.3, 1.3);
			if (haveLimbs[0])
				armor.setColorTransform(1.3, 1.3, 1.3);
			new FlxTimer().start(0.1, function(a:FlxTimer)
			{
				body.setColorTransform(1, 1, 1);
				head.setColorTransform(1, 1, 1);
				arm.setColorTransform(1, 1, 1);
				if (haveLimbs[0])
					armor.setColorTransform(1, 1, 1);
				isInHurt = false;
			});
		}
		nZPositionUpDate();
	}

	public function stateUpDate()
	{
		switch (zState)
		{
			case 'walking':
				arm.animation.play('walk$random');
				head.animation.play('walk$random');
				body.animation.play('walk$random');
				if (haveLimbs[0])
					armor.animation.play('walk$random');
			case 'eating':
				arm.animation.play('eat');
				head.animation.play('eat');
				body.animation.play('eat');
				if (haveLimbs[0])
					armor.animation.play('eat');
			case 'death':
				body.animation.play('die$random');
				switch (random)
				{
					case 1:
						body.x -= 70;
					case 2:
						body.x -= 70;
				}
		}
	}

	function nZPositionUpDate()
	{
		switch (zState)
		{
			case 'walking':
				body.x = toX - 10;
				body.y = toY - 17;
				switch (random)
				{
					case 1: // 豪迈
						head.x = toX - 28;
						head.y = toY - 52;
						if (haveLimbs[0])
						{
							switch (armorType)
							{
								case 'cone':
									armor.x = toX - 23;
								case 'bucket':
									armor.x = toX - 27;
							}
							armor.y = toY - 68;
						}
					case 2: // 文雅
						head.x = toX - 26;
						head.y = toY - 50;
						if (haveLimbs[0])
						{
							switch (armorType)
							{
								case 'cone':
									armor.x = toX - 17;
									armor.y = toY - 70;
								case 'bucket':
									armor.x = toX - 26;
									armor.y = toY - 67;
							}
						}
				}
				arm.x = toX - 5;
				arm.y = toY + 5;
				toX -= 0.3;
			case 'eating':
				body.x = toX - 35;
				body.y = toY - 17;
				head.x = toX - 25;
				head.y = toY - 49;
				arm.x = toX - 25;
				arm.y = toY - 25;
				if (haveLimbs[0])
				{
					switch (armorType)
					{
						case 'cone':
							armor.x = toX - 18;
							armor.y = toY - 74;
						case 'bucket':
							armor.x = toX - 25;
							armor.y = toY - 65;
					}
				}
		}
	}
}
