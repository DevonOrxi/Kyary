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

import haxe.xml.Fast;
import openfl.Assets;


/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{	
	private var overlay:FlxSprite;	
	private var background:FlxBackdrop;
	//private var square:FlxSprite;
	
	private var player:Player;
	private var enemy:Enemy;
	
	private var data:Xml;
	private var fastData:Fast;
	
	
	override public function create():Void
	{
		super.create();
		
		var data = Xml.parse(Assets.getText(AssetPaths.level__xml));
		var fast = new Fast(data.firstChild());
		
		TimeMaster.init();
		
		/*
		square = new FlxSprite(100, 100);
		square.makeGraphic(72, 72);
		square.color = FlxColor.RED;
		add(square);
		*/
		
		background = new FlxBackdrop(AssetPaths.backH__png, 1, 1, true, false);
		background.velocity.x = 100;
		add(background);
		
		enemy = new Enemy(0, 0, fast.node.enemy);
		add(enemy);
		
		player = new Player();
		add(player);
		add(player.getBulletGroup());
		add(enemy.getBulletGroup());
		
		add(new FlxText(0, 0, 0, "PROTOTYPE"));
		
		FlxG.sound.playMusic(AssetPaths.music__wav, 0);
		FlxScreenGrab.defineHotKeys(["F1"], true, true);
		
		//trace(GV.currentBar + "." + GV.currentBeat);
	}
	
	
	override public function update():Void
	{
		super.update();
		
		if (FlxG.keys.justPressed.F1)
			FlxScreenGrab.grab();
		
		/*
		if (GV.currentBar == 32 && GV.currentBeat == 1)
		{
			trace("Music time: " + FlxG.sound.music.time);
			trace("Counter time: " + testCounter);
			trace("Beatbar time: " + GV.beatTime * (GV.currentBar * GV.timeSignature + GV.currentBeat));
		}*/
		
		TimeMaster.update();
		
		checkBulletCollision();
	}
	
	private function checkBulletCollision():Void
	{
		if (FlxG.overlap(enemy, player.getBulletGroup(), damageEnemy))
			enemy.color = 0xFF0000;
		else
			enemy.color = 0xFFFFFF;
		FlxG.overlap(player, enemy.getBulletGroup(), damagePlayer);
		
	}
	
	private function damageEnemy(e:Enemy,b:Bullet):Void
	{
		player.getBulletGroup().remove(b);
		enemy.health -= GC.playerShotPower;
	}
	
	private function damagePlayer(p:Player,b:Bullet):Void
	{		
		enemy.getBulletGroup().remove(b);
		player.kill();
		
	}
}