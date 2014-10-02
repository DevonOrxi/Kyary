package ;

/**
 * Cointains global game variables
 * 
 * @author Acid
 */
class GV
{	
	public static var bpm:Float = 165;
	
	public static var barTime:Float;
	public static var currentBar:Int = 0;
	public static var songBar:Float;	
	public static var barProgress:Float = 0;
	
	public static var timeSignature = 4;
	
	public static var isBeat = true;
	public static var beatTime:Float;
	public static var currentBeat:Int = 1;

	public function new() 
	{
		
	}
	
}