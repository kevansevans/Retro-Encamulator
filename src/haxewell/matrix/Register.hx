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
	public function set_A(_byte:Int) {
		A = _byte;
		A &= 0xFF;
		return A;
	}
	public function set_B(_byte:Int) {
		B = _byte;
		B &= 0xFF;
		return B;
	}
	public function set_C(_byte:Int) {
		C = _byte;
		C &= 0xFF;
		return C;
	}
	public function set_D(_byte:Int) {
		D = _byte;
		D &= 0xFF;
		return D;
	}
	public function set_E(_byte:Int) {
		E = _byte;
		E &= 0xFF;
		return E;
	}
	public function set_F(_byte:Int) {
		F = _byte;
		F &= 0xFF;
		return F;
	}
	public function set_H(_byte:Int) {
		H = _byte;
		H &= 0xFF;
		return H;
	}
	public function set_L(_byte:Int) {
		L = _byte;
		L &= 0xFF;
		return L;
	}
	public function set_SP(_v:Int) {
		SP = _v;
		SP &= 0xFFFF;
		return SP;
	}
	public function set_PC(_v:Int) {
		PC = _v;
		PC &= 0xFFFF;
		return PC;
	}
	//////
	//Register Pairs
	/////
	public function get_AF():Int {
		return (A << 8) + F;
	}
	public function set_AF(_word:Int):Int {
		A = (_word >> 8) & 0xFF;
		F = _word & 0xFF;
		return AF;
	}
	public function get_BC():Int {
		return (B << 8) + C;
	}
	public function set_BC(_word:Int):Int {
		B = (_word >> 8) & 0xFF;
		C = _word & 0xFF;
		return BC;
	}
	public function get_DE():Int {
		return (D << 8) + E;
	}
	public function set_DE(_word:Int):Int {
		D = (_word >> 8) & 0xFF;
		E = _word & 0xFF;
		return DE;
	}
	public function get_HL():Int {
		return (H << 8) + L;
	}
	public function set_HL(_word:Int):Int {
		H = (_word >> 8) & 0xFF;
		L = _word & 0xFF;
		return AF;
	}
	public function toString():String {
		return("A: " + A + "," + "B: " + B + "," + "C: " + C + "," + "D: " + D + "," + "E: " + E + "," + "F: " + F + "," + "H: " + H + "," + "L: " + L);
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