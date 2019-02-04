package haxewell.matrix;

/**
 * ...
 * @author Kaelan
 * 
 * Matrix core: Gameboy Emulator
 * 
 */
class Matrix
{
	public static var processor:CPU;
	public static var memory:Memory;
	public static var graphics:GPU;
	public static var sound:Sound;
	public function new(_rom:String) 
	{
		processor = new CPU();
		memory = new Memory();
		memory.load(_rom);
		graphics = new GPU();
		sound = new Sound();
		processor.run();
	}
}