package managers;

import flixel.FlxG;

/**
 * ...
 * @author Acid
 */
class TimeMaster	//	Apprentice! Heartborne! Seventh Seeker!
{

	static public function init() {
		
		GV.beatTime = /*1454.54 / GV.timeSignature;*/	1 / (GV.bpm / 60) * 1000;
		GV.barTime = GV.timeSignature * GV.beatTime + 0.000151171579;
		
	}
	
	static public function update():Void {
		
		GV.songBar = FlxG.sound.music.time / GV.barTime;
		GV.barProgress = GV.songBar - Math.ffloor(GV.songBar);
		
		GV.isBeat = false;
		
		if (GV.currentBar < Math.floor(GV.songBar))
		{
			GV.currentBeat = 1;
			GV.currentBar++;
			GV.isBeat = true;
			//trace(GV.currentBar + "." + GV.currentBeat);
		}		
		else if (!(GV.barProgress < (GV.currentBeat/GV.timeSignature)))
		{
			GV.currentBeat++;
			GV.isBeat = true;
			//trace(GV.currentBar + "." + GV.currentBeat);
		}
		
		
		/*	This calculates the difference between the real song time at bar 132 and the math division
		 * 	Just for testing purposes
		
		trace(GV.currentBar);
		if (GV.currentBar == 132 && !GV.checker)
		{
			trace((FlxG.sound.music.time - GV.currentBar * GV.beatTime * GV.timeSignature) / (GV.currentBar * GV.beatTime * GV.timeSignature));
			GV.checker = true;
			//FlxG.sound.play(AssetPaths.boop__mp3);
		}*/
		
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