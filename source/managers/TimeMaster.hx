package managers;

import flixel.FlxG;
import haxe.xml.Fast;

/**
 * ...
 * @author Acid
 */
class TimeMaster	//	Apprentice! Heartborne! Seventh Seeker!
{	
	public static var bpm:Float = 165;
	
	public static var barTime:Float;
	public static var currentBar:Int = 0;
	public static var songBar:Float;	
	public static var barProgress:Float = 0;
	
	public static var timeSignature = 4;
	
	public static var isBeat:Bool = true;
	public static var beatTime:Float;
	public static var currentBeat:Int = 1;

	static public function init() {
		
		beatTime = /*1454.54 / timeSignature;*/	1 / (bpm / 60) * 1000;
		barTime = timeSignature * beatTime + 0.000151171579;
		
	}
	
	static public function update():Void {
		
		songBar = FlxG.sound.music.time / barTime;
		barProgress = songBar - Math.ffloor(songBar);
		
		isBeat = false;
		
		if (currentBar < Math.floor(songBar))
		{
			currentBeat = 1;
			currentBar++;
			isBeat = true;
			//trace(currentBar + "." + currentBeat);
		}		
		else if (!(barProgress < (currentBeat/timeSignature)))
		{
			currentBeat++;
			isBeat = true;
			//trace(currentBar + "." + currentBeat);
		}
		
		
		/*	This calculates the difference between the real song time at bar 132 and the math division
		 * 	Just for testing purposes
		
		trace(currentBar);
		if (currentBar == 132 && !checker)
		{
			trace((FlxG.sound.music.time - currentBar * beatTime * timeSignature) / (currentBar * beatTime * timeSignature));
			checker = true;
			//FlxG.sound.play(AssetPaths.boop__mp3);
		}*/
		
	}
	
	//	
	static public function calculateBeatAmount(intervalIndex:Int, step:Fast):Float {
		return(
			(step.has.bar ? Std.parseFloat(step.att.bar) * timeSignature : 0) +
			(step.has.beat ? Std.parseFloat(step.att.beat) - 1 : 0 ) +
			(step.has.interval ? intervalIndex * Std.parseFloat(step.att.interval) : 0)
		);
	}
}