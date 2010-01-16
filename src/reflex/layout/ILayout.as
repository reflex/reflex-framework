package reflex.layout
{
	import flash.display.DisplayObject;

	public interface ILayout
	{
		function get target():DisplayObject;
		function set target(value:DisplayObject):void;
		
		function get algorithm():ILayoutAlgorithm;
		function set algorithm(value:ILayoutAlgorithm):void;
		
		function get freeform():Boolean;				// if false, constrain using ILayout algorithm,
		function set freeform(value:Boolean):void;		// otherwise allow to do its own thing
		
		function invalidate(measure:Boolean = false):void;
		
		function validate():void;
		function measure():void;
		function layout():void;
	}
}