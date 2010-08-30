package reflex.display
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flight.events.ListEvent;
	import flight.events.ListEventKind;
	import flight.list.ArrayList;
	import flight.list.IList;
	
	import reflex.events.RenderPhase;
	import reflex.layouts.ILayout;
	
	[Style(name="left")]
	[Style(name="right")]
	[Style(name="top")]
	[Style(name="bottom")]
	[Style(name="horizontalCenter")]
	[Style(name="verticalCenter")]
	[Style(name="dock")]
	[Style(name="align")]
	
	[Event(name="initialize", type="reflex.events.RenderPhase")]
	
	[DefaultProperty("children")]
	
	/**
	 * Used to contain and layout children.
	 * 
	 * @alpha
	 */
	public class Container extends StyleableSprite implements IContainer
	{
		
		static public const CREATE:String = "create";
		static public const INITIALIZE:String = "initialize";
		static public const MEASURE:String = "measure";
		static public const LAYOUT:String = "layout";
		
		RenderPhase.registerPhase(CREATE, 0, true);
		RenderPhase.registerPhase(INITIALIZE, 1, true);
		RenderPhase.registerPhase(MEASURE, 2, true);
		RenderPhase.registerPhase(LAYOUT, 3, false);
		
		private var _layout:ILayout;
		private var _template:Object;
		private var _children:IList;
		public var renderers:Array;
		
		
		public function Container()
		{
			if(_template == null) {
				//_template = new ReflexDataTemplate();
			}
			if(_layout == null) {
				//_layout = new XYLayout();
			}
			
			addEventListener(Event.ADDED, onAdded, false, 0, true);
			addEventListener(MEASURE, onMeasure, false, 0, true);
			addEventListener(LAYOUT, onLayout, false, 0, true);
			//addEventListener("widthChange", onSizeChange, false, 0, true);
			//addEventListener("heightChange", onSizeChange, false, 0, true);
		}
		
		// width/height invalidation needs some thought
		
		private function onSizeChange(event:Event):void {
			RenderPhase.invalidate(this, LAYOUT);
		}
		
		
		/**
		 * @inheritDoc
		 */
		[ArrayElementType("Object")]
		[Bindable(event="childrenChange")]
		public function get children():IList { return _children; }
		public function set children(value:*):void
		{
			if(_children == value) {
				return;
			}
			
			var oldChildren:IList = _children;
			
			if(_children) {
				_children.removeEventListener(ListEvent.LIST_CHANGE, onChildrenChange);
			}
			
			if(value == null) {
				_children = null;
			} else if(value is IList) {
				_children = value as IList;
			} else if(value is Array || value is Vector) {
				_children = new ArrayList(value);
			} else {
				_children = new ArrayList([value]);
			}
			
			if(_children) {
				_children.addEventListener(ListEvent.LIST_CHANGE, onChildrenChange);
				var items:Array = [];
				for (var i:int = 0; i < _children.length; i++) {
					items.push(_children.getItemAt(i));
				}
				reset(items);
			}
			RenderPhase.invalidate(this, MEASURE);
			RenderPhase.invalidate(this, LAYOUT);
			dispatchEvent( new Event("childrenChange") );
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="layoutChange")]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void {
			if(_layout == value) {
				return;
			}
			var oldLayout:ILayout = _layout;
			if(_layout) { _layout.target = null; }
			_layout = value;
			if(_layout) { _layout.target = this; }
			RenderPhase.invalidate(this, MEASURE);
			RenderPhase.invalidate(this, LAYOUT);
			dispatchEvent( new Event("layoutChange") );
		}
		
		[Bindable(event="templateChange")]
		public function get template():Object { return _template; }
		public function set template(value:Object):void {
			if(_template == value) {
				return;
			}
			var oldTemplate:Object = _template;
			_template = value;
			if(children != null) {
				var items:Array = [];
				var length:int = children.length;
				for(var i:int = 0; i < length; i++) {
					var child:Object = children.getItemAt(i);
					items.push(child);
				}
				reset(items);
			}
			RenderPhase.invalidate(this, MEASURE);
			RenderPhase.invalidate(this, LAYOUT);
			dispatchEvent( new Event("templateChange") );
		}
		
		private function onAdded(event:Event):void {
			removeEventListener(Event.ADDED, onAdded, false);
			RenderPhase.invalidate(this, CREATE);
			RenderPhase.invalidate(this, INITIALIZE);
		}
		
		private function onMeasure(event:Event):void {
			if((isNaN(explicite.width) || isNaN(explicite.height)) && layout) {
				var point:Point = layout.measure(renderers);
				measured.width = point.x;
				measured.height = point.y;
			}
		}
		
		private function onLayout(event:Event):void {
			if(layout) {
				//var width:Number = reflex.measurement.resolveWidth(this);
				//var height:Number = reflex.measurement.resolveHeight(this);
				var rectangle:Rectangle = new Rectangle(0, 0, unscaledWidth, unscaledHeight);
				layout.update(renderers, rectangle);
			}
		}
		
		private function onChildrenChange(event:ListEvent):void
		{
			var child:DisplayObject;
			var loc:int = event.location1;
			switch (event.kind) {
				case ListEventKind.ADD :
					add(event.items, loc);
					break;
				case ListEventKind.REMOVE :
					for each (child in event.items) {
						removeChild(child);
					}
					break;
				case ListEventKind.REPLACE :
					removeChild(event.items[1]);
					//addChildAt(event.items[0], loc);
					break;
				case ListEventKind.RESET :
				default:
					reset(event.items);
					break;
			}
			RenderPhase.invalidate(this, LAYOUT);
		}
		
		private function add(items:Array, index:int):void {
			var children:Array = reflex.display.addItemsAt(this, items, index, _template);
			renderers.concat(children); // todo: correct ordering
		}
		
		private function reset(items:Array):void {
			while (numChildren) {
				removeChildAt(numChildren-1);
			}
			renderers = reflex.display.addItemsAt(this, items, 0, _template); // todo: correct ordering
			RenderPhase.invalidate(this, LAYOUT);
		}
		
		
	}
}