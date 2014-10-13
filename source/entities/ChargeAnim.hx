package entities;
import flixel.FlxSprite;

/**
 * ...
 * @author Acid
 */
class ChargeAnim extends FlxSprite
{

	public function new() 
	{
		super();
		
		loadGraphic("assets/images/chargeB.png", true, 96, 96);
		animation.add("charge1", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9/*, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19*/], 30, false);
		//animation.add("charge2", [10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 30, false);
		alpha = 0.75;
		kill();
	}
	
	override public function update():Void
	{
		super.update();
		
		if (animation.finished)
			kill();
	}
	
}