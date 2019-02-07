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
	var _register:Register;
	var _memory:Memory;
	public function new(_reg:Register, _mem:Memory) 
	{
		_register = _reg;
		_memory = _mem;
		write_map_table();
	}
	public function run() 
	{
		while (true) {
			step();
		}
	}
	public function step(?_code:Int) {
		_opcode = Matrix.memory.read_byte(_register.PC++);
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
		Sys.println("OP: " + StringTools.hex(_opcode, 2) + ", " + _register.toString(true));
		#else
		trace("OP: " + StringTools.hex(_opcode, 2), Matrix.register.toString(true));
		#end
		#end
	}
	function write_map_table() 
	{
		for (a in 0...255) _map[a] = op0x00;
		
		_map[0x00] = op0x00;
		_map[0x01] = op0x01;
		_map[0x02] = op0x02;
		_map[0x03] = op0x03;
		_map[0x04] = op0x04;
		_map[0x05] = op0x05;
		_map[0x06] = op0x06;
		_map[0x07] = op0x07;
		_map[0x08] = op0x08;
		_map[0x09] = op0x09;
		_map[0x0A] = op0x0A;
		_map[0x0B] = op0x0B;
		_map[0x0C] = op0x0C;
		_map[0x0D] = op0x0D;
		_map[0x0E] = op0x0E;
		_map[0x0F] = op0x0F;
	}
	function set_cycle(_m:Int, _t:Int) {
		_cycle.m = _m;
		_cycle.t = _t;
	}
	/**NOP*/
	function op0x00() {
		set_cycle(1, 4);
	}
	/**LD BC, nn
	 * Load 16-bit into BC*/
	function op0x01() {
		_register.BC = _memory.read_word(_register.PC);
		set_cycle(3, 12);
	}
	/**LD (BC), A*
	 * Save A to location BC*/
	function op0x02() {
		_memory.write_byte(_register.BC, _register.A);
		set_cycle(1, 8);
	}
	/**INC BC
	 * Incriment BC by 1*/
	function op0x03() {
		_register.BC += 1;
		set_cycle(1, 8);
	}
	/**INC B
	 * Incriment B by 1*/
	function op0x04() {
		_register.B += 1;
		set_cycle(1, 4);
	}
	/**DEC B
	 * Deacrease B by 1*/
	function op0x05() {
		_register.B -= 1;
		set_cycle(1, 4);
	}
	/**LD B, n
	 * Load 8-bit into B*/
	function op0x06() {
		_register.B = _memory.read_byte(_register.PC);
		set_cycle(2, 8);
	}
	/**RLC A
	 * Rotate A left with carry*/
	function op0x07() {
		var ci = _register.A & 0x80 != 0 ? 1 : 0; //gets the value of bit 7 and adds it to bit 0
		var co = _register.A & 0x80 != 0 ? 0x10 : 0; //gets value to adjust to Register F
		_register.A = (_register.A << 1) + ci;
		_register.F = (_register.F & 0xEF) + co;
		set_cycle(1, 4);
	}
	/**LD (nn), SP
	 * Save SP to address specified*/
	function op0x08() {
		_memory.write_word(_memory.read_word(_register.PC), _register.SP);
		set_cycle(3, 20);
	}
	/**ADD HL, BC
	 * Add BC to HL*/
	function op0x09() {
		_register.HL += _register.BC;
		set_cycle(1, 8);
	}
	/**LD A, (BC)
	 * Set A to value of location BC*/
	function op0x0A() {
		_register.A = _memory.read_byte(_register.BC);
		set_cycle(1, 8);
	}
	/**DEC BC
	 * Deacrease BC by 1*/
	function op0x0B() {
		_register.BC -= 1;
		set_cycle(1, 8);
	}
	/**INC C
	 * Incriment C by 1*/
	function op0x0C() {
		_register.C += 1;
		set_cycle(1, 4);
	}
	/**DEC C
	 * Decrease C by 1*/
	function op0x0D() {
		_register.C -= 1;
		set_cycle(1, 4);
	}
	/**LD C, n
	 * Load Value located at N into C*/
	function op0x0E() {
		_register.C = _memory.read_byte(_register.PC);
		set_cycle(2, 8);
	}
	/**RRCA
	 * Rotate A right with carry*/
	function op0x0F() {
		var ci = _register.A & 1 != 0 ? 0x80 : 0;
		var co = _register.A & 1 != 0 ? 0x10 : 0;
		_register.A = (_register.A >> 1) + ci;
		_register.F = (_register.F & 0xEF) + co;
		set_cycle(1, 4);
	}
}