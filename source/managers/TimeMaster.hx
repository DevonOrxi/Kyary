package managers;

import flixel.FlxG;

/**
 * ...
 * @author Acid
 */
class TimeMaster
{

	static public function init() 
	{
		
		GV.beatTime = 1 / (GV.bpm / 60) * 1000;
		GV.barTime = GV.timeSignature * GV.beatTime;
		
	}
	
	static public function update():Void
	{
		
		GV.songBar = FlxG.sound.music.time / GV.barTime;
		GV.barProgress = GV.songBar - Math.ffloor(GV.songBar);
		
		GV.isBeat = false;
		
		if (GV.currentBar < Math.floor(GV.songBar))
		{
			GV.currentBeat = 1;
			GV.currentBar++;
			GV.isBeat = true;
			//trace(currentBar + "." + currentBeat);
		}
		
		
		if (!(GV.barProgress < (GV.currentBeat/GV.timeSignature)))
		{
			GV.currentBeat++;
			GV.isBeat = true;
			//trace(currentBar + "." + currentBeat);
		}
	}
	
	/*public function getCurrentBeat():Int
	{
		return GV.currentBeat;
	}
	
	public function getIsBeat():Bool
	{
		return GV.isBeat;
	}*/
	
}