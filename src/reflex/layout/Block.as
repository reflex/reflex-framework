package reflex.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import flight.events.PropertyEvent;
	
	public class Block extends Layout
	{
		[Bindable]
		public var scale:Boolean = false;
		
		[Bindable]
		public var bounds:Bounds = new Bounds();
		
		public var snapToPixel:Boolean;
		
		// holds explicitly set value from setting width/height
		protected var explicitWidth:Number;
		protected var explicitHeight:Number;
		
		protected var defaultWidth:Number = 0;
		protected var defaultHeight:Number = 0;
		
		private var _x:Number;
		private var _y:Number;
		private var _width:Number = defaultWidth;
		private var _height:Number = defaultHeight;
		private var _displayWidth:Number = defaultWidth;
		private var _displayHeight:Number = defaultHeight;
		private var _measuredWidth:Number = 0;
		private var _measuredHeight:Number = 0;
		private var _measuredBounds:Bounds = bounds;
		private var _blockBounds:Bounds = bounds;
		
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
			bounds.addEventListener(PropertyEvent.PROPERTY_CHANGE, onObjectChange);
			_anchor.horizontal = _anchor.vertical = NaN;
			algorithm = new Dock();
		}
		
		override public function set target(value:DisplayObject):void
		{
			if (target == value) {
				return;
			}
			
			if (value != null) {
				var rect:Rectangle = value.getRect(value);
				defaultWidth = rect.right;
				defaultHeight = rect.bottom;
				super.target = value;
				updateSize();
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
			
			_x = snapToPixel ? Math.round(value) : value;
			if (target != null && !isNaN(_x) ) {
				var m:Matrix = target.transform.matrix;
				var d:Number = m.a * _displayWidth + m.c * _displayHeight;
				target.x = d < 0 ? _x - d : _x;
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
			
			_y = snapToPixel ? Math.round(value) : value;
			if (target != null && !isNaN(_y) ) {
				var m:Matrix = target.transform.matrix;
				var d:Number = m.d * _displayHeight + m.b * _displayWidth;
				target.y = d < 0 ? _y - d : _y;
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
			if (target == null) {		// TODO: or if scaling and rotation are default
				displayWidth = value;
			} else {
				var m:Matrix = target.transform.matrix;
				if (scale) {
					// set scale back to 1 but keep rotation
					var skewY:Number = Math.atan2(m.b, m.a);
					m.a = Math.cos(skewY);
					m.b = Math.sin(skewY);
					var skewX:Number = Math.atan2(-m.c, m.d);
					m.c = -Math.sin(skewX);
					m.d = Math.cos(skewX);
				}
				m.invert();
				
				var w:Number = Math.abs(m.a * value + m.c * _height);
				var h:Number = Math.abs(m.d * _height + m.b * value);
				
				if (w != _displayWidth) {
					explicitWidth = w;
				}
				if (h != _displayHeight) {
					explicitHeight = h;
				}
				updateSize();
			}
		}
		
		[Bindable(event="heightChange")]
		public function get height():Number
		{
			return _height;
		}
		public function set height(value:Number):void
		{
			if (target == null) {		// TODO: or if scaling and rotation are default
				displayHeight = value;
			} else {
				var m:Matrix = target.transform.matrix;
				if (scale) {
					// set scale back to 1 but keep rotation
					var skewY:Number = Math.atan2(m.b, m.a);
					m.a = Math.cos(skewY);
					m.b = Math.sin(skewY);
					var skewX:Number = Math.atan2(-m.c, m.d);
					m.c = -Math.sin(skewX);
					m.d = Math.cos(skewX);
				}
				m.invert();
				
				var h:Number = Math.abs(m.d * value + m.b * _width);
				var w:Number = Math.abs(m.a * _width + m.c * value);
				if (h != _displayHeight) {
					explicitHeight = h;
				}
				if (w != _displayWidth) {
					explicitWidth = w;
				}
				updateSize();
			}
		}
		
		public function get displayWidth():Number
		{
			return _displayWidth;
		}
		public function set displayWidth(value:Number):void
		{
			if (explicitWidth == value) {
				return;
			}
			
			explicitWidth = snapToPixel ? Math.round(value) : value;
			updateSize();
		}
		
		public function get displayHeight():Number
		{
			return _displayHeight;
		}
		public function set displayHeight(value:Number):void
		{
			if (explicitHeight == value) {
				return;
			}
			
			explicitHeight = snapToPixel ? Math.round(value) : value;
			updateSize();
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
		
		public function get blockBounds():Bounds
		{
			return _blockBounds;
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
			_blockBounds = measuredBounds.clone();
			
			if (target != null) {		// TODO: and if scaling and rotation are not default
				var m:Matrix = target.transform.matrix;
				if (scale) {
					// set scale back to 1 but keep rotation
					var skewY:Number = Math.atan2(m.b, m.a);
					m.a = Math.cos(skewY);
					m.b = Math.sin(skewY);
					var skewX:Number = Math.atan2(-m.c, m.d);
					m.c = -Math.sin(skewX);
					m.d = Math.cos(skewX);
				}
				_blockBounds.minWidth = Math.abs(m.a * measuredBounds.minWidth + m.c * measuredBounds.minHeight);
				_blockBounds.minHeight = Math.abs(m.d * measuredBounds.minHeight + m.b * measuredBounds.minWidth);
				_blockBounds.maxWidth = Math.abs(m.a * measuredBounds.maxWidth + m.c * measuredBounds.maxHeight);
				_blockBounds.maxHeight = Math.abs(m.d * measuredBounds.maxHeight + m.b * measuredBounds.maxWidth);
			}
			
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
			
			updateSize();
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
		}
		
		protected function updateSize():void
		{
			var oldWidth:Number = _width;
			var oldHeight:Number = _height;
			
			_displayWidth = !isNaN(explicitWidth) ? explicitWidth :
							(_measuredWidth >= defaultWidth ? _measuredWidth : defaultWidth);
			_displayHeight = !isNaN(explicitHeight) ? explicitHeight :
							 (defaultHeight >= _measuredHeight ? defaultHeight : _measuredHeight);
			
			_displayWidth = measuredBounds.constrainWidth(_displayWidth);
			_displayHeight = measuredBounds.constrainHeight(_displayHeight);
			if (snapToPixel) {
				_displayWidth = Math.round(_displayWidth);
				_displayHeight = Math.round(_displayHeight);
			}
			
			if (target == null) {		// TODO: or if scaling and rotation are default
				_width = _displayWidth;
				_height = _displayHeight;
			} else {
				var m:Matrix = target.transform.matrix;
				if (scale) {
					// reset scale while retaining rotation
					var skewY:Number = Math.atan2(m.b, m.a);
					m.a = Math.cos(skewY);
					m.b = Math.sin(skewY);
					var skewX:Number = Math.atan2(-m.c, m.d);
					m.c = -Math.sin(skewX);
					m.d = Math.cos(skewX);
				}
				
				_width = Math.abs(m.a * _displayWidth + m.c * _displayHeight);
				_height = Math.abs(m.d * _displayHeight + m.b * _displayWidth);
				if (snapToPixel) {
					_width = Math.round(_width);
					_height = Math.round(_height);
				}
			}
			
			if (_width != oldWidth) {
				invalidate();
				dispatchEvent(new Event("widthChange"));
			}
			if (_height != oldHeight) {
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
				case bounds :
					invalidate(true);
					dispatchEvent( new Event("boundsChange") );
					break;
			}
		}
		
	}
}
