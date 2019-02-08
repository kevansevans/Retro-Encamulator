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
		for (a in 0...255) _map[a] = op0x00; //allow op codes to be NOP for debug purposes
		
		//00
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
		//10
		_map[0x10] = op0x10;
		_map[0x11] = op0x11;
		_map[0x12] = op0x12;
		_map[0x13] = op0x13;
		_map[0x14] = op0x14;
		_map[0x15] = op0x15;
		_map[0x16] = op0x16;
		_map[0x17] = op0x17;
		_map[0x18] = op0x18;
		_map[0x19] = op0x19;
		_map[0x1A] = op0x1A;
		_map[0x1B] = op0x1B;
		_map[0x1C] = op0x1C;
		_map[0x1D] = op0x1D;
		_map[0x1E] = op0x1E;
		_map[0x1F] = op0x1F;
	}
	function set_cycle(_m:Int, _t:Int) {
		_cycle.m = _m;
		_cycle.t = _t;
	}
	///////////////////
	//OP codes 00 -> 0F
	///////////////////
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
	///////////////////
	//OP codes 10 -> 1F
	///////////////////
	/**Stop
	 * Stop processor*/
	function op0x10() {
		_stop = true;
		set_cycle(2, 4);
	}
	/**LD DE, nn
	 * Load 16 bit value into DE*/
	function op0x11() {
		_register.DE = _memory.read_word(_register.PC);
		set_cycle(3, 12);
	}
	/**LD (DE), A
	 * Save A to location of DE*/
	function op0x12() {
		_memory.write_byte(_register.DE, _register.A);
		set_cycle(1, 8);
	}
	/**INC DE
	 * Incriment DE by 1*/
	function op0x13() {
		_register.DE += 1;
		set_cycle(1, 8);
	}
	/**INC D
	 * Incriment D by 1*/
	function op0x14() {
		_register.D += 1;
		set_cycle(1, 4);
	}
	/**DEC D
	 * Decrease D by 1*/
	function op0x15() {
		_register.D -= 1;
		set_cycle(1, 4);
	}
	/**LD D, n
	 * Load value of location n into D*/
	function op0x16() {
		_register.D = _memory.read_byte(_register.PC);
		set_cycle(2, 8);
	}
	/**RLA
	 * Rotate A left*/
	function op0x17() {
		var ci = _register.F & 0x10 != 0 ? 1 : 0;
		var co = _register.A & 0x80 != 0 ? 0x10 : 0;
		_register.A = (_register.A << 1) + ci;
		_register.F = (_register.F & 0xEF) + co;
		set_cycle(1, 4);
	}
	/**JR n
	 * Jump to relative signed value*/
	function op0x18() {
		var i = _memory.read_byte(_register.PC); //get jump value
		if (i > 127) i -= ((~i + 1) & 255); //Checking if we're jumping forward or backwards.
		_register.PC += (1 + i);
		set_cycle(2, 12);
	}
	/**ADD HL, DE
	 * Add DE to HL*/
	function op0x19() {
		_register.HL += _register.DE;
		set_cycle(1, 8);
	}
	/**LD A, (DE)
	 * load value of location DE into A*/
	function op0x1A() {
		_register.A = _memory.read_byte(_register.DE);
		set_cycle(1, 8);
	}
	/**DEC DE
	 * Decrease DE by 1*/
	function op0x1B() {
		_register.DE -= 1;
		set_cycle(1, 8);
	}
	/**INC E
	 * Incriment E by 1*/
	function op0x1C() {
		_register.E += 1;
		set_cycle(1, 4);
	}
	/**DEC E
	 * Decrease E by 1*/
	function op0x1D() {
		_register.E -= 1;
		set_cycle(1, 4);
	}
	/**LD E, n
	 * Load value located at N into E*/
	function op0x1E() {
		_register.E = _memory.read_byte(_register.PC);
		set_cycle(2, 8);
	}
	/**RRA
	 * Rotate A right*/
	function op0x1F() {
		var ci = _register.F & 0x10 != 1 ? 0x80 : 0;
		var co = _register.A & 1 != 1 ? 0x10 : 0;
		_register.A = (_register.A >> 1) + ci;
		_register.F = (_register.F & 0xEF) + co;
		set_cycle(1, 4);
	}
	//////////////////
	//OP code 20 -> 2F
	//////////////////
}