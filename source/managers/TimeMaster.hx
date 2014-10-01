package managers;

import flixel.FlxSprite;
import flixel.FlxG;

/**
 * ...
 * @author Acid
 */
class TimeMaster extends FlxSprite
{	
	private var bpm:Float = 165;
	
	private var barTime:Float;
	private var currentBar:Int = 0;
	private var songBar:Float;	
	private var barProgress:Float = 0;
	
	private var timeSignature = 4;
	
	private var isBeat = true;
	private var beatTime:Float;
	private var currentBeat:Int = 1;

	public function new() 
	{
		super();
		
		visible = false;
		
		beatTime = 1 / (bpm / 60);
		barTime = timeSignature * beatTime;
	}
	
	override public function update():Void
	{
		super.update();
		
		
		songBar = FlxG.sound.music.time / (1000 * barTime);
		barProgress = songBar - Math.ffloor(songBar);
		
		isBeat = false;
		
		if (currentBar < Math.floor(songBar))
		{
			currentBeat = 1;
			currentBar++;
			isBeat = true;
			//trace(currentBar + "." + currentBeat);
		}
		
		
		if (!(barProgress < (currentBeat/timeSignature)))
		{
			currentBeat++;
			isBeat = true;
			//trace(currentBar + "." + currentBeat);
		}
	}
	
	public function getCurrentBeat():Int
	{
		return currentBeat;
	}
	
	public function getIsBeat():Bool
	{
		return isBeat;
	}
	
}