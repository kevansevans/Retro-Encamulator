package gb;

import haxe.Constraints.Function;
import gb.Register;

/**
 * ...
 * @author Kaelan
 * 
 * made following tutorial: http://imrannazar.com/GameBoy-Emulation-in-JavaScript:-The-CPU
 * 
 */
class Z80 
{
	public static var _clock:Clock;
	public static var _register:Array<Int>;
	var _meminter:Memory;
	var _map:Map<Int, Function> = new Map();
	public function new() 
	{
		_clock = new Clock();
		_register = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
		_meminter = new Memory();
		write_map_table();
		run();
	}
	function run() 
	{
		while (true) {
			var op = _meminter.read_byte(++_register[Register.pc]);
			if (_map[op] == null) throw "Null function pointer at: " + op; //take this out when needed
			_map[op]();
			_register[Register.pc] &= 65535;
			_clock.m += _register[Register.m];
			_clock.t += _register[Register.t];
			//trace(_register[Register.a], _register[Register.b], _register[Register.c], _register[Register.d], _register[Register.e], _register[Register.f], _register[Register.h], _register[Register.l], _register[Register.pc], _register[Register.sp], _register[Register.t], _register[Register.m]);
		}
	}
	function nop() {
		_register[Register.m] = 1; _register[Register.t] = 4;
	}
	function m_time(_m:Int, _t:Int) {
		_register[Register.m] = _m;
		_register[Register.t] = _t;
	}
	function reset() {
		_clock = new Clock();
		_register = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
	}
	//increase register by 1. Can handle 16bit registers
	function inc(_high:Int, ?_low:Int) {
		if (_low == null) {
			_register[_high] += 1;
			_register[_high] &= 0xff;
			m_time(1, 4);
		} else {
			var _word = _register[_high] << 8 | _register[_low];
			_word += 1;
			_register[_high] = (_word >> 8) & 0xFF;
			_register[_low] = _word & 0xFF;
			m_time(3, 11);
		}
	}
	//decrease register by 1. Can handle 16 bit register
	function dec(_high:Int, ?_low:Int) {
		if (_low == null) {
			_register[_high] -= 1;
			_register[_high] &= 0xff;
			m_time(1, 4);
		} else {
			var _word = _register[_high] << 8 | _register[_low];
			_word -= 1;
			_register[_high] = (_word >> 8) & 0xFF;
			_register[_low] = _word & 0xFF;
			m_time(3, 11);
		}
	}
	//Load content of b into a
	function load_rr(_regA:Int, _regB:Int) {
		_register[_regA] = _register[_regB];
		m_time(1, 4);
	}
	//Load the contents of memory location (hl) into register
	function load_rHLm(_reg:Int) {
		var hl = (_register[Register.h] << 8) + _register[Register.l];
		var val = _meminter.read_byte(hl);
		_register[_reg] = val;
		m_time(2, 7);
	}
	//Load register and write to location (HL)
	function load_HLmr(_reg:Int) {
		var hl = (_register[Register.h] << 8) + _register[Register.l];
		_meminter.write_byte(hl, _register[_reg]);
		m_time(2, 7);
	}
	//Load memory at PC location and set it to registry
	function load_rn(_reg:Int) {
		var byte = _meminter.read_byte(_register[Register.pc]);
		_register[_reg] = byte;
		_register[Register.pc] += 1;
		m_time(2, 7);
	}
	//Load memory at PC and write it to memory at HL
	function load_hlmn() {
		var byte = _meminter.read_byte(_register[Register.pc]);
		var hl = (_register[Register.h] << 8) + _register[Register.l];
		_meminter.write_byte(hl, byte);
		_register[Register.pc] += 1;
		m_time(3, 10);
	}
	//Load register r and load it into memory at RR
	function load_rrma(_high:Int, _low:Int, _reg:Int) {
		var byte = (_register[_high] << 8) + _register[_low];
		_meminter.write_byte(byte, _register[_reg]);
		m_time(2, 7);
	}
	//Load word at PC (A), Write register to A as byte
	function load_mmr(_reg:Int) {
		_meminter.write_byte(_meminter.read_word(_register[Register.pc]), _register[Register.a]);
		_register[Register.pc] += 2;
		m_time(4, 13);
	}
	//load byte at RR and set it to r
	function load_rRRm(_reg:Int, _high:Int, _low:Int) {
		var byte = (_register[_high] << 8) + _register[_low];
		_register[_reg] = _meminter.read_byte(byte);
		m_time(2, 7);
	}
	function write_map_table() 
	{
		_map[0x00] = nop; //No operation
		_map[0x01] = nop;
		_map[0x02] = nop;
		_map[0x03] = inc.bind(Register.b, Register.c); //incriment BC
		_map[0x04] = inc.bind(Register.b); //Incriment B
		_map[0x05] = dec.bind(Register.b); //decrease B
		_map[0x06] = nop;
		_map[0x07] = nop;
		_map[0x08] = nop;
		_map[0x09] = nop;
		_map[0x0A] = nop;
		_map[0x0B] = dec.bind(Register.b, Register.c);
		_map[0x0C] = inc.bind(Register.c);
		_map[0x0D] = dec.bind(Register.c);
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
		_map[0x3A] = nop;
		_map[0x3B] = nop;
		_map[0x3C] = nop;
		_map[0x3D] = nop;
		_map[0x3E] = nop;
		_map[0x3F] = nop;
		_map[0x40] = nop;
		_map[0x41] = nop;
		_map[0x42] = nop;
		_map[0x43] = nop;
		_map[0x44] = nop;
		_map[0x45] = nop;
		_map[0x46] = nop;
		_map[0x47] = nop;
		_map[0x48] = nop;
		_map[0x49] = nop;
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
class Clock {
	public var m:Int = 0;
	public var t:Int = 0;
	public function new () {}
}