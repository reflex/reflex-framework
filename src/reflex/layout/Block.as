package reflex.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import flight.events.PropertyEvent;
	
	import reflex.events.RenderEvent;
	
	public class Block extends EventDispatcher
	{
		public static const MEASURE:String = "measure";
		public static const LAYOUT:String = "layout";
		
		public static var blockIndex:Dictionary = new Dictionary(true);
		
		private static var measurePhase:Boolean = RenderEvent.registerPhase(MEASURE, 0x80, false);
		private static var layoutPhase:Boolean = RenderEvent.registerPhase(LAYOUT, 0x40, true);
		
		[Bindable]
		public var scale:Boolean = false;
		
		[Bindable]
		public var freeform:Boolean = false;
		
		[Bindable]
		public var layout:ILayout;
		
		[Bindable]
		public var bounds:Bounds = new Bounds();
		
		// holds explicitly set value from setting width/height
		protected var explicitWidth:Number;
		protected var explicitHeight:Number;
		
		protected var defaultWidth:Number = 0;
		protected var defaultHeight:Number = 0;
		
		private var validating:Boolean = false;
		
		private var _targetIndex:Dictionary = new Dictionary(true);
		private var _width:Number = defaultWidth;
		private var _height:Number = defaultHeight;
		private var _measuredWidth:Number = 0;
		private var _measuredHeight:Number = 0;
		private var _measuredBounds:Bounds = bounds;
		
		private var _margin:Box = new Box();
		private var _padding:Box = new Box();
		private var _dock:String = Dock.NONE;
		private var _tile:String = Dock.NONE;
		
		
		public function Block(target:DisplayObject = null, scale:Boolean = false)
		{
			this.scale = scale;
			this.target = target;
			_margin.addEventListener(PropertyEvent.PROPERTY_CHANGE, onObjectChange);
			_padding.addEventListener(PropertyEvent.PROPERTY_CHANGE, onObjectChange);
			layout = new Dock();
		}
		
		[Bindable(event="targetChange")]
		public function get target():DisplayObject
		{
			for (var i:* in _targetIndex) {
				return i;
			}
			return null;
		}
		public function set target(value:DisplayObject):void
		{
			var oldValue:DisplayObject = target;
			if (oldValue == value) {
				return;
			}
			
			if (oldValue != null) {
				delete blockIndex[oldValue];
				delete _targetIndex[oldValue];
				oldValue.removeEventListener(MEASURE, onMeasure);
				oldValue.removeEventListener(LAYOUT, onLayout);
			}
			
			if (value != null) {
				
				if (blockIndex[value] != null) {
					blockIndex[value].target = null;
				}
				blockIndex[value] = this;
				_targetIndex[value] = true;
				value.addEventListener(MEASURE, onMeasure, false, 0xF, true);
				value.addEventListener(LAYOUT, onLayout, false, 0xF, true);
				
				defaultWidth = value.width;
				defaultHeight = value.height;
				updateWidth();
				updateHeight();
				invalidateSize();
				invalidate();
			}
			
			dispatchEvent( new Event("targetChange") );
		}
		
		[Bindable(event="widthChange")]
		public function get width():Number
		{
			return _width;
		}
		public function set width(value:Number):void
		{
			if (explicitWidth == value) {
				return;
			}
			
			explicitWidth = value;
			updateWidth();
		}
		
		[Bindable(event="heightChange")]
		public function get height():Number
		{
			return _height;
		}
		public function set height(value:Number):void
		{
			if (explicitHeight == value) {
				return;
			}
			
			explicitHeight = value;
			updateHeight();
		}
		
		[Bindable("measuredWidthChange")]
		public function get measuredWidth():Number
		{
			return _measuredWidth;
		}
		
		[Bindable("measuredHeightChange")]
		public function get measuredHeight():Number
		{
			return _measuredHeight;
		}
		
		[Bindable("measuredBoundsChange")]
		public function get measuredBounds():Bounds
		{
			return _measuredBounds;
		}
		
		
		[Bindable(event="marginChange")]
		public function get margin():Box
		{
			return _margin;
		}
		public function set margin(value:*):void
		{
			var margin:Box = (value is String || value is Number) ? Box.fromString( String(value) ) : value as Box;
			if (margin == null) {
				margin = new Box();
			}
			if (_margin.equals(margin)) {
				return;
			}
			
			_margin.left = margin.left;
			_margin.top = margin.top;
			_margin.right = margin.right;
			_margin.bottom = margin.bottom;
			dispatchEvent(new Event("marginChange"));
		}
		
		[Bindable(event="paddingChange")]
		public function get padding():Box
		{
			return _padding;
		}
		public function set padding(value:*):void
		{
			var padding:Box = (value is String || value is Number) ? Box.fromString( String(value) ) : value as Box;
			if (padding == null) {
				padding = new Box();
			}
			if (_padding.equals(padding)) {
				return;
			}
			
			_padding.left = padding.left;
			_padding.top = padding.top;
			_padding.right = padding.right;
			_padding.bottom = padding.bottom;
			_padding.horizontal = padding.horizontal;
			_padding.vertical = padding.vertical;
			dispatchEvent(new Event("paddingChange"));
		}
		
		[Bindable(event="dockChange")]
		public function get dock():String
		{
			return _dock;
		}
		public function set dock(value:String):void
		{
			if (value != Dock.NONE && value != Dock.LEFT && value != Dock.TOP &&
				value != Dock.RIGHT && value != Dock.BOTTOM && value != Dock.FILL) {
				value = Dock.NONE;
			}
			
			if (_dock == value) {
				return;
			}
			
			_dock = value;
			if (_tile != Dock.NONE && (_dock == Dock.NONE || _dock == Dock.FILL) ) {
				tile = Dock.NONE;
			}
			dispatchEvent( new Event("dockChange") );
		}
		
		[Bindable(event="tileChange")]
		public function get tile():String
		{
			return _tile;
		}
		public function set tile(value:String):void
		{
			if (value != Dock.NONE && value != Dock.LEFT && value != Dock.TOP &&
				value != Dock.RIGHT && value != Dock.BOTTOM) {
				value = Dock.NONE;
			}
			
			if (_tile == value) {
				return;
			}
			
			_tile = value;
			// TODO: ensure dock is in the right axis (ie. if tile==LEFT then dock cannot equal LEFT or RIGHT)
			if (_tile != Dock.NONE && (_dock == Dock.NONE || _dock == Dock.FILL) ) {
				dock = (_tile == Dock.LEFT || _tile == Dock.RIGHT) ? Dock.TOP : Dock.LEFT;
			}
			dispatchEvent( new Event("tileChange") );
		}
		
		
		public function invalidate():void
		{
			var target:DisplayObject;
			if (validating || (target = this.target) == null) {
				return;
			}
			
			RenderEvent.invalidate(target, LAYOUT);
			// TODO: replace this method with childPropertyChange and add other property updates
			if ( target != null && blockIndex[target.parent] != null ) {
				var parent:Block = blockIndex[target.parent];
					parent.invalidateSize();
			}
			
		}
		
		public function invalidateSize():void
		{
			var target:DisplayObject;
			if (validating || (target = this.target) == null) {
				return;
			}
			
			RenderEvent.invalidate(target, MEASURE);
		}
		
		public function validate():void
		{
			var target:DisplayObject;
			if (validating || (target = this.target) == null) {
				return;
			}
			validating = true;
			
			if (freeform) {
				// layout self (anchor, etc)
			}
			
			if (layout != null && target is DisplayObjectContainer) {
				// layout children
				layout.layout( DisplayObjectContainer(target) );
			}
			
			// TODO: take into account target's rotation
			if (scale) {
				target.width = _width;
				target.height = _height;
			}
			validating = false;
		}
		
		public function measure():void
		{
			var target:DisplayObjectContainer = this.target as DisplayObjectContainer;
			if (target == null) {
				return;
			}
			
			if (layout != null) {
				layout.measure(target);
				return;
			}
			
			var measurement:Bounds = new Bounds();
			
			for (var i:int = 0; i < target.numChildren; i++) {
				var display:DisplayObject = target.getChildAt(i);
				var child:Block = blockIndex[display];
				if (child == null || child.freeform) {
					continue;
				}
				
				measurement.minWidth = measurement.constrainWidth(
					display.x + child.width + padding.right + child.margin.right);
				
				measurement.minHeight = measurement.constrainHeight(
					display.y + child.height + padding.bottom + child.margin.bottom);
			}
			
			updateMeasurement(measurement);
		}
		
		public function updateMeasurement(measuredBounds:Bounds, measuredWidth:Number = 0, measuredHeight:Number = 0):void
		{
			measuredBounds.merge(bounds);
			
			if (_measuredWidth != measuredWidth) {
				_measuredWidth = measuredWidth;
				dispatchEvent( new Event("measuredWidthChange") );
			}
			if (_measuredHeight != measuredHeight) {
				_measuredHeight = measuredHeight;
				dispatchEvent( new Event("measuredHeightChange") );
			}
			if ( !_measuredBounds.equals(measuredBounds) ) {
				_measuredBounds = measuredBounds;
				dispatchEvent( new Event("measuredBoundsChange") );
			}
			
			updateWidth();
			updateHeight();
		}
		
		
		
		protected function updateWidth():void
		{
			var value:Number = explicitWidth;
			if ( isNaN(value) ) {
				value = defaultWidth >= _measuredWidth ? defaultWidth : _measuredWidth;
			}
			
			var oldValue:Number = _width;
			_width = measuredBounds.constrainWidth(value);
			if (_width != oldValue) {
				invalidate();
				dispatchEvent(new Event("widthChange"));
			}
		}
		
		protected function updateHeight():void
		{
			var value:Number = explicitHeight;
			if ( isNaN(value) ) {
				value = !isNaN(measuredHeight) && measuredHeight > defaultHeight ? measuredHeight : defaultHeight;
			}
			
			var oldValue:Number = _height;
			_height = measuredBounds.constrainHeight(value);
			if (_height != oldValue) {
				invalidate();
				dispatchEvent(new Event("heightChange"));
			}
		}
		
		
		private function onLayout(event:Event):void
		{
			validate();
		}
		
		private function onMeasure(event:Event):void
		{
			measure();
		}
		
		private function onObjectChange(event:Event):void
		{
			switch (event.target) {
				case _margin :
					dispatchEvent( new Event("marginChange") );
					break;
				case _padding :
					dispatchEvent( new Event("paddingChange") );
					break;
			}
		}
		
		
		// TODO: layouts and blocks (or block-types) can choose what properties to listen to
		// on their children in order to invalidate (and choose which type of invalidation: layout or measure)
		protected function propertyChange(property:String, oldValue:Object, newValue:Object):void
		{
			if (_targetIndex != null && blockIndex[target.parent] is Block) {
				var parent:Block = blockIndex[target.parent];
					parent.childPropertyChange(property, oldValue, newValue);
			}
			
			PropertyEvent.dispatchChange(this, property, oldValue, newValue);
		}
		
		protected function childPropertyChange(property:String, oldValue:Object, newValue:Object):void
		{
		}
		
	}
}