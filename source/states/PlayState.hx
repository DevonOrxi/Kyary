package states;

import entities.Bullet;
import entities.Enemy;
import entities.Player;
import managers.TimeMaster;

import flixel.addons.display.FlxBackdrop;
import flixel.addons.plugin.screengrab.FlxScreenGrab;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;
import flixel.addons.effects.FlxTrail;

import haxe.xml.Fast;
import openfl.Assets;


/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{	
	private var overlay:FlxSprite;	
	private var background:FlxBackdrop;
	private var enemyLifeBar:FlxBar;
	
	private var player:Player;
	private var enemy:Enemy;
	private var enemyTrail:FlxTrail;
	private var enemyBlur:FlxSprite;
	
	private var data:Xml;
	private var fastData:Fast;
	//	private var testText:FlxText;
	
	override public function create():Void {
		
		super.create();
		
		FlxScreenGrab.defineHotKeys(["F1"], true, true);
		
		//	Load up the xml containing the level patterns
		var data = Xml.parse(Assets.getText("assets/data/level.xml"));
		var fast = new Fast(data.firstChild());
		
		
		//	Scrolling background load and init
		background = new FlxBackdrop("assets/images/backH.png", 1, 1, true, false);
		background.velocity.x = -100;
		
		
		//	Play that funky music, white boy
		FlxG.sound.playMusic("assets/music/music.wav", 1);
		
		
		//	Initialize time variables
		TimeMaster.init();
		
		
		//	Setup the player and the boss
		enemy = new Enemy(0, 0, fast.node.enemy);
		player = new Player();
		
		
		//	Setup a temporal image to get bar proportions...
		var temp:FlxSprite = new FlxSprite(0, 0, "assets/images/bar_empty.png");
		
		//	... then create and set the life bar up.
		enemyLifeBar = new FlxBar( FlxG.width - temp.width, FlxG.height, FlxBar.FILL_LEFT_TO_RIGHT, Math.floor(temp.width), Math.floor(temp.height), enemy, "health");// , 0, GC.enemyMaxHealth);
		enemyLifeBar.createImageBar(null, "assets/images/bar_full.png",0x000000);
		//enemyLifeBar.createGradientBar([0xFF2a2828], [0xFF16EE5d,0xFFEEBE16,0xFF920000,0xFFEEBE16,0xFF16EE5d], 1, 180, true);
		enemyLifeBar.y -= enemyLifeBar.height;
		
		//	Justin Case.
		temp.destroy();
		
		enemyTrail = new FlxTrail(enemy, "assets/images/boxx_nb.png", 8, 5, 0.4, 0.05);
		//enemyBlur = new FlxSprite(enemy.x, enemy.y, "assets/images/boxx_b.png");
		
		//	Add all the stuff to the state
		add(background);
		add(enemyTrail);
		//add(enemyBlur);
		add(enemy);
		add(player);
		add(player.bulletGroup);
		add(enemy.chargeAnim);
		add(enemy.bulletGroup);
		add(new FlxSprite(enemyLifeBar.x, enemyLifeBar.y, "assets/images/bar_empty.png"));
		add(enemyLifeBar);
		
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
		if (FlxG.keys.justPressed.F1)
			FlxScreenGrab.grab();
		
		//	Update the time variables
		TimeMaster.update();
		
		//	Check for collision between bullets and other entities
		checkBulletCollision();			
		
		
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
		FlxG.overlap(player, enemy.bulletGroup, damagePlayer);
		
	}
	
	//	Handles enemy damaging
	private function damageEnemy(e:Enemy, b:Bullet):Void {
		
		player.bulletGroup.remove(b);
		enemy.health -= GC.playerBulletPower;
		
		FlxG.sound.play("assets/sounds/hurt.wav", 1, false, false);
		
	}
	
	//	Handles player damaging
	private function damagePlayer(p:Player, b:Bullet):Void {
		
		enemy.bulletGroup.remove(b);
		player.kill();
		
	}
}