package entities;

import flixel.FlxSprite;

/**
 * ...
 * @author Acid
 */
class Bullet extends FlxSprite
{
	private var activationTime:Float = 0;
	

	public function new(X:Float=0, Y:Float=0, velX:Float=0, velY:Float=0, time:Float=0) 
	{
		super(X, Y);
		
		makeGraphic(16, 16);
		
		velocity.x = velX;
		velocity.y = velY;		
		activationTime = time;
	}
	
	override public function update():Void
	{
		super.update();
		
		
	}
	
	public function getActivationTime():Float
	{
		return activationTime;
	}
	
	
	
}