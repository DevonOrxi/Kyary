package entities;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxTypedGroup;
import managers.TimeMaster;

/**
 * ...
 * @author Acid
 */
class Player extends FlxSprite
{
	
	@:isVar public var bulletGroup(get,null):FlxTypedGroup<Bullet>;

	public function new(X:Float=0, Y:Float=0) {
		super(X, Y);
		
		loadGraphic("assets/images/kyaryzontal.png");
		
		//	Player hitbox and offset setting
		/*width = 16;
		height = 28;
		origin.x = -10;
		origin.y = -20;
		offset.x = 10;
		offset.y = 20;*/
		
		x = 25;
		y = (FlxG.height - height) / 2;
		
		bulletGroup = new FlxTypedGroup<Bullet>();
	}
	
	override public function update():Void {
		super.update();
		
		//	Movement input checking
		updateMovement();
		
		shoot();
	}
	
	//	Bullet group getter
	public function get_bulletGroup():FlxTypedGroup<Bullet> {
		return bulletGroup;
	}
	
	
	private function shoot():Void {
		//	Shoot when Z is pressed AND the beat is on
		if (FlxG.keys.pressed.Z && TimeMaster.isBeat)
		{
			bulletGroup.add(new Bullet(x, y, "assets/images/shot-2.png"));
			//FlxG.sound.play("assets/sounds/boop.wav");
		}
	}
	
	//	Movement input checking
	private function updateMovement():Void {		
		velocity.x = 0;
		velocity.y = 0;
		
		//	Left-right input
		if (FlxG.keys.pressed.LEFT && FlxG.keys.pressed.RIGHT)
			velocity.x = 0;
		else if (FlxG.keys.pressed.LEFT)
			velocity.x = -GC.playerSpeed;
		else if (FlxG.keys.pressed.RIGHT)
			velocity.x = GC.playerSpeed;
			
		//	Up-down input
		if (FlxG.keys.pressed.UP && FlxG.keys.pressed.DOWN)
			velocity.y = 0;
		else if (FlxG.keys.pressed.UP)
			velocity.y = -GC.playerSpeed;
		else if (FlxG.keys.pressed.DOWN)
			velocity.y = GC.playerSpeed;
		
		//	Hardcoded diagonal speed
		//  "Hardcoded" means "good"
		if (velocity.x != 0 && velocity.y != 0)
		{
			velocity.x *= 0.707;
			velocity.y *= 0.707;
		}
		
		//	Focus mode
		if (FlxG.keys.pressed.SHIFT)
		{
			velocity.x *= 0.5;
			velocity.y *= 0.5;
		}
		
		//	OOB checking
		if (x < 0)
			x = 0;
		else if (x + width > FlxG.width)
			x = FlxG.width - width;
		if (y < 0)
			y = 0;
		else if (y + height > FlxG.height)
			y = FlxG.height - height;
	}
	
	
	
}