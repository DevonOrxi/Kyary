package entities;

import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxPoint;

import managers.TimeMaster;
import managers.PatternArchitect;
import managers.MovementStep;

import haxe.xml.Fast;

/**
 * ...
 * @author Acid
 */
class Enemy extends FlxSprite
{
	
	@:isVar public var bulletGroup(get,null):FlxTypedGroup<Bullet>;
	private var bulletQueue:Array<Bullet>;
	private var movementQueue:Array<MovementStep>;
	private var type:String = "enemy";

	public function new(X:Float=0, Y:Float=0, data:Fast) {
		super(X, Y);
		
		loadGraphic("assets/images/boxx_nb.png");
		
		/*width = 104;
		height = 118;
		origin.x = -12;
		origin.y = -4;
		offset.x = 12;
		offset.y = 4;*/
		
		health = GC.enemyMaxHealth;
		
		x = 380;
		y = (FlxG.height - height) / 2;
		
		bulletGroup = new FlxTypedGroup<Bullet>();
		bulletQueue = new Array<Bullet>();
		movementQueue = new Array<MovementStep>();
		
		PatternArchitect.createQueue(bulletQueue, movementQueue, data);
	}
	
	override public function update():Void {
		super.update();		
		
		while (bulletQueue.length > 0 && bulletQueue[0].activationTime <= FlxG.sound.music.time)
		{
			var b:Bullet = bulletQueue.shift();
			b.setPosition(x + width / 2 - b.width / 2, y + height / 2 - b.height / 2);
			bulletGroup.add(b);
		}
		
		while (movementQueue.length > 0 && movementQueue[0].activationTime <= FlxG.sound.music.time)
		{
			var m:MovementStep = movementQueue.shift();
			var p:FlxPoint = new FlxPoint();
			switch(m.x) {
				case "center":
					p.x = FlxG.width / 2  - width / 2;
				case "null":
					p.x = x;
				default:
					p.x = Std.parseFloat(m.x)  - width / 2;
			}
			switch(m.y) {
				case "center":
					p.y = FlxG.height / 2 - height / 2;
				case "null":
					p.y = y;
				default:
					p.y = Std.parseFloat(m.y) - height / 2;
			}
			
			FlxTween.tween(this, { x:p.x, y:p.y }, m.duration / 1000, { type:FlxTween.ONESHOT, ease:FlxEase.cubeInOut } );
		}
	}
	
	public function get_bulletGroup():FlxTypedGroup<Bullet>	{
		return bulletGroup;
	}
	
	
	
}