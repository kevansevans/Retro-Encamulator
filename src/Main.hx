package;

import gb.CPU_GB;

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
class Main 
{
	static var gameboy:CPU_GB;
	static var rom_path:Null<String>;
	static var TAS_Mode:Bool = false;
	static function main() 
	{
		#if sys
		Sys.println("Haxewell Retro Encamulator");
		Sys.println("Alpha version. Not recommended for use.");
		Sys.println("HRE is only for backend emulation. Users are encouraged to create their own renderer to utilize the HRE cores.");
		Sys.println("HRE is built on Haxe, so wherever Haxe can deploy, so can HRE.");
		read_command();
		#end
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
				if (rom_path == null) {
					Sys.println("ROM Not set");
					read_command();
				} else {
					launch_emulator();
				}
			case Argument.TEST :
				Sys.println("Launching test rom...");
				test_mode();
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
	
	static function launch_emulator() 
	{
		gameboy = new CPU_GB();
		gameboy._meminter.load(File.getContent(rom_path));
		if (!TAS_Mode) {
			gameboy.run();
		} else {
			step_mode();
		}
	}
	static function test_mode() {
		gameboy = new CPU_GB();
		Sys.println("testing op codes...");
		Sys.sleep(5);
		for (a in 0...256) {
			gameboy.step(a);
			Sys.sleep(0.125);
		}
		Sys.println("End Result should be: ");
		Sys.println("Testing bios in 10 seconds...");
		Sys.sleep(10);
		gameboy.reset();
		Sys.println("testing bios...");
		for (a in gameboy._meminter._bios) {
			gameboy.step(a);
			Sys.sleep(0.125);
		}
		Sys.println("End Result should be: ");
		Sys.println("Loading test roms in 10 seconds...");
		Sys.sleep(10);
		read_command();
	}
	static function step_mode() 
	{
		while (true) {
			//Sys.stdin().readAll
		}
	}
}