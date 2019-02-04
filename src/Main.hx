package;

import haxewell.matrix.Matrix;

import sys.io.File;

/**
 * ...
 * @author Kaelan
 */
enum abstract Argument(String) from String {
	var RUN:String;
	var TEST:String;
	var SET:String;
}
enum abstract Mode(Int) from Int {
	var Gameboy:Int;
}
class Main 
{
	static var core:Null<Any> = null;
	static var rom_path:Null<String>;
	static var TAS_Mode:Bool = false;
	static var _launch = Sys.args();
	static function main() 
	{
		#if sys
		Sys.println("Haxewell Retro Encamulator");
		Sys.println("Alpha version. Not recommended for use.");
		Sys.println("HRE is only for backend emulation. Users are encouraged to create their own renderer to utilize the HRE cores.");
		Sys.println("HRE is built on Haxe, so wherever Haxe can deploy, so can HRE.");
		#end
		
		if (_launch[0] == null) {
			read_command();
		} else {
			var gb:Int = _launch[0].lastIndexOf(".gb");
			
			if (gb != -1) {
				core = new Matrix(File.getContent(_launch[0]));
			}
		}
	}
	static function read_command() {
		while (true) {
			Sys.print("HRE: > ");
			var cmd = Sys.stdin().readLine();
			process(cmd);
			break;
		}
	}
	
	static function process(_command:String) 
	{
		switch (_command.toUpperCase()) {
			case Argument.RUN :
				if (core == null) {
					Sys.println("Core not set");
					read_command();
				} else {
					
				}
			case Argument.TEST :
				read_command();
			case Argument.SET :
				while (true) {
					Sys.print("Path to Rom: > ");
					rom_path = Sys.stdin().readLine();
					Sys.println("Rom set to: " + rom_path);
					break;
				}
				read_command();
			default :
				Sys.println("Unknown command");
				read_command();
		}
	}
}