package managers;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;
import entities.Bullet;
import flixel.util.FlxAngle;

/**
 * ...
 * @author Acid
 */
class BulletEmitter
{
	private var directionAngle:Float = 90;
	private var amplitude:Float = 0;
	private var nodes:Int = 1;
	private var interval:Float = 1;
	private var sequential:Bool = false;
	private var speed:Float = 100;

	public function new() 
	{
		
		
		
	}
	
	public function emit(X:Float, Y:Float, bullets:FlxTypedGroup<Bullet>):Void
	{
		bullets.add(new Bullet(X, Y, speed * Math.cos(FlxAngle.asRadians(directionAngle)), speed * Math.sin(FlxAngle.asRadians(directionAngle))));
	}
	
}