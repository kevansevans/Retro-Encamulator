package haxewell;

/**
 * ...
 * @author Kaelan
 * 
 * All Emulator cores check back to this class for input values. Set up a front end to toggle the values.
 * 
 *  
 * 
 */
 
enum abstract Key(Int) from Int {
	var START:Int;
	var SELECT:Int;
	var FACE_1:Int;
	var FACE_2:Int; 
	var FACE_3:Int;
	var FACE_4:Int;
	var FACE_5:Int;
	var FACE_6:Int;
	var LEFT_1:Int;
	var LEFT_2:Int;
	var LEFT_3:Int;
	var RIGHT_1:Int;
	var RIGHT_2:Int;
	var RIGHT_3:Int;
}
class InputManager
{
	public static var Input:Map < Int, Null<Bool> > = new Map();
	public function new() 
	{
		
	}
	
}