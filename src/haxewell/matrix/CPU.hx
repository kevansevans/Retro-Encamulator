package haxewell.matrix;
/**
 * ...
 * @author Kaelan
 * 
 * made following tutorial: http://imrannazar.com/GameBoy-Emulation-in-JavaScript:-The-CPU
 * 
 */
class CPU 
{
	var _opcode:Int = 0;
	var _map:Map<Int, Void -> Void> = new Map();
	var _halt:Bool = false;
	var _stop:Bool = false;
	var _clock = { m:0, t:0 };
	var _cycle = { m:0, t:0 };
	public function new() 
	{
		write_map_table();
	}
	public function run() 
	{
		while (true) {
			step();
		}
	}
	public function step(?_code:Int) {
		_opcode = Matrix.memory.read_byte(Matrix.register.PC++);
		_opcode &= 0xFF;
		#if debug
		if (_map[_opcode] == null) _map[0x00]();
		#else
		if (_map[_opcode] == null) throw "Illegal op code executed! " + StringTools.hex(_opcode, 2) + ", if this is not meant to happen, get ahold of a developer!";
		#end
		else _map[_opcode]();
		_clock.m += _cycle.m;
		_clock.t += _cycle.t;
		#if debug
		#if sys
		Sys.println(Matrix.register.toString(true));
		#else
		trace(Matrix.register.toString(true));
		#end
		#end
	}
	function write_map_table() 
	{
		for (a in 0...255) _map[a] = op0x00;
		
		_map[0x00] = op0x00;
	}
	function set_cycle(_m:Int, _t:Int) {
		_cycle.m = _m;
		_cycle.t = _t;
	}
	/**NOP*/
	function op0x00() {
		set_cycle(1, 4);
	}
}