package entities;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxTypedGroup;

/**
 * ...
 * @author Acid
 */
class Player extends FlxSprite
{
	
	private var bulletGroup:FlxTypedGroup<Bullet>;

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.kyari__png);
		
		width = 16;
		height = 28;
		origin.x = -10;
		origin.y = -20;
		offset.x = 10;
		offset.y = 20;
		
		x = GC.gameMinX + (GC.gameMaxX - GC.gameMinX) / 2 - width / 2;
		y = FlxG.height - 50;
		
		bulletGroup = new FlxTypedGroup<Bullet>();
	}
	
	override public function update():Void
	{
		super.update();
		
		updateMovement();
		
	}
	
	public function getBulletGroup():FlxTypedGroup<Bullet>
	{
		return bulletGroup;
	}
	
	private function updateMovement():Void
	{		
		velocity.x = 0;
		velocity.y = 0;
		
		if ( FlxG.keys.pressed.LEFT && FlxG.keys.pressed.RIGHT )
			velocity.x = 0;
		else if (FlxG.keys.pressed.LEFT)
			velocity.x = -GC.playerSpeed;
		else if (FlxG.keys.pressed.RIGHT)
			velocity.x = GC.playerSpeed;
			
		if ( FlxG.keys.pressed.UP && FlxG.keys.pressed.DOWN )
			velocity.y = 0;
		else if (FlxG.keys.pressed.UP)
			velocity.y = -GC.playerSpeed;
		else if (FlxG.keys.pressed.DOWN)
			velocity.y = GC.playerSpeed;
			
		if (velocity.x != 0 && velocity.y != 0)
		{
			velocity.x *= 0.707;
			velocity.y *= 0.707;
		}
		
		if (x < GC.gameMinX)
			x = GC.gameMinX;
	}
	
	
	
}