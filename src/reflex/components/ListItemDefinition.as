package reflex.components
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	
	import reflex.binding.DataChange;
	import reflex.skins.ISkin;

	public class ListItemDefinition extends ButtonDefinition implements IDataRenderer, IFactory
	{
		
		private var _data:Object;
		
		[Bindable(event="dataChange")]
		public function get data():Object { return _data; }
		public function set data(value:Object):void {
			DataChange.change(this, "data", _data, _data = value);
		}
		
		public function newInstance():* {
			var n:String = flash.utils.getQualifiedClassName(this);
			var C:Class = flash.utils.getDefinitionByName(n) as Class;
			var instance:ListItemDefinition = new C();
			
			var sn:String = flash.utils.getQualifiedClassName(skin);
			var sC:Class = flash.utils.getDefinitionByName(sn) as Class;
			instance.skin = new sC() as ISkin;
			return instance;
		}
		
	}
}