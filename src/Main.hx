package;

import haxewell.EmuCore;
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
	var HELP:String;
}
enum abstract Mode(Int) from Int {
	var Gameboy:Int;
}
class Main 
{
	static var core:EmuCore = null;
	static var rom_path:Null<String>;
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
			get_rom_type(_launch[0]);
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
	static function get_rom_type(_rom:String) {
		var ext_2 = _rom.substr(_rom.length - 3, _rom.length);
		var ext_3 = _rom.substr(_rom.length - 4, _rom.length);
		var detected = false;
		if (ext_2 == ".gb") {
			core = new Matrix(File.getContent(_rom));
			Sys.println("Rom set to: " + rom_path);
			Sys.println(_rom + " Is detected as a Gameboy ROM, Matrix core has been loaded");
			Sys.println("Use command 'RUN' to start EMU"); 
			detected = true;
			read_command();
		}
		if (ext_3 == ".gbc") {
			core = new Matrix(File.getContent(_rom));
			Sys.println("Rom set to: " + rom_path);
			Sys.println(_rom + " Is detected as a Gameboy Color ROM, Matrix core has been loaded");
			Sys.println("Use command 'RUN' to start EMU");
			detected = true;
			read_command();
		} 
		if (!detected) {
			Sys.println(_rom + " Is and unrecognized rom type");
			Sys.println("Use command 'SET' to try setting ROM again");
		}
		read_command();
	}
	static function process(_command:String) 
	{
		switch (_command.toUpperCase()) {
			case Argument.RUN :
				if (core != null) {
					core.start();
				} else {
					Sys.println("Core not set");
					read_command();
				}
			case Argument.TEST :
				read_command();
			case Argument.SET :
				while (true) {
					Sys.print("Path to Rom: > ");
					rom_path = Sys.stdin().readLine();
					break;
				}
				get_rom_type(rom_path);
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