package entities;

import flixel.FlxSprite;

/**
 * ...
 * @author Acid
 */
class Bullet extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0, velX:Float=0, velY:Float=0) 
	{
		super(X, Y);
		
		makeGraphic(16, 16);
		
		velocity.x = velX;
		velocity.y = velY;
		
	}
	
	override public function update():Void
	{
		super.update();
		
		
	}
	
	
	
}