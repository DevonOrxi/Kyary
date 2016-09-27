package entities;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.math.FlxPoint;

import managers.TimeMaster;
import managers.QueueManager;
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
	@:isVar public var localScale(get, null):Float = 1;
	@:isVar public var hurtSFX(get,null):FlxSound;
	@:isVar public var shootSFX(get,null):FlxSound;
	@:isVar public var chargeSFX(get,null):FlxSound;
	
	private var shootingPoint:FlxPoint;
	private var bulletQueue:Array<Bullet>;
	private var movementQueue:Array<MovementStep>;
	private var chargeQueue:Array<Float>;
	private var checkShoot:Bool = false;

	public function new(X:Float=0, Y:Float=0) {
		super(X, Y);
		
		hurtSFX = FlxG.sound.load("assets/sounds/hurt.wav", 1);
		shootSFX = FlxG.sound.load("assets/sounds/shoot4.wav", 0.8);
		chargeSFX = FlxG.sound.load("assets/sounds/charge.wav", 1);
		
		loadGraphic("assets/images/boxx_nb.png");
		
		width = 190;
		height = 155;
		centerOffsets();
		centerOrigin();
		
		health = GC.enemyMaxHealth;
		shootingPoint = FlxPoint.weak(45, height / 2);
		
		x = 800;
		y = (FlxG.height - height) / 2;
		
		bulletGroup = new FlxTypedGroup<Bullet>();
		bulletQueue = QueueManager.enemyBulletQueue;
		movementQueue = QueueManager.enemyMovementQueue;
		chargeQueue = QueueManager.enemyChargeQueue;
		chargeAnim = new ChargeAnim();
	}
	
	override public function update(elapsed:Float):Void {
		
		super.update(elapsed);
		
		if (health > 0) {
			shootQueued();
			moveQueued();
			animateQueued();
		}
		
		if (TimeMaster.isBeat)
		{
			FlxTween.num(1.05, 1, TimeMaster.beatTime / (1000*8), { type: FlxTween.ONESHOT }, tweenFunction.bind(this));
		}
		
		TimeMaster.beatScale = localScale;
		scale.x = localScale;
		scale.y = localScale;
	}
	
	private function tweenFunction(s:Enemy, v:Float) { s.localScale = v; }
	
	private function shootQueued():Void {
		
		while (bulletQueue.length > 0 && bulletQueue[0].activationTime <= TimeMaster.song.time) 
		{
			shootSFX.play();
			
			var b:Bullet = bulletQueue.shift();
			b.setPosition(x + shootingPoint.x - b.width / 2, y + shootingPoint.y - b.height / 2);
			bulletGroup.add(b);
		}
		
	}
	
	private function moveQueued():Void {
		
		while (movementQueue.length > 0 && movementQueue[0].activationTime <= TimeMaster.song.time) {
			var m:MovementStep = movementQueue.shift();
			var p:FlxPoint = new FlxPoint();
			switch(m.x) {
				case "center":
					p.x = FlxG.width / 2  - width / 2;
				case "null":
					p.x = x;
				default:
					p.x = Std.parseFloat(m.x);
			}
			switch(m.y) {
				case "center":
					p.y = FlxG.height / 2 - height / 2;
				case "null":
					p.y = y;
				default:
					p.y = Std.parseFloat(m.y) - height / 2;
			}
			switch (m.type)
			{
				case "normal":
					FlxTween.tween(this, { x:p.x, y:p.y }, m.duration / 1000, { type:FlxTween.ONESHOT } );
				case "reposition":
					FlxTween.tween(this, { x:p.x, y:p.y }, m.duration / 1000, { type:FlxTween.ONESHOT, ease:FlxEase.cubeInOut } );
			}
		}
		
	}
	
	private function animateQueued():Void {
		
		if (chargeAnim.alive)
		{
			chargeAnim.x = x + shootingPoint.x - chargeAnim.width / 2;
			chargeAnim.y = y + shootingPoint.y - chargeAnim.height / 2;
		}
		
		
		while (chargeQueue.length > 0 && chargeQueue[0] <= TimeMaster.song.time) {
			chargeQueue.shift();
			chargeAnim.revive();
			chargeAnim.animation.play("charge1");
			chargeSFX.play();
		}
	}
	
	public function get_bulletGroup():FlxTypedGroup<Bullet>	{
		return bulletGroup;
	}
	
	public function get_chargeAnim():ChargeAnim	{
		return chargeAnim;
	}
	
	public function get_localScale():Float	{
		return localScale;
	}
	
	public function get_shootSFX():FlxSound	{
		return shootSFX;
	}
	
	public function get_hurtSFX():FlxSound	{
		return hurtSFX;
	}
	
	public function get_chargeSFX():FlxSound	{
		return chargeSFX;
	}
	
}