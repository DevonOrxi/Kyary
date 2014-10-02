package entities;

import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import managers.BulletEmitter;
import managers.TimeMaster;

/**
 * ...
 * @author Acid
 */
class Enemy extends FlxSprite
{
	private var bulletEmitter:BulletEmitter;
	private var bulletGroup:FlxTypedGroup<Bullet>;
	//private var tm
	//private var patternQueue:Array<

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		bulletEmitter = new BulletEmitter();
		bulletGroup = new FlxTypedGroup<Bullet>();
	}
	
	override public function update():Void
	{
		super.update();		
		
		/*if(patternQueue.
		 * 
		 * */
	}
	
	public function getBulletGroup():FlxTypedGroup<Bullet>
	{
		return bulletGroup;
	}
	
	
	
}