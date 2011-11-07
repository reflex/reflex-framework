package reflex.components
{
	
	import flash.events.Event;
	
	import mx.collections.IList;
	
	import reflex.behaviors.ScrollerBehavior;
	import reflex.binding.Bind;
	import reflex.binding.DataChange;
	import reflex.collections.SimpleCollection;
	import reflex.collections.convertToIList;
	import reflex.containers.IContainer;
	import reflex.data.IPosition;
	import reflex.data.IRange;
	import reflex.data.Position;
	import reflex.layouts.BasicLayout;
	import reflex.layouts.ILayout;
	import reflex.skins.ScrollerSkin;
	
	[DefaultProperty("content")]
	public class Scroller extends Component implements IContainer
	{
		
		
		private var _horizontal:IPosition;
		private var _vertical:IPosition;
		private var _content:IList;
		private var _layout:ILayout;
		
		[Bindable(event="horizontalPositionChange")]
		public function get horizontalPosition():IPosition { return _horizontal; }
		public function set horizontalPosition(value:IPosition):void {
			DataChange.change(this, "horizontalPosition", _horizontal, _horizontal = value);
		}
		
		[Bindable(event="verticalPositionChange")]
		public function get verticalPosition():IPosition { return _vertical; }
		public function set verticalPosition(value:IPosition):void {
			DataChange.change(this, "verticalPosition", _vertical, _vertical = value);
		}
		
		[Bindable(event="contentChange")]
		public function get content():IList{
			return _content;
		}
		public function set content(value:*):void {
			if(_content == value) {
				return;
			}
			
			var oldContent:IList = _content;
			
			_content = reflex.collections.convertToIList(value);
			
			DataChange.change(this, "content", oldContent,  _content);
		}
		
		[Bindable(event="layoutChange")]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void {
			DataChange.change(this, "layout", _layout, _layout = value);
		}
		
		public function Scroller()
		{
			super();
			initialize();
		}
		
		private function initialize():void {
			_content = new SimpleCollection();
			horizontalPosition = new Position();
			verticalPosition = new Position();
			layout = new BasicLayout();
			skin = new ScrollerSkin();
			//this.addEventListener("measure", item_measureHandler, false);
			
			Bind.addBinding(this, "skin.container.content", this, "content");
			Bind.addBinding(this, "skin.container.layout", this, "layout");
			
			//Bind.addBinding(this, "skin.container.mask", this, "skin.mask");
			behaviors.addItem(new ScrollerBehavior(this));
		}
		
		// temporary?
		/*
		private function item_measureHandler(event:Event):void {
			//var child:IEventDispatcher = event.currentTarget;
			//Invalidation.invalidate(this, MEASURE);
			trace("Scroller measure");
		}
		*/
	}
}