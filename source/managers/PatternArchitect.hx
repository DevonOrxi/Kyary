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
	
	static public function createQueue(q:Array<Bullet>, data:Fast) {
		
		for (step in data.elements)
		{
			if (step.name == "bulletFan")
			{
				var b:Bullet;
				
				for (i in 0...Std.parseInt(step.att.amount))
				{					
					if (step.has.spawners && step.has.amplitude)
					{
						for (j in 0...Std.parseInt(step.att.spawners))
						{
							b = new Bullet();
							
							b.angle = step.has.angle ? Std.parseFloat(step.att.angle) : 0;
							b.angle += (step.has.amplitude && step.has.spawners) ?
									- Std.parseFloat(step.att.amplitude) / 2 + 
									j * Std.parseFloat(step.att.amplitude) / Std.parseInt(step.att.spawners) :
								0
							;
							
							b.setSpeed((step.has.velocity ? Std.parseFloat(step.att.velocity) : GC.playerBulletSpeed));
							
							
							//	Calculate bullet activation time							
							var beatAmount:Float = 
								(step.has.bar ? Std.parseFloat(step.att.bar) * GV.timeSignature : 0) +
								(step.has.beat ? Std.parseFloat(step.att.beat) : 0) +
								(step.has.interval ? (i - 1) * Std.parseFloat(step.att.interval) : 0);
							
							b.activationTime = beatAmount * GV.beatTime;
							
							q.push(b);
						}
					}
					else
					{
						if (step.has.amplitude)
							trace("BulletFan at " + GV.currentBar + "." + GV.currentBeat + " has amplitude but no spawners");
							
						b = new Bullet();
						b.angle = step.has.angle ? Std.parseFloat(step.att.angle) : 180;						
						b.setSpeed(step.has.velocity ? Std.parseFloat(step.att.velocity) : GC.playerBulletSpeed);
						
						//	Calculate bullet activation time
						var beatAmount:Float =
								(step.has.bar ? Std.parseFloat(step.att.bar) * GV.timeSignature : 0) +
								(step.has.beat ? Std.parseFloat(step.att.beat) : 0) +
								(step.has.interval ? (i - 1) * Std.parseFloat(step.att.interval) : 0);
								
						b.activationTime = beatAmount * GV.beatTime;
						
						q.push(b);
					}
				}
			}
		}
	}	
}