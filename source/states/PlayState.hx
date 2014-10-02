package states;

import entities.Enemy;
import entities.Player;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import managers.TimeMaster;


/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{	
	private var square:FlxSprite;	
	//private var timeMaster:TimeMaster;
	
	private var player:Player;
	private var enemy:Enemy;
	
	
	override public function create():Void
	{
		super.create();
		
		square = new FlxSprite(100, 100);
		square.makeGraphic(72, 72);
		square.color = FlxColor.RED;
		add(square);
		
		//timeMaster = new TimeMaster();
		
		TimeMaster.init();
		
		enemy = new Enemy(400, 400);
		enemy.makeGraphic(32, 32);
		add(enemy);
		add(enemy.getBulletGroup());
		
		
		FlxG.sound.playMusic(AssetPaths.music__mp3);
		
		//trace(GV.currentBar + "." + GV.currentBeat);
	}
	
	
	override public function update():Void
	{
		super.update();
		
		TimeMaster.update();
		
		if (GV.isBeat)
			changeFlasheo();
	}
	
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
}