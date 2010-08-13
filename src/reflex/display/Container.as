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
	import reflex.layouts.ILayout;
	import reflex.layouts.XYLayout;
	import reflex.measurement.resolveHeight;
	import reflex.measurement.resolveWidth;
	
	[Style(name="left")]
	[Style(name="right")]
	[Style(name="top")]
	[Style(name="bottom")]
	[Style(name="horizontalCenter")]
	[Style(name="verticalCenter")]
	[Style(name="dock")]
	[Style(name="align")]
	
	[Event(name="initialize", type="reflex.events.InvalidationEvent")]
	
	[DefaultProperty("children")]
	
	/**
	 * Used to contain and layout children.
	 * 
	 * @alpha
	 */
	public class Container extends MeasuredSprite implements IContainer
	{
		
		static public const CREATE:String = "create";
		static public const INITIALIZE:String = "initialize";
		static public const MEASURE:String = "measure";
		static public const LAYOUT:String = "layout";
		
		InvalidationEvent.registerPhase(CREATE, 0, true);
		InvalidationEvent.registerPhase(INITIALIZE, 1, true);
		InvalidationEvent.registerPhase(MEASURE, 2, true);
		InvalidationEvent.registerPhase(LAYOUT, 3, false);
		
		private var _layout:ILayout;
		private var _template:Object;
		private var _children:IList;
		public var renderers:Array;
		private var _style:Object;
		
		public function Container()
		{
			if(_template == null) {
				_template = new ReflexDataTemplate();
			}
			if(_layout == null) {
				//_layout = new XYLayout();
			}
			_style = new Object();
			addEventListener(Event.ADDED, onAdded, false, 0, true);
			addEventListener(MEASURE, onMeasure, false, 0, true);
			addEventListener(LAYOUT, onLayout, false, 0, true);
			addEventListener("widthChange", onSizeChange, false, 0, true);
			addEventListener("heightChange", onSizeChange, false, 0, true);
		}
		
		// width/height invalidation needs some thought
		
		private function onSizeChange(event:Event):void {
			InvalidationEvent.invalidate(this, LAYOUT);
		}
		/*
		override public function set width(value:Number):void {
			if(value != width) {
				super.width = value;
				InvalidationEvent.invalidate(this, LAYOUT);
			}
		}
		
		override public function set height(value:Number):void {
			if(value != height) {
				super.height = value;
				InvalidationEvent.invalidate(this, LAYOUT);
			}
		}
		
		override public function set actualWidth(value:Number):void {
			if(value != width) {
				super.actualWidth = value;
				InvalidationEvent.invalidate(this, LAYOUT);
			}
		}
		
		override public function set actualHeight(value:Number):void {
			if(value != height) {
				super.actualHeight = value;
				InvalidationEvent.invalidate(this, LAYOUT);
			}
		}
		
		override public function setSize(width:Number, height:Number):void {
			if(width != this.width || height != this.height) {
				super.setSize(width, height);
				InvalidationEvent.invalidate(this, LAYOUT);
			}
		}
		*/
		[Bindable] 
		public function get style():Object { return _style; }
		public function set style(value:*):void {
			if(value is String) {
				var token:String = value as String;
				var assignments:Array = token.split(";");
				for each(var assignment:String in assignments) {
					var split:Array = assignment.split(":");
					var property:String = split[0];
					var v:String = split[1];
					_style[property] = v;
				}
			}
		}
		
		public function setStyle(property:String, value:*):void {
			style[property] = value;
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
			dispatchEvent( new Event("childrenChange") );
			InvalidationEvent.invalidate(this, MEASURE);
			InvalidationEvent.invalidate(this, LAYOUT);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="layoutChange")]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void {
			if(_layout) { _layout.target = null; }
			_layout = value;
			if(_layout) { _layout.target = this; }
			InvalidationEvent.invalidate(this, MEASURE);
			InvalidationEvent.invalidate(this, LAYOUT);
			dispatchEvent( new Event("layoutChange") );
		}
		
		[Bindable(event="templateChange")]
		public function get template():Object { return _template; }
		public function set template(value:Object):void {
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
			dispatchEvent( new Event("templateChange") );
			InvalidationEvent.invalidate(this, MEASURE);
			InvalidationEvent.invalidate(this, LAYOUT);
		}
		
		private function onAdded(event:Event):void {
			removeEventListener(Event.ADDED, onAdded, false);
			InvalidationEvent.invalidate(this, CREATE);
			InvalidationEvent.invalidate(this, INITIALIZE);
		}
		
		private function onMeasure(event:InvalidationEvent):void {
			if((isNaN(explicite.width) || isNaN(explicite.height)) && layout) {
				var point:Point = layout.measure(renderers);
				measured.width = point.x;
				measured.height = point.y;
			}
		}
		
		private function onLayout(event:InvalidationEvent):void {
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