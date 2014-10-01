package states;

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
	private var timeMaster:TimeMaster;
	
	
	override public function create():Void
	{
		super.create();
		
		square = new FlxSprite(100, 100);
		square.makeGraphic(72, 72);
		square.color = FlxColor.RED;
		add(square);
		
		timeMaster = new TimeMaster();
		add(timeMaster);
		
		FlxG.sound.playMusic(AssetPaths.music__mp3);
		
		//trace(currentBar + "." + currentBeat);
	}
	
	
	override public function update():Void
	{
		super.update();
		
		if (timeMaster.getIsBeat())
			changeFlasheo();
	}
	
	private function changeFlasheo():Void
	{
		switch(timeMaster.getCurrentBeat())
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