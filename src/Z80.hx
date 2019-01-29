package;

import haxe.Constraints.Function;

/**
 * ...
 * @author Kaelan
 * 
 * made following tutorial: http://imrannazar.com/GameBoy-Emulation-in-JavaScript:-The-CPU
 * 
 */
enum abstract Register(Int) from Int {
	var a:Int;
	var b:Int;
	var c:Int;
	var d:Int;
	var e:Int;
	var f:Int;
	var h:Int;
	var l:Int;
	var pc:Int;
	var sp:Int;
	var t:Int;
	var m:Int;
}
class Z80 
{
	var _clock:Clock;
	var _register:Array<Int>;
	var _meminter:MemoryInterface;
	var _map:Map<Int, Function>;
	var temp_mem:Array<Int> = [0x03];
	public function new() 
	{
		_clock = new Clock();
		_register = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
		_meminter = new MemoryInterface();
		write_map_table();
		run();
	}
	function run() 
	{
		while (true) {
			var op = _meminter.read_byte(++_register[Register.pc]);
			_map[op]();
			_register[Register.pc] &= 65535;
			_clock.m += _register[Register.m];
			_clock.t += _register[Register.t];
			trace(_register[Register.a], _register[Register.b], _register[Register.c], _register[Register.d], _register[Register.e], _register[Register.f], _register[Register.h], _register[Register.l], _register[Register.pc], _register[Register.sp], _register[Register.t], _register[Register.m]);
		}
	}
	public function nop() {
		_register[Register.m] = 1; _register[Register.t] = 4;
	}
	public function reset() {
		_clock = new Clock();
		_register = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
	}
	//Abstracted functions
	public function inc(_a:Int, ?_b:Int) {
		_register[_a] += 1;
		if (_b != null) _register[_b] += 1;
		if (_b != null) m_time(6);
		else m_time(4);
	}
	public function dec(_a:Int, ?_b:Int) {
		_register[_a] -= 1;
		if (_b != null) _register[_b] -= 1;
		if (_b != null) m_time(6);
		else m_time(4);
	}
	function m_time(_v:Int) {
		_register[Register.m] = _v;
		_register[Register.t] = _v * 4;
	}
	function write_map_table() 
	{
		_map = new Map();
		_map[0x00] = nop; //No operation
		_map[0x01] = nop;
		_map[0x02] = nop;
		_map[0x03] = inc.bind(Register.b, Register.c); //incriment B and C
		_map[0x04] = nop;
		_map[0x05] = nop;
		_map[0x06] = nop;
		_map[0x07] = nop;
		_map[0x08] = nop;
		_map[0x09] = nop;
		_map[0x0A] = nop;
		_map[0x0B] = nop;
		_map[0x0C] = nop;
		_map[0x0D] = nop;
		_map[0x0E] = nop;
		_map[0x0F] = nop;
		_map[0x10] = nop;
		_map[0x11] = nop;
		_map[0x12] = nop;
		_map[0x13] = nop;
		_map[0x14] = nop;
		_map[0x15] = nop;
		_map[0x16] = nop;
		_map[0x17] = nop;
		_map[0x18] = nop;
		_map[0x19] = nop;
		_map[0x1A] = nop;
		_map[0x1B] = nop;
		_map[0x1C] = nop;
		_map[0x1D] = nop;
		_map[0x1E] = nop;
		_map[0x1F] = nop;
		_map[0x20] = nop;
		_map[0x21] = nop;
		_map[0x22] = nop;
		_map[0x23] = nop;
		_map[0x24] = nop;
		_map[0x25] = nop;
		_map[0x26] = nop;
		_map[0x27] = nop;
		_map[0x28] = nop;
		_map[0x29] = nop;
		_map[0x2A] = nop;
		_map[0x2B] = nop;
		_map[0x2C] = nop;
		_map[0x2D] = nop;
		_map[0x2E] = nop;
		_map[0x2F] = nop;
		_map[0x30] = nop;
		_map[0x31] = nop;
		_map[0x32] = nop;
		_map[0x33] = nop;
		_map[0x34] = nop;
		_map[0x35] = nop;
		_map[0x36] = nop;
		_map[0x37] = nop;
		_map[0x38] = nop;
		_map[0x39] = nop;
		_map[0x4A] = nop;
		_map[0x4B] = nop;
		_map[0x4C] = nop;
		_map[0x4D] = nop;
		_map[0x4E] = nop;
		_map[0x4F] = nop;
		_map[0x50] = nop;
		_map[0x51] = nop;
		_map[0x52] = nop;
		_map[0x53] = nop;
		_map[0x54] = nop;
		_map[0x55] = nop;
		_map[0x56] = nop;
		_map[0x57] = nop;
		_map[0x58] = nop;
		_map[0x59] = nop;
		_map[0x5A] = nop;
		_map[0x5B] = nop;
		_map[0x5C] = nop;
		_map[0x5D] = nop;
		_map[0x5E] = nop;
		_map[0x5F] = nop;
		_map[0x60] = nop;
		_map[0x61] = nop;
		_map[0x62] = nop;
		_map[0x63] = nop;
		_map[0x64] = nop;
		_map[0x65] = nop;
		_map[0x66] = nop;
		_map[0x67] = nop;
		_map[0x68] = nop;
		_map[0x69] = nop;
		_map[0x6A] = nop;
		_map[0x6B] = nop;
		_map[0x6C] = nop;
		_map[0x6D] = nop;
		_map[0x6E] = nop;
		_map[0x6F] = nop;
		_map[0x70] = nop;
		_map[0x71] = nop;
		_map[0x72] = nop;
		_map[0x73] = nop;
		_map[0x74] = nop;
		_map[0x75] = nop;
		_map[0x76] = nop;
		_map[0x77] = nop;
		_map[0x78] = nop;
		_map[0x79] = nop;
		_map[0x7A] = nop;
		_map[0x7B] = nop;
		_map[0x7C] = nop;
		_map[0x7D] = nop;
		_map[0x7E] = nop;
		_map[0x7F] = nop;
		_map[0x80] = nop;
		_map[0x81] = nop;
		_map[0x82] = nop;
		_map[0x83] = nop;
		_map[0x84] = nop;
		_map[0x85] = nop;
		_map[0x86] = nop;
		_map[0x87] = nop;
		_map[0x88] = nop;
		_map[0x89] = nop;
		_map[0x8A] = nop;
		_map[0x8B] = nop;
		_map[0x8C] = nop;
		_map[0x8D] = nop;
		_map[0x8E] = nop;
		_map[0x8F] = nop;
		_map[0x90] = nop;
		_map[0x91] = nop;
		_map[0x92] = nop;
		_map[0x93] = nop;
		_map[0x94] = nop;
		_map[0x95] = nop;
		_map[0x96] = nop;
		_map[0x97] = nop;
		_map[0x98] = nop;
		_map[0x99] = nop;
		_map[0x9A] = nop;
		_map[0x9B] = nop;
		_map[0x9C] = nop;
		_map[0x9D] = nop;
		_map[0x9E] = nop;
		_map[0x9F] = nop;
		_map[0xa0] = nop;
		_map[0xA1] = nop;
		_map[0xA2] = nop;
		_map[0xA3] = nop;
		_map[0xA4] = nop;
		_map[0xA5] = nop;
		_map[0xA6] = nop;
		_map[0xA7] = nop;
		_map[0xA8] = nop;
		_map[0xA9] = nop;
		_map[0xAA] = nop;
		_map[0xAB] = nop;
		_map[0xAC] = nop;
		_map[0xAD] = nop;
		_map[0xAE] = nop;
		_map[0xAF] = nop;
		_map[0xB0] = nop;
		_map[0xB1] = nop;
		_map[0xB2] = nop;
		_map[0xB3] = nop;
		_map[0xB4] = nop;
		_map[0xB5] = nop;
		_map[0xB6] = nop;
		_map[0xB7] = nop;
		_map[0xB8] = nop;
		_map[0xB9] = nop;
		_map[0xBA] = nop;
		_map[0xBB] = nop;
		_map[0xBC] = nop;
		_map[0xBD] = nop;
		_map[0xBE] = nop;
		_map[0xBF] = nop;
		_map[0xC0] = nop;
		_map[0xC1] = nop;
		_map[0xC2] = nop;
		_map[0xC3] = nop;
		_map[0xC4] = nop;
		_map[0xC5] = nop;
		_map[0xC6] = nop;
		_map[0xC7] = nop;
		_map[0xC8] = nop;
		_map[0xC9] = nop;
		_map[0xCA] = nop;
		_map[0xCB] = nop;
		_map[0xCC] = nop;
		_map[0xCD] = nop;
		_map[0xCE] = nop;
		_map[0xCF] = nop;
		_map[0xD0] = nop;
		_map[0xD1] = nop;
		_map[0xD2] = nop;
		_map[0xD3] = nop;
		_map[0xD4] = nop;
		_map[0xD5] = nop;
		_map[0xD6] = nop;
		_map[0xD7] = nop;
		_map[0xD8] = nop;
		_map[0xD9] = nop;
		_map[0xDA] = nop;
		_map[0xDB] = nop;
		_map[0xDC] = nop;
		_map[0xDD] = nop;
		_map[0xDE] = nop;
		_map[0xDF] = nop;
		_map[0xE0] = nop;
		_map[0xE1] = nop;
		_map[0xE2] = nop;
		_map[0xE3] = nop;
		_map[0xE4] = nop;
		_map[0xE5] = nop;
		_map[0xE6] = nop;
		_map[0xE7] = nop;
		_map[0xE8] = nop;
		_map[0xE9] = nop;
		_map[0xEA] = nop;
		_map[0xEB] = nop;
		_map[0xEC] = nop;
		_map[0xED] = nop;
		_map[0xEE] = nop;
		_map[0xEF] = nop;
		_map[0xF0] = nop;
		_map[0xF1] = nop;
		_map[0xF2] = nop;
		_map[0xF3] = nop;
		_map[0xF4] = nop;
		_map[0xF5] = nop;
		_map[0xF6] = nop;
		_map[0xF7] = nop;
		_map[0xF8] = nop;
		_map[0xF9] = nop;
		_map[0xFA] = nop;
		_map[0xFB] = nop;
		_map[0xFC] = nop;
		_map[0xFD] = nop;
		_map[0xFE] = nop;
		_map[0xFF] = nop;
	}
}
class MemoryInterface {
	public function new() {}
	public function read_byte(_addr):Int {return 0x03; }
	public function read_word(_addr):Int {return 0; }
	public function write_byte(_addr, _value) {}
	public function write_word(_addr, _value) {}
}
class Clock {
	public var m:Int = 0;
	public var t:Int = 0;
	public function new () {}
}