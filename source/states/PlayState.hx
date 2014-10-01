package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;


/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{	
	private var square:FlxSprite;
	
	private var bpm:Float = 165;
	
	private var barTime:Float;
	private var currentBar:Int = 0;
	private var songBar:Float;	
	private var barProgress:Float = 0;
	
	private var timeSignature = 4;
	
	private var isBeat = true;
	private var beatTime:Float;
	private var currentBeat:Int = 1;
	
	
	override public function create():Void
	{
		super.create();
		
		square = new FlxSprite(100, 100);
		square.makeGraphic(72, 72);
		square.color = FlxColor.RED;
		add(square);		
		
		FlxG.sound.playMusic(AssetPaths.music__mp3);
		
		beatTime = 1 / (bpm / 60);
		barTime = timeSignature * beatTime;
		
		//trace(currentBar + "." + currentBeat);
	}
	
	
	override public function update():Void
	{
		super.update();
		
		
		songBar = FlxG.sound.music.time / (1000 * barTime);
		barProgress = songBar - Math.ffloor(songBar);
		
		
		if (currentBar < Math.floor(songBar))
		{
			currentBeat = 1;
			currentBar++;
			changeFlasheo();
			//trace(currentBar + "." + currentBeat);
		}
		
		
		if (!(barProgress < (currentBeat/timeSignature)))
		{
			currentBeat++;
			changeFlasheo();
			//trace(currentBar + "." + currentBeat);
		}
	}
	
	private function changeFlasheo():Void
	{
		switch(currentBeat)
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