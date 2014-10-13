package managers;

/**
 * ...
 * @author Acid
 */
class SoundStep
{
	@:isVar public var activationTime(get, null):Float;
	@:isVar public var volume(get, null):Float;
	@:isVar public var name(get, null):String;
	

	public function new(Name:String = "0", Volume:Float = 0, ActivationTime:Float = 0) {
		name = Name;
		volume = Volume;
		activationTime = ActivationTime;
	}
	
	public function get_name():String {
		return name;
	}
	
	public function get_volume():Float {
		return volume;
	}
	
	public function get_activationTime():Float {
		return activationTime;
	}
	
	
	
}