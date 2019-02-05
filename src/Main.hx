package;

import haxewell.matrix.Matrix;
import haxewell.matrix.Keys;
import haxewell.matrix.Register;

import sys.io.File;

/**
 * ...
 * @author Kaelan
 */
enum abstract Argument(String) from String {
	var RUN:String;
	var TEST:String;
	var SET:String;
	var HELP:String;
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
		#if debug 
		Sys.println("This version was compiled under the Debug flag. Performance will not be optimal."); 
		#end
		#end
		if (_launch[0] == null) {
			read_command();
		} else {
			var gb:Int = _launch[0].lastIndexOf(".gb");
			
			if (gb != -1) {
				core = new Matrix(File.getContent(_launch[0]));
			} else {
				Sys.println(_launch[0] + " Is and unrecognized rom type");
				read_command();
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
					//Sys.println("Core not set");
					//read_command();
					core = new Matrix(File.getContent(rom_path));
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
			case Argument.HELP: 
				Sys.print("To use HRE, close this application. Then drag supported ROM of choice onto executable.");
				Sys.print("Supported roms are as follows: Gameboy");
				Sys.print("List of commands: ");
				Sys.print(" Core - Force core loading regardless of rom detected");
				Sys.print(" Load - load ROM within program directory");
				Sys.print(" Help [device] - List commands associated with device");
			default :
				Sys.println("Unknown command");
				read_command();
		}
	}
}