package states;

import entities.Bullet;
import entities.Enemy;
import entities.Player;
import managers.TimeMaster;
import managers.QueueManager;

import flixel.addons.display.FlxBackdrop;
//import flixel.addons.plugin.screengrab.FlxScreenGrab;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;
import flixel.addons.effects.FlxTrail;
import flixel.tweens.FlxTween;
import flixel.effects.particles.FlxEmitterExt;
import flixel.effects.particles.FlxParticle;
import flixel.tweens.FlxEase;
import flixel.util.FlxPoint;
import flixel.effects.FlxFlicker;
import flixel.util.FlxRandom;

import haxe.xml.Fast;
import openfl.Assets;


/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{	
	private var music:FlxSound;
	
	private var fightingStarted:Bool = false;
	private var win:Bool = false;
	private var lose:Bool = false;
	
	private var overlay:FlxSprite;	
	private var background4:FlxBackdrop;
	private var background3:FlxBackdrop;
	private var background2:FlxBackdrop;
	private var background1:FlxBackdrop;
	private var enemyLifeBar:FlxBar;
	private var enemyID:FlxSprite;
	private var playerLifeBar:FlxBar;
	private var playerID:FlxSprite;	
	private var explosion:FlxSprite;
	private var explosionSFX:FlxSound;
	
	private var player:Player;
	private var enemy:Enemy;
	private var enemyTrail:FlxTrail;
	private var playerTrail:FlxTrail;
	private var playerExplosion:FlxEmitterExt;
	
	private var data:Xml;
	private var fastData:Fast;
	//	private var testText:FlxText;
	
	override public function create():Void {
		
		super.create();
		
		//FlxScreenGrab.defineHotKeys(["F1"], true, true);
		
		//	Load up the xml containing the level patterns
		var data = Xml.parse(Assets.getText("assets/data/level.xml"));
		var fast = new Fast(data.firstChild());
		
		
		//	Scrolling background load and init
		background4 = new FlxBackdrop("assets/images/backLayer4.png", 1, 1, true, false);
		background4.velocity.x = -75;
		background3 = new FlxBackdrop("assets/images/backLayer3.png", 1, 1, true, false);
		background3.velocity.x = 1.5*background4.velocity.x;
		background2 = new FlxBackdrop("assets/images/backLayer2.png", 1, 1, true, false);
		background2.velocity.x = 1.5*background3.velocity.x;
		background1 = new FlxBackdrop("assets/images/backLayer1.png", 1, 1, true, false);
		background1.velocity.x = 1.5*background2.velocity.x;
		
		
		//	Play that funky music, white boy
		music = FlxG.sound.load("assets/music/music.wav", 1, false);
		TimeMaster.song = music;
		
		explosionSFX = FlxG.sound.load("assets/sounds/explode.wav");
		
		//	Initialize time variables
		TimeMaster.init();
		QueueManager.init(fast);
		
		
		//	Setup the player and the boss
		enemy = new Enemy();
		
		player = new Player();
		player.x = -150;
		player.y = (FlxG.height - player.height) / 2;
		
		
		//	Setup a temporal image to get bar proportions...
		var eb:FlxSprite = new FlxSprite(0, 0, "assets/images/bar_empty.png");
		
		//	... then create and set the life bar up.
		enemyLifeBar = new FlxBar( 375, 333, FlxBar.FILL_LEFT_TO_RIGHT, Math.floor(eb.width), Math.floor(eb.height), enemy, "health");// , 0, GC.enemyMaxHealth);
		enemyLifeBar.createImageBar(null, "assets/images/bar_full.png", 0x0);
		
		eb.x = enemyLifeBar.x;
		eb.y = enemyLifeBar.y;
		
		enemyID = new FlxSprite(598, 321, "assets/images/enemyID.png");
		
		playerID = new FlxSprite(8, 9, "assets/images/playerID.png");
		playerLifeBar = new FlxBar(47, 17, FlxBar.FILL_LEFT_TO_RIGHT, 69, 17, player, "health", 0, 3);
		playerLifeBar.createImageBar(null, "assets/images/life.png", 0x0);
		
		playerExplosion = new FlxEmitterExt();
		playerExplosion.setMotion(0, 5, 0.2, 360, 200, 1.8);
		
		var tempParticle:FlxParticle;
		for (i in 0...30) {
			tempParticle = new FlxParticle();
			tempParticle.makeGraphic(2, 2, 0xDDF92FBA);
			playerExplosion.add(tempParticle);			
			
			tempParticle = new FlxParticle();
			tempParticle.makeGraphic(2, 2, 0xDDFF66EB);
			playerExplosion.add(tempParticle);
			
			tempParticle = new FlxParticle();
			tempParticle.makeGraphic(2, 2, 0xDDFFB4FF);
			playerExplosion.add(tempParticle);
			
			tempParticle = new FlxParticle();
			tempParticle.makeGraphic(2, 2, 0xDDFFFFFF);
			playerExplosion.add(tempParticle);
		}
		
		
		//	Trail effect for the boss
		enemyTrail = new FlxTrail(enemy, null, 8, 5, 0.4, 0.05);
		playerTrail = new FlxTrail(player, null, 8, 5, 0.4, 0.05);
		
		explosion = new FlxSprite();
		explosion.loadGraphic("assets/images/explode.png", true, 50, 50);
		explosion.animation.add("boom", [0, 1, 2], 15, false);
		explosion.visible = false;
		
		FlxG.camera.fade(0xFF000000, 1.5, true, beginGame);
		
		//	Add all the stuff to the state
		add(background4);
		add(background3);
		add(background2);
		add(background1);
		add(enemyTrail);
		add(playerTrail);
		add(enemy);
		add(player);
		add(player.heart);
		add(playerExplosion);
		add(player.bulletGroup);
		add(player.shotAnim);
		add(enemy.chargeAnim);
		add(enemy.bulletGroup);
		add(explosion);
		add(eb);
		add(enemyLifeBar);
		add(enemyID);
		add(playerID);
		add(playerLifeBar);
		
		/*
		add(new FlxText(0, 0, 0, "PROTOTYPE"));		
		trace(TimeMaster.currentBar + "." + TimeMaster.currentBeat);
		/*
		testText = new FlxText(0, 0, 0, TimeMaster.currentBar + "." + TimeMaster.currentBeat, 100);		
		add(testText);
		*/
		
		/*
		var charge:FlxSprite = new FlxSprite(player.x, player.y);
		charge.loadGraphic("assets/images/charge.png", true, 96, 96);
		charge.animation.add("charge1", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 15, true);
		charge.animation.add("charge2", [10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 15, true);
		charge.animation.play("charge2");
		add(charge);*/
	}
	
	
	override public function update():Void {
		
		super.update();
		
		if (FlxG.keys.justPressed.R)
			trace("x=" + enemy.x + " | y=" + enemy.y + " | ox=" + enemy.origin.x + " | oy=" + enemy.origin.y + " | ofx=" + enemy.offset.x + " | ofy=" + enemy.offset.y);
		
		if (!win)
		{
			if (player.alive == false)
			{
				player.deathCounter += FlxG.elapsed;
				if (player.deathCounter >= GC.playerDeathCounter)
				{
					if (player.health > 0) {
						playerTrail.revive();
						player.x = -150;
						player.y = (FlxG.height - player.height) / 2;
						player.revive();
						player.heart.revive();
						player.alpha = 1;
						FlxTween.cubicMotion(player, player.x, player.y, 200, 200, 50, 0, 25, player.y, 2, { ease: FlxEase.backOut, complete: startFight } );
						player.flySFX.play();
						FlxFlicker.flicker(player, TimeMaster.beatTime * 12 / 1000, 0.04, true, false, notGodAnymore);
					}
					else if (!lose)
					{
						lose = true;
						FlxG.camera.fade(0xFF000000, 4, false, goToMenu);
					}
				}
			}
			
			
			//	F1 takes a screenshot for you to save wherever you want
			/*if (FlxG.keys.justPressed.F1)
				FlxScreenGrab.grab(null,true,true);*/
			
			//	Update the time variables
			TimeMaster.update();
			
			//	Check for collision between bullets and other entities
			checkBulletCollision();
		
		}
		else  {
			player.deathCounter += FlxG.elapsed;
			if (player.deathCounter >= GC.playerDeathCounter*2)
				FlxG.camera.fade(0xFFFFFFFF, 4, false, goToCredits);
			
			if(explosion.animation.finished) {
				explosion.x = FlxRandom.floatRanged(enemy.x - explosion.width / 2, enemy.x + enemy.width - explosion.width / 2);
				explosion.y = FlxRandom.floatRanged(enemy.y - explosion.height / 2, enemy.y + enemy.height - explosion.height / 2);
				explosion.animation.play("boom");
				explosionSFX.play(true);
			}
		}
		
		if (TimeMaster.currentBar == 132 && !lose)
		{
			
			player.canPlay = false;
			player.isGod = true;
			lose = true;
			FlxTween.linearMotion(enemy, enemy.x, enemy.y, 700, enemy.y, 2, true, { type:FlxTween.ONESHOT, ease:FlxEase.sineOut } );
			FlxG.camera.fade(0xFF000000, 4, false, goToMenu);
		}
		
		/*
		testText.text = TimeMaster.currentBar + "." + TimeMaster.currentBeat;
		/*
		if (TimeMaster.currentBar == 32 && TimeMaster.currentBeat == 1)
		{
			trace("Music time: " + FlxG.sound.music.time);
			trace("Counter time: " + testCounter);
			trace("Beatbar time: " + TimeMaster.beatTime * (TimeMaster.currentBar * TimeMaster.timeSignature + TimeMaster.currentBeat));
		}*/
	
	}
	
	//	Checks for collision between bullets and other entities
	private function checkBulletCollision():Void {
		
		//	Enemy overlap
		if (FlxG.overlap(enemy, player.bulletGroup, damageEnemy))
			enemy.color = 0xFF0000;
		else
			enemy.color = 0xFFFFFF;
			
		//	Player overlap
		if (!player.isGod)
		{
			FlxG.overlap(player.heart, enemy.bulletGroup, damagePlayer);
			FlxG.overlap(player.heart, enemy, damagePlayer);
		}
		
	}
	
	//	Handles enemy damaging
	private function damageEnemy(e:Enemy, b:Bullet):Void {
		
		player.bulletGroup.remove(b);
		enemy.health -= GC.playerBulletPower;		
		enemy.hurtSFX.play();
		
			
		if (enemy.health <= 0 && !win)
		{
			win = true;
			player.canPlay = false;
			explosion.x = FlxRandom.floatRanged(enemy.x - explosion.width / 2, enemy.x + enemy.width - explosion.width / 2);
			explosion.y = FlxRandom.floatRanged(enemy.y - explosion.height / 2, enemy.y + enemy.height - explosion.height / 2);
			explosion.visible = true;
			explosion.animation.play("boom");
			explosionSFX.play(true);
			music.pause();
		}
		
	}
	
	//	Handles player damaging
	private function damagePlayer(h:FlxSprite, b:Bullet):Void {
		h.kill();
		h.visible = false;
		player.isGod = true;
		player.canPlay = false;
		playerExplosion.x = h.x + h.width / 2;
		playerExplosion.y = h.y + h.height / 2;
		playerExplosion.start(true, 2, 0, 400);
		player.hurtSFX.play();
		FlxG.cameras.flash(0xBBFFFFFF, 1);
		FlxG.cameras.shake(0.015, 0.2);
		
		enemy.bulletGroup.remove(b);
		
		FlxTween.color(player, 0.25*TimeMaster.beatTime / 1000, 0xFFFFFF, 0xFFFFFF, 1, 0, { type: FlxTween.ONESHOT, complete: playerVanished } );
	}
	
	private function playerVanished(tween:FlxTween):Void {
		player.kill();
		player.health--;
		player.deathCounter = 0;
	}
	
	private function notGodAnymore(f:FlxFlicker):Void {
		player.isGod = false;
	}
	
	private function beginGame():Void {
		FlxTween.cubicMotion(player, player.x, player.y, 200, 200, 50, 0, 25, player.y, 2, { ease: FlxEase.backOut, complete: startFight } );
		player.flySFX.play();
		FlxTween.linearMotion(enemy, enemy.x, enemy.y, 425, enemy.y, 2, true, { type:FlxTween.ONESHOT, ease:FlxEase.sineOut } );
	}

	private function startFight(tween:FlxTween):Void {
		if(!fightingStarted) {
			fightingStarted = true;
			music.play();
		}
		player.canPlay = true;
		playerTrail.kill();
	}
	
	private function goToMenu():Void {
		FlxG.switchState(new MenuState());
	}
	
	private function goToCredits():Void {
		FlxG.switchState(new CreditState());
	}
}