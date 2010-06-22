package reflex.components
{
	import mx.core.IDataRenderer;
	
	import reflex.behaviors.ButtonBehavior;
	
	/**
	 * @alpha
	 */
	public class ListItem extends Button implements IDataRenderer
	{
		
		private var _data:Object;
		/*
		[Bindable]
		public var label:String;
		
		[Bindable]
		public var selected:Boolean;
		*/
		[Bindable]
		public function get data():Object { return _data; }
		public function set data(value:Object):void
		{
			_data = value;		
		}
		
		public function ListItem()
		{
			super();
			//behaviors = new ButtonBehavior();
			//skin = new ButtonGraphic();
		}
	}
}