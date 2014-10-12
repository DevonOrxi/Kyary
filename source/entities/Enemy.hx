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
	
	@:isVar public var bulletGroup(get, null):FlxTypedGroup<Bullet>;
	@:isVar public var chargeAnim(get, null):ChargeAnim;
	private var shootingPoint:FlxPoint;
	private var bulletQueue:Array<Bullet>;
	private var movementQueue:Array<MovementStep>;
	private var chargeQueue:Array<Float>;

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
		shootingPoint = FlxPoint.weak(74, height / 2);
		
		x = 380;
		y = (FlxG.height - height) / 2;
		
		bulletGroup = new FlxTypedGroup<Bullet>();
		bulletQueue = new Array<Bullet>();
		movementQueue = new Array<MovementStep>();
		chargeQueue = new Array<Float>();
		chargeAnim = new ChargeAnim();
		
		PatternArchitect.createQueue(bulletQueue, movementQueue, chargeQueue, data);
	}
	
	override public function update():Void {
		super.update();
		
		var checkShoot = false;
		while (bulletQueue.length > 0 && bulletQueue[0].activationTime <= FlxG.sound.music.time) 
		{
			if (!checkShoot)
				FlxG.sound.play("assets/sounds/shoot2.wav", 0.04, false, false);
			var b:Bullet = bulletQueue.shift();
			b.setPosition(x + shootingPoint.x - b.width / 2, y + shootingPoint.y - b.height / 2);
			bulletGroup.add(b);
		}
		
		while (movementQueue.length > 0 && movementQueue[0].activationTime <= FlxG.sound.music.time) {
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
		
		if (chargeAnim.alive)
		{
			chargeAnim.x = x + shootingPoint.x - chargeAnim.width / 2;
			chargeAnim.y = y + shootingPoint.y - chargeAnim.height / 2;
		}
		
		
		while (chargeQueue.length > 0 && chargeQueue[0] <= FlxG.sound.music.time) {
			chargeQueue.shift();
			chargeAnim.revive();
			chargeAnim.animation.play("charge1");
			FlxG.sound.play("assets/sounds/charge.wav", 1.1, false, false);
			trace("wat");
		}
	}
	
	public function get_bulletGroup():FlxTypedGroup<Bullet>	{
		return bulletGroup;
	}
	
	public function get_chargeAnim():ChargeAnim	{
		return chargeAnim;
	}
	
	
	
}