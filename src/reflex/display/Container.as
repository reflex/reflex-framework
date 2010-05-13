package reflex.display
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flight.binding.Bind;
	import flight.events.ListEvent;
	import flight.events.ListEventKind;
	import flight.events.PropertyEvent;
	import flight.list.ArrayList;
	import flight.list.IList;
	
	import reflex.events.InvalidationEvent;
	import reflex.graphics.IDrawable;
	import reflex.layout.Block;
	import reflex.layout.Bounds;
	import reflex.layout.Box;
	import reflex.layout.LayoutWrapper;
	import reflex.layouts.ILayout;
	import reflex.measurement.resolveHeight;
	import reflex.measurement.resolveWidth;
	
	[Event(name="initialize", type="reflex.events.InvalidationEvent")]
	
	[DefaultProperty("children")]
	
	/**
	 * @alpha
	 */
	public class Container extends ReflexDisplay implements IContainer
	{
		
		static public const CREATE:String = "create";
		static public const INITIALIZE:String = "initialize";
		static public const MEASURE:String = "measure";
		static public const LAYOUT:String = "layout";
		
		InvalidationEvent.registerPhase(CREATE, 0, true);
		InvalidationEvent.registerPhase(INITIALIZE, 1, true);
		InvalidationEvent.registerPhase(MEASURE, 2, true);
		InvalidationEvent.registerPhase(LAYOUT, 3, true);
		
		private var _layout:ILayout;
		private var _template:Object = new ReflexDataTemplate();
		private var _children:IList;
		private var renderers:Array;
		
		public function Container()
		{
			addEventListener(Event.ADDED, onAdded, false, 0, true);
			addEventListener(MEASURE, onMeasure, false, 0, true);
			addEventListener(LAYOUT, onLayout, false, 0, true);
		}
		
		[ArrayElementType("Object")]
		public function get children():IList { return _children; }
		public function set children(value:*):void
		{
			if(_children == value) {
				return;
			}
			
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
		}
		
		[Bindable(event="layoutChange")]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void {
			if(_layout) { _layout.target = null; }
			_layout = value;
			if(_layout) { _layout.target = this; }
			InvalidationEvent.invalidate(this, MEASURE);
			InvalidationEvent.invalidate(this, LAYOUT);
		}
		
		[Bindable]
		public function get template():Object { return _template; }
		public function set template(value:Object):void {
			_template = value;
		}
		
		private function onAdded(event:Event):void {
			removeEventListener(Event.ADDED, onAdded, false);
			InvalidationEvent.invalidate(this, CREATE);
			InvalidationEvent.invalidate(this, INITIALIZE);
		}
		
		private function onMeasure(event:InvalidationEvent):void {
			if(isNaN(measurements.expliciteWidth) || isNaN(measurements.expliciteHeight)) {
				var point:Point = layout.measure(renderers);
				measurements.measuredWidth = point.x;
				measurements.measuredHeight = point.y;
				InvalidationEvent.invalidate(this, LAYOUT);
			}
		}
		
		private function onLayout(event:InvalidationEvent):void {
			if(layout) {
				var width:Number = reflex.measurement.resolveWidth(this);
				var height:Number = reflex.measurement.resolveHeight(this);
				var rectangle:Rectangle = new Rectangle(0, 0, width, height);
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
					reset(event.items);
					break;
			}
			InvalidationEvent.invalidate(this, LAYOUT);
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
			InvalidationEvent.invalidate(this, LAYOUT);
		}
		
		
	}
}