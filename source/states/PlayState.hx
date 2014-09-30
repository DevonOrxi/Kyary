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
	private var songBar:Float = 1;	
	private var counterBar:Int = 1;
	
	private var timeSignature = 4;
	
	private var isBeat = true;
	private var beatTime:Float;
	private var currentBeat:Int = 1;
	
	
	override public function create():Void
	{
		super.create();
		
		square = new FlxSprite(100, 100);
		square.makeGraphic(72, 72);
		add(square);		
		
		FlxG.sound.playMusic(AssetPaths.music__mp3);
		
		beatTime = 1 / (bpm / 60);
		barTime = timeSignature * beatTime;
		
		trace(currentBeat);
	}
	
	
	override public function update():Void
	{
		super.update();
		/*
		if (isBeat)
			if (square.x == 100)
				square.x = 300;
			else
				square.x = 100;
		*/
		songBar = FlxG.sound.music.time / (1000 * barTime);
		
		if ((songBar - Math.ffloor(songBar)) > (currentBeat/timeSignature))
		{
			//isBeat = true;
			//counter = 0;
			currentBeat++;
			if (currentBeat > timeSignature)
			{
				currentBeat = 1;
				counterBar++;
			}
				
			//trace(currentBeat);
		}/*
		else
			isBeat = false;*/
	}	
}