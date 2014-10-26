package states;

import flixel.addons.display.FlxBackdrop;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.XboxButtonID;
import flixel.system.FlxSound;
import openfl.system.System;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	private var canTouch:Bool = false;
	private var canMove:Bool = false;
	private var explodeSFX:FlxSound;
	private var selectSFX:FlxSound;
	private var startSFX:FlxSound;
	private var titleMusic:FlxSound;
	private var waitCounter:Float = 0;
	private var cursorPosition:Float = 0;
	private var _gibs:FlxEmitter;
	private var title:FlxSprite;
	private var disclaimer:FlxSprite;
	
	private var exitOn:FlxSprite;
	private var exitOff:FlxSprite;
	private var creditsOn:FlxSprite;
	private var creditsOff:FlxSprite;
	private var playOn:FlxSprite;
	private var playOff:FlxSprite;
	private var _gamePad:FlxGamepad;
	
	override public function create():Void
	{
		super.create();
		
		var background4:FlxBackdrop = new FlxBackdrop("assets/images/backLayer4.png", 1, 1, true, false);
		background4.velocity.x = -75;
		var background3:FlxBackdrop = new FlxBackdrop("assets/images/backLayer3.png", 1, 1, true, false);
		background3.velocity.x = 1.5*background4.velocity.x;
		var background2:FlxBackdrop = new FlxBackdrop("assets/images/backLayer2.png", 1, 1, true, false);
		background2.velocity.x = 1.5*background3.velocity.x;
		var background1:FlxBackdrop = new FlxBackdrop("assets/images/backLayer1.png", 1, 1, true, false);
		background1.velocity.x = 1.5 * background2.velocity.x;
		
		creditsOff = new FlxSprite();
		creditsOff.loadGraphic("assets/images/creditsOff.png");
		creditsOff.y = 260 - creditsOff.height / 2;
		creditsOff.x = FlxG.width / 2 - creditsOff.width / 2;
		creditsOff.visible = false;
		
		creditsOn = new FlxSprite();
		creditsOn.loadGraphic("assets/images/creditsOn.png");
		creditsOn.y = 260 - creditsOn.height / 2;
		creditsOn.x = FlxG.width / 2 - creditsOn.width / 2;
		creditsOn.visible = false;
		
		playOff = new FlxSprite();
		playOff.loadGraphic("assets/images/playOff.png");
		playOff.y = 230 - playOff.height / 2;
		playOff.x = FlxG.width / 2 - playOff.width / 2;
		playOff.visible = false;
		
		playOn = new FlxSprite();
		playOn.loadGraphic("assets/images/playOn.png");
		playOn.y = 230 - playOn.height / 2;
		playOn.x = FlxG.width / 2 - playOn.width / 2;
		playOn.visible = false;
		
		exitOff = new FlxSprite();
		exitOff.loadGraphic("assets/images/exitOff.png");
		exitOff.y = 290 - exitOff.height / 2;
		exitOff.x = FlxG.width / 2 - exitOff.width / 2;
		exitOff.visible = false;
		
		exitOn = new FlxSprite();
		exitOn.loadGraphic("assets/images/exitOn.png");
		exitOn.y = 290 - exitOn.height / 2;
		exitOn.x = FlxG.width / 2 - exitOn.width / 2;
		exitOn.visible = false;
		
		title = new FlxSprite();
		title.loadGraphic("assets/images/title.png");
		title.y = 39;
		title.x = FlxG.width / 2 - title.width / 2;
		title.visible = false;
		
		disclaimer = new FlxSprite();
		disclaimer.loadGraphic("assets/images/disclaimer.png");
		disclaimer.visible = false;
		
		_gibs = new FlxEmitter();
		_gibs.setSize(Std.int(title.width), Std.int(title.height));
		_gibs.setYSpeed(-200, -20);
		_gibs.setRotation( -720, 720);
		_gibs.gravity = 100;
		_gibs.x = title.x;
		_gibs.y = title.y;
		
		var tempParticle:FlxParticle;
		for (i in 0...100) {
			tempParticle = new FlxParticle();
			tempParticle.makeGraphic(3, 3, 0xDDF92FBA);
			_gibs.add(tempParticle);			
			
			tempParticle = new FlxParticle();
			tempParticle.makeGraphic(3, 3, 0xDDFF66EB);
			_gibs.add(tempParticle);
			
			tempParticle = new FlxParticle();
			tempParticle.makeGraphic(3, 3, 0xDDFFB4FF);
			_gibs.add(tempParticle);
			
			tempParticle = new FlxParticle();
			tempParticle.makeGraphic(3, 3, 0xDDFFFFFF);
			_gibs.add(tempParticle);
		}		
		
		explodeSFX = FlxG.sound.load("assets/sounds/explode.wav");
		selectSFX = FlxG.sound.load("assets/sounds/select.wav");
		startSFX = FlxG.sound.load("assets/sounds/start.wav");
		titleMusic = FlxG.sound.load("assets/music/title.wav", 1, true);
		
		FlxG.camera.fade(0xFF000000, 1.5, true, boom);
		
		_gamePad = FlxG.gamepads.lastActive;
		
		add(background4);
		add(background3);
		add(background2);
		add(background1);
		add(exitOn);
		add(exitOff);
		add(creditsOn);
		add(creditsOff);
		add(playOn);
		add(playOff);
		add(title);
		add(disclaimer);
		add(_gibs);
		
	}
	
	

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		if (canTouch) {
			Reg.gamePad = FlxG.gamepads.lastActive;
			if (Reg.gamePad == null)
			{
				if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W)
					moveCursor();
				else if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S)
					moveCursor();
				
				if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.Z || FlxG.keys.justPressed.X || FlxG.keys.justPressed.SPACE)
					accept();
			} else {
				if(canMove) {
					if (Reg.gamePad.justPressed(XboxButtonID.DPAD_UP) || Reg.gamePad.getYAxis(XboxButtonID.LEFT_ANALOGUE_Y)<=-0.25 || Reg.gamePad.justPressed(XboxButtonID.DPAD_DOWN) || Reg.gamePad.getYAxis(XboxButtonID.LEFT_ANALOGUE_Y)>=0.25)
						moveCursor();
				} else if (Reg.gamePad.getYAxis(XboxButtonID.LEFT_ANALOGUE_Y) >= -0.25 && Reg.gamePad.getYAxis(XboxButtonID.LEFT_ANALOGUE_Y) <= 0.25)
					canMove = true;
				
				if (Reg.gamePad.justPressed(XboxButtonID.A) || Reg.gamePad.justPressed(XboxButtonID.X))
					accept();
			}

			
		}		
		
		if (FlxG.keys.pressed.Q)
			System.exit(0);
	}
	
	private function boom():Void {
		explodeSFX.play();
		titleMusic.volume = 1;
		titleMusic.play();
		FlxG.cameras.flash(0xFFFFFFFF, 0.5);
		FlxG.cameras.shake(0.035, 0.5);
		title.visible = true;
		disclaimer.visible = true;
		playOn.visible = true;
		creditsOff.visible = true;
		canTouch = true;
		_gibs.start(true, 5);
	}
	
	private function moveCursor():Void {
		canMove = false;
		selectSFX.play(true);
		
		if (cursorPosition == 0)
			cursorPosition = 1;
		else
			cursorPosition = 0;
		
		switch(cursorPosition) {
			case 0:
				playOn.visible = true;
				playOff.visible = false;
				creditsOn.visible = false;
				creditsOff.visible = true;
				/*if (delta == 1){
					exitOn.visible = false;
					exitOff.visible = true;
				}
				else {
					creditsOn.visible = false;
					creditsOff.visible = true;
				}*/
			case 1:
				creditsOn.visible = true;
				creditsOff.visible = false;
				playOn.visible = false;
				playOff.visible = true;
				/*if (delta == 1){
					playOn.visible = false;
					playOff.visible = true;
				}
				else {
					exitOn.visible = false;
					exitOff.visible = true;
				}*//*
			case 2:
				exitOn.visible = true;
				exitOff.visible = false;
				if (delta == 1){
					creditsOn.visible = false;
					creditsOff.visible = true;
				}
				else {
					playOn.visible = false;
					playOff.visible = true;
				}*/
		}
		
	}
	
	private function accept():Void {
		FlxG.cameras.flash(0xFFFFFFFF, 0.5);
		startSFX.play();
		if(cursorPosition!=2) canTouch = false;
		
		switch(cursorPosition) {
			case 0:
				FlxG.camera.fade(0xFF000000, 1.5, false, toGame);
			case 1:
				FlxG.camera.fade(0xFF000000, 1.5, false, toCredits);
			case 2:
				FlxG.camera.fade(0xFF000000, 1.5, false, quit);
		}
	}
	
	private function quit():Void {
		//System.exit();
	}
	
	private function toGame():Void {
		FlxG.switchState(new PlayState());
	}
	
	private function toCredits():Void {
		FlxG.switchState(new CreditState());
	}
}