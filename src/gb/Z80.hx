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
	var op:Int;
	var ignore_false_nop = #if debug true #else false #end;
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
			#if debug
			trace(op, _register[Register.a], _register[Register.b], _register[Register.c], _register[Register.d], _register[Register.e], _register[Register.f], _register[Register.h], _register[Register.l], _register[Register.pc], _register[Register.sp], _register[Register.t], _register[Register.m]);
			#end
		}
	}
	function nop() {
		if (op != 0 && !ignore_false_nop) throw "Op code not set, please check: " + StringTools.hex(op);
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
	//increase value at location of HL
	function inc_hl() {
		var hl = (_register[Register.h] << 8) + _register[Register.l];
		var i = _meminter.read_byte(hl) + 1;
		i &= 255;
		_meminter.write_byte(hl, i);
		_register[Register.f] = i == 0 ? 0 : 0x80;
		m_time(3, 11);
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
	//increase value at location of HL
	function dec_hl() {
		var hl = (_register[Register.h] << 8) + _register[Register.l];
		var i = _meminter.read_byte(hl) - 1;
		i &= 255;
		_meminter.write_byte(hl, i);
		_register[Register.f] = i == 0 ? 0 : 0x80;
		m_time(3, 11);
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
	//Load nn into RR
	function load_rrnn(_high:Int, _low:Int) {
		_register[_low] = _meminter.read_byte(_register[Register.pc]);
		_register[_high] = _meminter.read_byte(_register[Register.pc + 1]);
		_register[Register.pc] += 2;
		m_time(2, 10);
	}
	function write_map_table() 
	{
		_map[0x00] = nop; //No operation
		_map[0x01] = load_rrnn.bind(Register.b, Register.c); // ld bc, nn
		_map[0x02] = nop; // ld (bc), a
		_map[0x03] = inc.bind(Register.b, Register.c); //incriment BC
		_map[0x04] = inc.bind(Register.b); //Incriment B
		_map[0x05] = dec.bind(Register.b); //decrease B
		_map[0x06] = load_rn.bind(Register.b);
		_map[0x07] = nop;
		_map[0x08] = nop;
		_map[0x09] = nop;
		_map[0x0A] = load_rRRm.bind(Register.a, Register.b, Register.c);
		_map[0x0B] = dec.bind(Register.b, Register.c);
		_map[0x0C] = inc.bind(Register.c);
		_map[0x0D] = dec.bind(Register.c);
		_map[0x0E] = load_rn.bind(Register.c);
		_map[0x0F] = nop;
		_map[0x10] = nop;
		_map[0x11] = load_rrnn.bind(Register.d, Register.e);
		_map[0x12] = nop;
		_map[0x13] = inc.bind(Register.d, Register.e);
		_map[0x14] = inc.bind(Register.d);
		_map[0x15] = dec.bind(Register.d);
		_map[0x16] = load_rn.bind(Register.d);
		_map[0x17] = nop;
		_map[0x18] = nop;
		_map[0x19] = nop;
		_map[0x1A] = load_rRRm.bind(Register.a, Register.d, Register.e);
		_map[0x1B] = dec.bind(Register.d, Register.e);
		_map[0x1C] = inc.bind(Register.e);
		_map[0x1D] = dec.bind(Register.e);
		_map[0x1E] = load_rn.bind(Register.e);
		_map[0x1F] = nop;
		_map[0x20] = nop;
		_map[0x21] = load_rrnn.bind(Register.h, Register.l);
		_map[0x22] = nop;
		_map[0x23] = inc.bind(Register.h, Register.l);
		_map[0x24] = inc.bind(Register.h);
		_map[0x25] = dec.bind(Register.h);
		_map[0x26] = load_rn.bind(Register.h);
		_map[0x27] = nop;
		_map[0x28] = nop;
		_map[0x29] = nop;
		_map[0x2A] = load_hlmn;
		_map[0x2B] = dec.bind(Register.h, Register.l);
		_map[0x2C] = inc.bind(Register.l);
		_map[0x2D] = dec.bind(Register.l);
		_map[0x2E] = load_rn.bind(Register.a);
		_map[0x2F] = nop;
		_map[0x30] = nop;
		_map[0x31] = nop;
		_map[0x32] = load_rn.bind(Register.sp);
		_map[0x33] = inc.bind(Register.sp);
		_map[0x34] = inc_hl;
		_map[0x35] = dec_hl;
		_map[0x36] = nop;
		_map[0x37] = nop;
		_map[0x38] = nop;
		_map[0x39] = nop;
		_map[0x3A] = nop;
		_map[0x3B] = dec.bind(Register.sp);
		_map[0x3C] = inc.bind(Register.a);
		_map[0x3D] = dec.bind(Register.a);
		_map[0x3E] = nop;
		_map[0x3F] = nop;
		_map[0x40] = load_rr.bind(Register.b, Register.b);
		_map[0x41] = load_rr.bind(Register.b, Register.c);
		_map[0x42] = load_rr.bind(Register.b, Register.d);
		_map[0x43] = load_rr.bind(Register.b, Register.e);
		_map[0x44] = load_rr.bind(Register.b, Register.h);
		_map[0x45] = load_rr.bind(Register.b, Register.l);
		_map[0x46] = load_rHLm.bind(Register.b);
		_map[0x47] = load_rr.bind(Register.b, Register.a);
		_map[0x48] = load_rr.bind(Register.c, Register.b);
		_map[0x49] = load_rr.bind(Register.c, Register.c);
		_map[0x4A] = load_rr.bind(Register.c, Register.d);
		_map[0x4B] = load_rr.bind(Register.c, Register.e);
		_map[0x4C] = load_rr.bind(Register.c, Register.h);
		_map[0x4D] = load_rr.bind(Register.c, Register.l);
		_map[0x4E] = load_rHLm.bind(Register.c);
		_map[0x4F] = load_rr.bind(Register.c, Register.a);
		_map[0x50] = load_rr.bind(Register.d, Register.b);
		_map[0x51] = load_rr.bind(Register.d, Register.c);
		_map[0x52] = load_rr.bind(Register.d, Register.d);
		_map[0x53] = load_rr.bind(Register.d, Register.e);
		_map[0x54] = load_rr.bind(Register.d, Register.h);
		_map[0x55] = load_rr.bind(Register.d, Register.l);
		_map[0x56] = load_rHLm.bind(Register.d);
		_map[0x57] = load_rr.bind(Register.d, Register.a);
		_map[0x58] = load_rr.bind(Register.e, Register.b);
		_map[0x59] = load_rr.bind(Register.e, Register.c);
		_map[0x5A] = load_rr.bind(Register.e, Register.d);
		_map[0x5B] = load_rr.bind(Register.e, Register.e);
		_map[0x5C] = load_rr.bind(Register.e, Register.h);
		_map[0x5D] = load_rr.bind(Register.e, Register.l);
		_map[0x5E] = load_rHLm.bind(Register.e);
		_map[0x5F] = load_rr.bind(Register.e, Register.a);
		_map[0x60] = load_rr.bind(Register.h, Register.b);
		_map[0x61] = load_rr.bind(Register.h, Register.c);
		_map[0x62] = load_rr.bind(Register.h, Register.d);
		_map[0x63] = load_rr.bind(Register.h, Register.e);
		_map[0x64] = load_rr.bind(Register.h, Register.h);
		_map[0x65] = load_rr.bind(Register.h, Register.l);
		_map[0x66] = load_rHLm.bind(Register.h);
		_map[0x67] = load_rr.bind(Register.h, Register.a);
		_map[0x68] = load_rr.bind(Register.l, Register.b);
		_map[0x69] = load_rr.bind(Register.l, Register.c);
		_map[0x6A] = load_rr.bind(Register.l, Register.d);
		_map[0x6B] = load_rr.bind(Register.l, Register.e);
		_map[0x6C] = load_rr.bind(Register.l, Register.h);
		_map[0x6D] = load_rr.bind(Register.l, Register.l);
		_map[0x6E] = load_rHLm.bind(Register.l);
		_map[0x6F] = load_rr.bind(Register.l, Register.a);
		_map[0x70] = load_HLmr.bind(Register.b);
		_map[0x71] = load_HLmr.bind(Register.c);
		_map[0x72] = load_HLmr.bind(Register.d);
		_map[0x73] = load_HLmr.bind(Register.e);
		_map[0x74] = load_HLmr.bind(Register.h);
		_map[0x75] = load_HLmr.bind(Register.l);
		_map[0x76] = halt;
		_map[0x77] = load_HLmr.bind(Register.a);
		_map[0x78] = load_rr.bind(Register.a, Register.b);
		_map[0x79] = load_rr.bind(Register.a, Register.c);
		_map[0x7A] = load_rr.bind(Register.a, Register.d);
		_map[0x7B] = load_rr.bind(Register.a, Register.e);
		_map[0x7C] = load_rr.bind(Register.a, Register.h);
		_map[0x7D] = load_rr.bind(Register.a, Register.l);
		_map[0x7E] = load_rHLm.bind(Register.a);
		_map[0x7F] = load_rr.bind(Register.a, Register.a);
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