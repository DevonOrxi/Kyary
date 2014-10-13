package managers;

import haxe.xml.Fast;
import entities.Bullet;
import managers.MovementStep;

/**
 * Reads the XML with enemy patterns and translates it into a series of bullets
 * ...
 * @author Acid
 */
class QueueManager
{
	
	static public var enemyBulletQueue:Array<Bullet>;
	static public var enemyMovementQueue:Array<MovementStep>;
	static public var enemyChargeQueue:Array<Float>;
	static public var enemySoundQueue:Array<SoundStep>;
	
	
	static public function init(data:Fast):Void {
		
		enemyBulletQueue = new Array<Bullet>();
		enemyMovementQueue = new Array<MovementStep>();
		enemyChargeQueue = new Array<Float>();
		enemySoundQueue = new Array<SoundStep>();
		
		createQueue(data);		
	}
	
	static private function createQueue(data:Fast):Void {
		
		for (step in data.elements) {
			if (step.name == "bulletFan") {
				var b:Bullet;
				
				for (i in 0...Std.parseInt(step.att.amount))
				{
					var bSpeed:Float = 0;
					
					if (step.has.speed) {
						if (step.has.speedFrom)
							bSpeed = Std.parseFloat(step.att.speedFrom) + 
								(Std.parseFloat(step.att.speed) - Std.parseFloat(step.att.speedFrom)) * i / (Std.parseInt(step.att.amount) - 1);
						else
							bSpeed = Std.parseFloat(step.att.speed);
					}
					else
						bSpeed = GC.playerBulletSpeed;
					
					if (step.has.spawners && step.has.amplitude)
						for (j in 0...Std.parseInt(step.att.spawners)) {
							
							b = new Bullet();
							
							b.angle = step.has.angle ? Std.parseFloat(step.att.angle) : 0;
							b.angle += (step.has.amplitude && step.has.spawners) ?
									- Std.parseFloat(step.att.amplitude) / 2 + 
									j * Std.parseFloat(step.att.amplitude) / (Std.parseInt(step.att.spawners) - 1) :
								0
							;
							
							b.setSpeedDirection(bSpeed);
							
							
							//	Calculate bullet activation time
							b.activationTime = TimeMaster.calculateBeatAmount(i, step) * TimeMaster.beatTime;
							
							enemyBulletQueue.push(b);
							
						}
					else {
						
						if (step.has.amplitude)
							trace("BulletFan at " + TimeMaster.currentBar + "." + TimeMaster.currentBeat + " has amplitude but no spawners");
							
						b = new Bullet();
						b.angle = step.has.angle ? Std.parseFloat(step.att.angle) : 180;						
						b.setSpeedDirection(bSpeed);
						
						//	Calculate bullet activation time								
						b.activationTime = TimeMaster.calculateBeatAmount(i, step) * TimeMaster.beatTime;
						
						enemyBulletQueue.push(b);
					}
				}
			}
			
			if (step.name == "move") {
				
				enemyMovementQueue.push(new MovementStep(
					step.has.x ? step.att.x : "null",
					step.has.y ? step.att.y : "null",
					(step.has.bar && step.has.beat) ? TimeMaster.calculateBeatAmount(0, step) * TimeMaster.beatTime : 0,
					step.has.duration ? Std.parseFloat(step.att.duration) * TimeMaster.beatTime  : 0,
					step.has.type ? step.att.type : "normal"
				));
				
			}
			
			if (step.name == "charge") {
				enemyChargeQueue.push((step.has.bar && step.has.beat) ? TimeMaster.calculateBeatAmount(0, step) * TimeMaster.beatTime : 0);
			}
		}
	}	
}