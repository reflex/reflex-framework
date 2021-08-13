package mx.states
{
	import flash.display.DisplayObject;

	public class SetProperty extends OverrideBase implements IOverride
	{ 
		
		public var name:String;
		public var target:String;
		public var value:*;
		
		public var isBaseValueDataBound:Boolean;
		
		private var oldValue:*;
		
		override public function initialize():void {
			trace("init");
		}
		
		override public function apply(parent:Object):void {
			if(parent == null || target == null) { return; }
			var item:Object = parent[target];
			if(item == null) { return; }
			oldValue = item[name];
			item[name] = value;
		}
		
		override public function remove(parent:Object):void {
			if(parent == null || target == null) { return; }
			var item:Object = parent[target];
			if(item == null) { return; }
			item[name] = oldValue;
			oldValue = null;
		}
		
	}
}