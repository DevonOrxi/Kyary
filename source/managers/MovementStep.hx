package managers;

/**
 * ...
 * @author Acid
 */
class MovementStep
{
	@:isVar public var activationTime(get, null):Float;
	@:isVar public var x(get, null):String;
	@:isVar public var y(get, null):String;
	@:isVar public var duration(get, null):Float;
	@:isVar public var type(get, null):String;
	

	public function new(X:String = "0", Y:String = "0", ActivationTime:Float = 0, Duration:Float = 0, T:String = "normal") {
		x = X;
		y = Y;
		activationTime = ActivationTime;
		duration = Duration;
		type = T;
	}
	
	public function get_x():String {
		return x;
	}
	
	public function get_y():String {
		return y;
	}
	
	public function get_duration():Float {
		return duration;
	}
	
	public function get_activationTime():Float {
		return activationTime;
	}
	
	public function get_type():String {
		return type;
	}
	
	
	
}