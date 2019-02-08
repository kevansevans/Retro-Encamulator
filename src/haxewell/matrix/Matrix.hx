package haxewell.matrix;
import haxewell.EmuCore;

/**
 * ...
 * @author Kaelan
 * 
 * Matrix core: Gameboy Emulator
 * 
 */
class Matrix extends EmuCore
{
	public static var processor:CPU;
	public static var memory:Memory;
	public static var graphics:GPU;
	public static var sound:Sound;
	public static var register:Register;
	public function new(_rom:String) 
	{
		super();
		register = new Register();
		memory = new Memory();
		memory.load(_rom);
		graphics = new GPU();
		sound = new Sound();
		
		processor = new CPU(register, memory);
	}
	override public function start() {
		processor.run();
	}
}