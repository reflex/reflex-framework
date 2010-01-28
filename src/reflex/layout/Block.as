package reflex.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	
	import flight.events.PropertyEvent;
	
	import reflex.events.RenderEvent;
	
	public class Block extends Layout
	{
		[Bindable]
		public var scale:Boolean = false;
		
		[Bindable]
		public var bounds:Bounds = new Bounds();
		
		// holds explicitly set value from setting width/height
		protected var explicitWidth:Number;
		protected var explicitHeight:Number;
		
		protected var defaultWidth:Number = 0;
		protected var defaultHeight:Number = 0;
		
		protected var direction:int = 0;
		protected var inverted:Boolean;
		
		private var _x:Number;
		private var _y:Number;
		private var _width:Number = defaultWidth;
		private var _height:Number = defaultHeight;
		private var _measuredWidth:Number = 0;
		private var _measuredHeight:Number = 0;
		private var _measuredBounds:Bounds = bounds;
		private var _rotation:Number;
		
		private var _margin:Box = new Box();
		private var _padding:Box = new Box();
		private var _anchor:Box = new Box(NaN, NaN, NaN, NaN);
		private var _dock:String = Dock.NONE;
		private var _tile:String = Dock.NONE;
		
		
		public function Block(target:DisplayObject = null, scale:Boolean = false)
		{
			super(target);
			this.scale = scale;
			_margin.addEventListener(PropertyEvent.PROPERTY_CHANGE, onObjectChange);
			_padding.addEventListener(PropertyEvent.PROPERTY_CHANGE, onObjectChange);
			_anchor.addEventListener(PropertyEvent.PROPERTY_CHANGE, onObjectChange);
			_anchor.horizontal = _anchor.vertical = NaN;
			algorithm = new Dock();
		}
		
		override public function set target(value:DisplayObject):void
		{
			if (target == value) {
				return;
			}
			
			if (value != null) {
				defaultWidth = value.width;
				defaultHeight = value.height;
				rotation = value.rotation;
				var m:Matrix = value.transform.matrix;
				inverted = Math.abs( Math.atan2(m.b, m.a) - Math.atan2(-m.c, m.d) ) > (Math.PI / 2);
				super.target = value;
				updateWidth();
				updateHeight();
			} else {
				super.target = value;
			}
		}
		
		[Bindable(event="xChange")]
		public function get x():Number
		{
			return _x;
		}
		public function set x(value:Number):void
		{
			if (_x == value) {
				return;
			}
			
			_x = value;
			var d:int;
			
			if ( !isNaN(_x) ) {
				d = (inverted ? 5 - direction : direction) % 4;
				target.x = _x//(d == 1 || d == 2) ? _width + _x : _x;
			}
			dispatchEvent(new Event("xChange"));
		}
		
		[Bindable(event="yChange")]
		public function get y():Number
		{
			return _y;
		}
		public function set y(value:Number):void
		{
			if (_y == value) {
				return;
			}
			
			_y = value;
			var d:int;
			
			if ( !isNaN(_y) ) {
				d = (inverted ? 6 - direction : direction) % 4;
				target.y = _y//(d == 2 || d == 3) ? _height + _y : _y;
			}
			dispatchEvent(new Event("yChange"));
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
		
		public function get rotation():Number
		{
			return _rotation;
		}
		public function set rotation(value:Number):void
		{
			var shift:Number = value < 0 ? -180 : 179;
			value = (value + shift) % 360 - shift;
			
			if (_rotation == value) {
				return;
			}
			
			_rotation = value;
			direction = Math.round(_rotation / 90);
			if (direction < 0) {
				direction += 4;
			}
			
			var w:Number = defaultWidth;
			var h:Number = defaultHeight;
			defaultWidth = direction % 2 ? defaultHeight : defaultWidth;
			defaultHeight = direction % 2 ? defaultWidth : defaultHeight;
			
			invalidate();
		}
		
		public function get displayWidth():Number
		{
			return direction % 2 ? _height : _width;
		}
		
		public function get displayHeight():Number
		{
			return direction % 2 ? _width : _height;
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
		
		[Bindable(event="anchorChange")]
		public function get anchor():Box
		{
			return _anchor;
		}
		public function set anchor(value:*):void
		{
			var anchor:Box = (value is String || value is Number) ? Box.fromString( String(value) ) : value as Box;
			if (anchor == null) {
				anchor = new Box();
			}
			if (_anchor.equals(anchor)) {
				return;
			}
			
			_anchor.left = anchor.left;
			_anchor.top = anchor.top;
			_anchor.right = anchor.right;
			_anchor.bottom = anchor.bottom;
			_anchor.offsetX = anchor.offsetX;
			_anchor.offsetY = anchor.offsetY;
			_anchor.horizontal = anchor.horizontal;
			_anchor.vertical = anchor.vertical;
			dispatchEvent(new Event("anchorChange"));
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
			invalidate();
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
			invalidate();
			dispatchEvent( new Event("tileChange") );
		}
		
		override public function validate():void
		{
			super.validate();
			updateDisplay();
		}
		
		override public function measure():void
		{
			var container:DisplayObjectContainer = target as DisplayObjectContainer;
			if (container == null) {
				return;
			}
			
			if (algorithm != null) {
				algorithm.measure(container);
				return;
			}
			
			var measurement:Bounds = new Bounds();
			
			for (var i:int = 0; i < container.numChildren; i++) {
				var display:DisplayObject = container.getChildAt(i);
				var child:Block = getLayout(display) as Block;
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
		
		public function updateDisplay():void
		{
			if (target == null) {
				return;
			}
			
			if (scale) {
				target.width = displayWidth;
				target.height = displayHeight;
			}
			
			if ( !isNaN(_rotation) ) {
				target.rotation = _rotation;
			}
			if (target.name) {
				trace(target.name, target.x, target.y, target.width, target.height);
			}
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
		
		private function onObjectChange(event:Event):void
		{
			switch (event.target) {
				case _margin :
					invalidate();
					dispatchEvent( new Event("marginChange") );
					break;
				case _padding :
					invalidate();
					dispatchEvent( new Event("paddingChange") );
					break;
				case _padding :
					if (dock == Dock.NONE) {
						invalidate();
					}
					dispatchEvent( new Event("anchorChange") );
					break;
			}
		}
		
	}
}
