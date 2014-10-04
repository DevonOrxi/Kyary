package entities;

import flixel.FlxSprite;

/**
 * ...
 * @author Acid
 */
class Bullet extends FlxSprite
{
	private var activationTime:Float = 0;
	

	public function new(X:Float=0, Y:Float=0, velX:Float=0, velY:Float=0, time:Float=0, ?graphic:Dynamic) 
	{
		super();
		
		if (graphic != null)
		{
			loadGraphic(graphic);
		}
		else
		{
			loadGraphic(AssetPaths.shot__png);
			width = 6;
			height = 6;
			origin.x = -2;
			origin.y = -2;
			offset.x = 2;
			offset.y = 2;
		
			x = X - width / 2;
			y = Y - height / 2;
		}
		
		velocity.x = velX;
		velocity.y = velY;		
		activationTime = time;
	}
	
	override public function update():Void
	{
		super.update();
		
		if (!isOnScreen())
			kill();
	}
	
	public function getActivationTime():Float
	{
		return activationTime;
	}
	
	
	
}