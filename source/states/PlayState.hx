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
		enemyLifeBar = new FlxBar( 0, FlxG.height, FlxBar.FILL_HORIZONTAL_INSIDE_OUT, Math.floor(temp.width), Math.floor(temp.height), enemy, "health");// , 0, GC.enemyMaxHealth);
		enemyLifeBar.createImageBar("assets/images/bar_empty.png", "assets/images/bar_full.png");
		//enemyLifeBar.createGradientBar([0xFF2a2828], [0xFF16EE5d,0xFFEEBE16,0xFF920000,0xFFEEBE16,0xFF16EE5d], 1, 180, true);
		enemyLifeBar.y -= enemyLifeBar.height;
		
		//	Justin Case.
		temp.destroy();
		
		enemyTrail = new FlxTrail(enemy, null, 8, 5, 0.4, 0.05);		
		
		//	Add all the stuff to the state
		add(background);
		add(enemyTrail);
		add(enemy);
		add(player);
		add(player.bulletGroup);
		add(enemy.bulletGroup);
		add(enemyLifeBar);
		
		/*
		add(new FlxText(0, 0, 0, "PROTOTYPE"));		
		trace(TimeMaster.currentBar + "." + TimeMaster.currentBeat);
		/*
		testText = new FlxText(0, 0, 0, TimeMaster.currentBar + "." + TimeMaster.currentBeat, 100);		
		add(testText);
		*/
	}
	
	
	override public function update():Void {
		
		super.update();
		
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
		
	}
	
	//	Handles player damaging
	private function damagePlayer(p:Player, b:Bullet):Void {
		
		enemy.bulletGroup.remove(b);
		player.kill();
		
	}
}