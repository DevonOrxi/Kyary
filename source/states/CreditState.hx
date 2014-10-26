package states;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.XboxButtonID;

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
	
	override public function update():Void {
		super.update();
		
		if (Reg.gamePad == null) {
			if (touch && FlxG.keys.anyJustPressed(["W", "S", "A", "D", "LEFT", "RIGHT", "UP", "DOWN", "Z", "SHIFT", "ENTER", "SPACE", "X"])) {
				touch = false;
				FlxG.camera.fade(0xFF000000, 1.5, false, goToMenu);
			}
		}
		else {
			if (touch && (Reg.gamePad.justPressed(XboxButtonID.A) || Reg.gamePad.justPressed(XboxButtonID.X) || Reg.gamePad.justPressed(XboxButtonID.B))) {
				touch = false;
				FlxG.camera.fade(0xFF000000, 1.5, false, goToMenu);
			}
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