package entities;

import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.FlxG;

import managers.TimeMaster;
import managers.PatternArchitect;

import haxe.xml.Fast;

/**
 * ...
 * @author Acid
 */
class Enemy extends FlxSprite
{
	
	private var bulletGroup:FlxTypedGroup<Bullet>;
	private var bulletQueue:Array<Bullet>;

	public function new(X:Float=0, Y:Float=0, data:Fast) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.boxx__png);
		
		/*width = 104;
		height = 118;
		origin.x = -12;
		origin.y = -4;
		offset.x = 12;
		offset.y = 4;*/
		
		health = GC.enemyHealth;
		
		x = 380;
		y = (FlxG.height - height) / 2;
		
		bulletGroup = new FlxTypedGroup<Bullet>();
		bulletQueue = new Array<Bullet>();
		
		PatternArchitect.createQueue(bulletQueue, data);
	}
	
	override public function update():Void
	{
		super.update();		
		
		while (bulletQueue.length > 0 && bulletQueue[0].getActivationTime() <= FlxG.sound.music.time)
		{
			var b:Bullet = bulletQueue.shift();
			b.setPosition(x + width / 2 - b.width / 2, y + height / 2 - b.height / 2);
			bulletGroup.add(b);
		}
	}
	
	public function getBulletGroup():FlxTypedGroup<Bullet>
	{
		return bulletGroup;
	}
	
	
	
}