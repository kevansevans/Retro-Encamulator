package haxewell.matrix;

/**
 * ...
 * @author Kaelan
 */
enum abstract Bank(Int) from Int {
	var rom:Int;
	var ram:Int;
	var ramon:Int;
	var mode:Int;
}
enum abstract Register(Int) from Int {
	var a:Int;
	var b:Int;
	var c:Int;
	var d:Int;
	var e:Int;
	var f:Int;
	var h:Int;
	var l:Int;
	var pc:Int;
	var sp:Int;
	var t:Int;
	var m:Int;
	var i:Int;
	var r:Int;
	var ime:Int;
}