package states;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.system.FlxSound;

/**
 * ...
 * @author Acid
 */
class CreditState extends FlxState
{
	private var touch:Bool = false;
	private var credMusic:FlxSound;

	override public function create():Void 
	{
		super.create();
		
		credMusic = FlxG.sound.load("assets/music/credits.wav", 1, true);
		
		var credits = new FlxSprite();
		credits.loadGraphic("assets/images/creditScreen.png");
		add(credits);
		
		FlxG.camera.fade(0xFF000000, 1.5, true, canTouch);
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		if (touch && FlxG.keys.anyJustPressed(["W", "S", "A", "D", "LEFT", "RIGHT", "UP", "DOWN", "Z", "SHIFT", "ENTER", "SPACE", "X"])) {
			touch = false;
			FlxG.camera.fade(0xFF000000, 1.5, false, goToMenu);
		}
	}
	
	private function canTouch():Void {
		touch = true;
		credMusic.play();
	}
	
	private function goToMenu():Void {
		FlxG.switchState(new MenuState());
	}
	
	
	
}