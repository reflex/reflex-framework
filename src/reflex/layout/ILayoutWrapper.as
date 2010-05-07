package reflex.layout
{
	import flash.display.DisplayObject;

	public interface ILayoutWrapper
	{
		function get target():DisplayObject;
		function set target(value:DisplayObject):void;
		
		function get algorithm():ILayoutAlgorithm;
		function set algorithm(value:ILayoutAlgorithm):void;
		
		function get freeform():Boolean;				// if false, constrain using ILayout algorithm,
		function set freeform(value:Boolean):void;		// otherwise allow to do its own thing
		
		function get shift():Number;
		function set shift(value:Number):void;
		
		function get shiftSize():Number;
		function set shiftSize(value:Number):void;
		
		function invalidate(measure:Boolean = false):void;
		
		function validate():void;
		function measure():void;
		function layout():void;
	}
}