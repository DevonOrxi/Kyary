package entities;

import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxAngle;

/**
 * ...
 * @author Acid
 */
class Bullet extends FlxSprite
{
	@:isVar public var activationTime(get,set):Float;
	

	public function new(X:Float=0, Y:Float=0, ?graphic:Dynamic) {
		super();
		
		if (graphic != null)
		{
			loadRotatedGraphic(graphic, 45, -1, true, true);
		}
		else
		{
			loadRotatedGraphic("assets/images/shot.png", 45, -1, true, true);
			/*width = 6;
			height = 6;
			origin.x = -2;
			origin.y = -2;
			offset.x = 2;
			offset.y = 2;*/
		}
		
		velocity.x = GC.playerBulletSpeed;
		x = X - width / 2;
		y = Y - height / 2;
				
		scale.x = 2;
		scale.y = 2;
	}
	
	override public function update():Void {
		super.update();
		
		if (!isOnScreen())
			kill();
	}
	
	public function get_activationTime():Float {
		return activationTime;
	}
	
	public function set_activationTime(at:Float):Float {
		activationTime = at;
		return activationTime;
	}
	
	public function setSpeedDirection(speed:Float):Void
	{		
		var p:FlxPoint = new FlxPoint();
		p = FlxAngle.getCartesianCoords(speed, angle);
		velocity.x = p.x;
		velocity.y = p.y;
	}
	
	
	
}