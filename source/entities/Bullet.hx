package entities;

import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxAngle;
import managers.TimeMaster;

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
			loadRotatedGraphic("assets/images/shotB.png", 45, -1, true, true);
			
			width = 12;
			height = 12;
			centerOffsets();
			centerOrigin();
		}
		
		velocity.x = GC.playerBulletSpeed;
		x = X - width / 2;
		y = Y - height / 2;
				
		//scale.x = 2;
		//scale.y = 2;
	}
	
	override public function update():Void {
		super.update();
		
		if (!isOnScreen())
			kill();			
		
		//scale.x = TimeMaster.beatScale + (TimeMaster.beatScale-1)*10;
		//scale.y = TimeMaster.beatScale + (TimeMaster.beatScale-1)*10;
	}
	
	public function get_activationTime():Float {
		return activationTime;
	}
	
	public function set_activationTime(at:Float):Float {
		activationTime = at;
		return activationTime;
	}
	
	public function setSpeedDirection(speed:Float,ang:Float):Void
	{		
		var p:FlxPoint = new FlxPoint();
		p = FlxAngle.getCartesianCoords(speed, ang);
		velocity.x = p.x;
		velocity.y = p.y;
	}
	
	
	
}