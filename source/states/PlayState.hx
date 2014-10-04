package states;

import entities.Bullet;
import entities.Enemy;
import entities.Player;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.xml.Fast;
import managers.TimeMaster;
import openfl.Assets;
import openfl.display.BlendMode;


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
		
		background = new FlxBackdrop(AssetPaths.background__png, 1, 1, false, true);
		background.x = GC.gameMinX;
		background.velocity.y = 100;
		add(background);
		
		enemy = new Enemy(0, 0, fast.node.enemy);
		add(enemy);
		add(enemy.getBulletGroup());
		
		player = new Player();
		add(player);
		add(player.getBulletGroup());
		
		overlay = new FlxSprite(0, 0, AssetPaths.overlay__png);
		add(overlay);
		
		add(new FlxText(0, 0, 0, "PROTOTYPE"));
		
		FlxG.sound.playMusic(AssetPaths.music__wav, 1);
		
		//trace(GV.currentBar + "." + GV.currentBeat);
	}
	
	
	override public function update():Void
	{
		super.update();
		
		/*
		if (GV.currentBar == 32 && GV.currentBeat == 1)
		{
			trace("Music time: " + FlxG.sound.music.time);
			trace("Counter time: " + testCounter);
			trace("Beatbar time: " + GV.beatTime * (GV.currentBar * GV.timeSignature + GV.currentBeat));
		}*/
		
		TimeMaster.update();
		
		/*
		if (GV.isBeat)
			changeFlasheo();
		*/
	}
	
	/*
	private function changeFlasheo():Void
	{
		switch(GV.currentBeat)
		{
			case 1:
				square.y = 100;
				square.color = FlxColor.RED;
			case 2:
				square.x = 300;
				square.color = FlxColor.BLUE;
			case 3:
				square.y = 300;
				square.color = FlxColor.YELLOW;
			case 4:
				square.x = 100;
				square.color = FlxColor.GREEN;
		}
	}
	*/
}