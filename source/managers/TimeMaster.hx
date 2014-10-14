package managers;

import flixel.FlxG;
import flixel.system.FlxSound;
import haxe.xml.Fast;

/**
 * ...
 * @author Acid
 */
class TimeMaster	//	Apprentice! Heartborne! Seventh Seeker!
{	
	static public var bpm:Float = 165;
	
	static public var barTime:Float;
	static public var currentBar:Int = 0;
	static public var songBar:Float;	
	static public var barProgress:Float = 0;
	
	static public var timeSignature = 4;
	
	static public var isBeat:Bool = true;
	static public var isHalfBeat:Bool = true;
	static public var checker:Bool = false;
	static public var beatTime:Float;
	static public var currentBeat:Int = 1;
	static public var currentHalfBeat:Int = 1;
	
	static public var beatScale:Float = 1;
	static public var song:FlxSound;

	static public function init() {
		
		beatTime = /*1454.54 / timeSignature;*/	1 / (bpm / 60) * 1000;
		barTime = timeSignature * beatTime + 0.000151171579;
		
	}
	
	static public function update():Void {
		
		songBar = TimeMaster.song.time / barTime;
		barProgress = songBar - Math.ffloor(songBar);
		
		isBeat = false;
		isHalfBeat = false;
		
		if (currentBar < Math.floor(songBar))
		{
			currentBeat = 1;
			currentHalfBeat = 1;
			currentBar++;
			isBeat = true;
			isHalfBeat = true;
			//trace(currentBar + "." + currentBeat + "." + currentHalfBeat);
		}		
		else if (barProgress > (currentBeat/timeSignature))
		{
			currentBeat++;
			currentHalfBeat++;
			isBeat = true;
			isHalfBeat = true;
			//trace(currentBar + "." + currentBeat + "." + currentHalfBeat);
		}
		else if (barProgress > (currentHalfBeat / (2 * timeSignature)))
		{
			currentHalfBeat++;
			isHalfBeat = true;
			//trace(currentBar + "." + currentBeat + "." + currentHalfBeat);
		}
		
		
		/*	This calculates the difference between the real song time at bar 132 and the math division
		 * 	Just for testing purposes */
		
		//trace(currentBar);
		/*if (currentBar == 132 && !checker)
		{
			trace((FlxG.sound.music.time - currentBar * beatTime * timeSignature) / (currentBar * beatTime * timeSignature));
			checker = true;
			FlxG.sound.play("assets/sounds/explode.wav");
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