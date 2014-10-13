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
import openfl.system.System;

import haxe.xml.Fast;
import openfl.Assets;


/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{	
	private var music:FlxSound;
	
	private var overlay:FlxSprite;	
	private var background:FlxBackdrop;
	private var enemyLifeBar:FlxBar;
	private var enemyID:FlxSprite;
	private var playerLifeBar:FlxBar;
	private var playerID:FlxSprite;	
	
	private var player:Player;
	private var enemy:Enemy;
	private var enemyTrail:FlxTrail;
	private var enemyBlur:FlxSprite;
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
		background = new FlxBackdrop("assets/images/backH.png", 1, 1, true, false);
		background.velocity.x = -100;
		
		
		//	Play that funky music, white boy
		music = FlxG.sound.load("assets/music/music.ogg", 1, false);
		TimeMaster.song = music;
		music.play();
		
		//	Initialize time variables
		TimeMaster.init();
		QueueManager.init(fast);
		
		
		//	Setup the player and the boss
		enemy = new Enemy();
		player = new Player();
		
		
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
		enemyTrail = new FlxTrail(enemy, "assets/images/boxx_nb.png", 8, 5, 0.4, 0.05);
		//enemyBlur = new FlxSprite(enemy.x, enemy.y, "assets/images/boxx_b.png");
		
		//	Add all the stuff to the state
		add(background);
		add(enemyTrail);
		//add(enemyBlur);
		add(enemy);
		add(player);
		add(player.heart);
		add(playerExplosion);
		add(player.bulletGroup);
		add(player.shotAnim);
		add(enemy.chargeAnim);
		add(enemy.bulletGroup);
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
		
		//enemyBlur.x = enemy.x;
		//enemyBlur.y = enemy.y;		
		
		//	F1 takes a screenshot for you to save wherever you want
		/*if (FlxG.keys.justPressed.F1)
			FlxScreenGrab.grab(null,true,true);*/
		
		//	Update the time variables
		TimeMaster.update();
		
		//	Check for collision between bullets and other entities
		checkBulletCollision();			
		
		if (FlxG.keys.pressed.Q)
			System.exit(0);
		
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
		FlxG.overlap(player.heart, enemy.bulletGroup, damagePlayer);
		
	}
	
	//	Handles enemy damaging
	private function damageEnemy(e:Enemy, b:Bullet):Void {
		
		player.bulletGroup.remove(b);
		enemy.hurt(GC.playerBulletPower);		
		enemy.hurtSFX.play();
		
	}
	
	//	Handles player damaging
	private function damagePlayer(h:FlxSprite, b:Bullet):Void {
		
		playerExplosion.x = h.x + h.width / 2;
		playerExplosion.y = h.y + h.height / 2;
		playerExplosion.start(true, 2, 0, 400);
		
		enemy.bulletGroup.remove(b);
		
		FlxTween.color(player, 0.25*TimeMaster.beatTime / 1000, 0xFFFFFF, 0xFFFFFF, 1, 0, { type: FlxTween.ONESHOT, complete: playerVanished } );
		
		h.kill();
	}
	
	private function playerVanished(tween:FlxTween):Void {
		player.kill();
		player.hurt(1);
	}
}