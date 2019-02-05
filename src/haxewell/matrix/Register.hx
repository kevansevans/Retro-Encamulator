package haxewell.matrix;

/**
 * @author Kaelan
 * 
 * Register class is to ensure registers behave correctly without having to constantly rewrite bitwise operators and ensure their under/overflow behavior works from the get go
 * Register values are also values, allowing any other module in the emulator to access them without ugly and hacky public/public variables elsewhere that's not needed
 * 
 */

class Register 
{
	public var A(default, set):Int;
	public var B(default, set):Int;
	public var C(default, set):Int;
	public var D(default, set):Int;
	public var E(default, set):Int;
	public var F(default, set):Int;
	public var H(default, set):Int;
	public var L(default, set):Int;
	public var SP(default, set):Int;
	public var PC(default, set):Int;
	
	public var AF(get, set):Int;
	public var BC(get, set):Int;
	public var DE(get, set):Int;
	public var HL(get, set):Int;
	
	public function new() {
		A = 0;
		B = 0;
		C = 0;
		D = 0;
		E = 0;
		F = 0;
		H = 0;
		L = 0;
		SP = 0;
		PC = 0;
	}
	//////
	//Single registers
	/////
	function set_A(_byte:Int) {
		A = _byte;
		A &= 0xFF;
		return A;
	}
	function set_B(_byte:Int) {
		B = _byte;
		B &= 0xFF;
		return B;
	}
	function set_C(_byte:Int) {
		C = _byte;
		C &= 0xFF;
		return C;
	}
	function set_D(_byte:Int) {
		D = _byte;
		D &= 0xFF;
		return D;
	}
	function set_E(_byte:Int) {
		E = _byte;
		E &= 0xFF;
		return E;
	}
	function set_F(_byte:Int) {
		F = _byte;
		F &= 0xFF;
		return F;
	}
	function set_H(_byte:Int) {
		H = _byte;
		H &= 0xFF;
		return H;
	}
	function set_L(_byte:Int) {
		L = _byte;
		L &= 0xFF;
		return L;
	}
	function set_SP(_v:Int) {
		SP = _v;
		SP &= 0xFFFF;
		return SP;
	}
	function set_PC(_v:Int) {
		PC = _v;
		PC &= 0xFFFF;
		return PC;
	}
	//////
	//Register Pairs
	/////
	function get_AF():Int {
		return (A << 8) + F;
	}
	function set_AF(_word:Int):Int {
		A = (_word >> 8) & 0xFF;
		F = _word & 0xFF;
		return AF;
	}
	function get_BC():Int {
		return (B << 8) + C;
	}
	function set_BC(_word:Int):Int {
		B = (_word >> 8) & 0xFF;
		C = _word & 0xFF;
		return BC;
	}
	function get_DE():Int {
		return (D << 8) + E;
	}
	function set_DE(_word:Int):Int {
		D = (_word >> 8) & 0xFF;
		E = _word & 0xFF;
		return DE;
	}
	function get_HL():Int {
		return (H << 8) + L;
	}
	function set_HL(_word:Int):Int {
		H = (_word >> 8) & 0xFF;
		L = _word & 0xFF;
		return AF;
	}
	public function toString(_asHex:Bool = false):String {
		if (_asHex) {
			return("A: " + StringTools.hex(A, 2) + "," + "B: " + StringTools.hex(B, 2) + "," + "C: " + StringTools.hex(C, 2) + "," + "D: " + StringTools.hex(D, 2) + "," + "E: " + StringTools.hex(E, 2) + "," + "F: " + StringTools.hex(F, 2) + "," + "H: " + StringTools.hex(H, 2) + "," + "L: " + StringTools.hex(L, 2));
		} else {
			return("A: " + A + "," + "B: " + B + "," + "C: " + C + "," + "D: " + D + "," + "E: " + E + "," + "F: " + F + "," + "H: " + H + "," + "L: " + L);
		}
	}
	public function reset() {
		A = 0;
		B = 0;
		C = 0;
		D = 0;
		E = 0;
		F = 0;
		H = 0;
		L = 0;
		SP = 0;
		PC = 0;
	}
}