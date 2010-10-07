package mx.states
{
	import flash.display.DisplayObject;

	public class SetStyle extends OverrideBase implements IOverride
	{ 
		
		public var name:String;
		public var target:String;
		public var value:*;
		
		private var oldValue:*;
		
		public function initialize():void {
			//trace("init");
		}
		
		public function apply(parent:DisplayObject):void {
			oldValue = parent[target].getStyle(name);
			parent[target].setStyle(name, value);
		}
		
		public function remove(parent:DisplayObject):void {
			parent[target].setStyle(name, oldValue);
			oldValue = null;
		}
		
	}
}