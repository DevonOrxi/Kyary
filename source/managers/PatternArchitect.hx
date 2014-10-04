package managers;

import haxe.xml.Fast;
import entities.Bullet;

/**
 * Reads the XML with enemy patterns and translates it into a series of bullets
 * ...
 * @author Acid
 */
class PatternArchitect
{
	
	static public function createQueue(q:Array<Bullet>, data:Fast)
	{
		for (step in data.elements)
		{
			if (step.name == "lineBullet")
				for (i in 0...Std.parseInt(step.att.amount))
					q.push(new Bullet(
						0,	//will be updated in Enemy
						0,	//will be updated in Enemy
						Std.parseFloat(step.att.velX),
						Std.parseFloat(step.att.velY),
						Std.parseFloat(step.att.timestamp) + (i - 1) * GV.beatTime
					));
		}
	}
	
}