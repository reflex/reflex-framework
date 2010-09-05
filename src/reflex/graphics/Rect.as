package reflex.graphics
{
	
	import flash.display.Graphics;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.events.PropertyChangeEvent;
	
	import reflex.events.PropertyEvent;
	import reflex.styles.IStyleable;
	
	[Style(name="left")]
	[Style(name="right")]
	[Style(name="top")]
	[Style(name="bottom")]
	[Style(name="horizontalCenter")]
	[Style(name="verticalCenter")]
	[Style(name="dock")]
	[Style(name="align")]
	public class Rect extends EventDispatcher implements IDrawable, IStyleable
	{
		
		// todo: drawing still needs invalidation, but InvalidationEvent is based on DisplayObject
		
		private var _id:String;
		private var _styleName:String;
		private var _style:Object;
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _width:Number = 0;
		private var _height:Number = 0;
		private var _radiusX:Number = 0;
		private var _radiusY:Number = 0;
		
		[Bindable(event="xChange")]
		public function get x():Number { return _x; }
		public function set x(value:Number):void {
			if (_x == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "x", _x, _x = value);
			render();
		}
		
		[Bindable(event="yChange")]
		public function get y():Number { return _y; }
		public function set y(value:Number):void {
			if (_y == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "y", _y, _y = value);
			render();
		}
		
		
		[Bindable(event="widthChange")]
		public function get width():Number { return _width; }
		public function set width(value:Number):void {
			if (_width == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "width", _width, _width = value);
			render();
		}
		
		[Bindable(event="heightChange")]
		public function get height():Number { return _height; }
		public function set height(value:Number):void {
			if (_height == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "height", _height, _height = value);
			render();
		}
		
		[Bindable(event="radiusXChange")]
		public function get radiusX():Number { return _radiusX; }
		public function set radiusX(value:Number):void {
			if (_radiusX == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "radiusX", _radiusX, _radiusX = value);
			render();
		}
		
		[Bindable(event="radiusYChange")]
		public function get radiusY():Number { return _radiusY; }
		public function set radiusY(value:Number):void {
			if (_radiusY == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "radiusY", _radiusY, _radiusY = value);
			render();
		}
		
		// topLeftRadiusX
		// topLeftRadiusY
		// topRightRadiusX
		// topRightRadiusY
		// bottomRightRadiusX
		// botomRightRadiusY
		// bottomLeftRadiusX
		// bottomLeftRadiusY
		
		// IStyleable implementation
		
		[Bindable(event="idChange")]
		public function get id():String { return _id; }
		public function set id(value:String):void {
			if(_id == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "id", _id, _id = value);
		}
		
		[Bindable(event="styleNameChange")]
		public function get styleName():String { return _styleName;}
		public function set styleName(value:String):void {
			if(_styleName == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "styleName", _styleName, _styleName= value);
		}
		
		[Bindable(event="styleChange")]
		public function get style():Object { return _style; }
		public function set style(value:*):void { // this needs expanding in the future
			if(value is String) {
				var token:String = value as String;
				var assignments:Array = token.split(";");
				for each(var assignment:String in assignments) {
					var split:Array = assignment.split(":");
					if(split.length == 2) {
						var property:String = split[0].replace(/\s+/g, "");
						var v:String = split[1].replace(/\s+/g, "");
						_style[property] = v;
					}
				}
			}
		}
		
		public function getStyle(property:String):* {
			return style[property];
		}
		
		public function setStyle(property:String, value:*):void {
			style[property] = value;
		}
		
		// rect
		
		private var _fill:*;
		public function get fill():* { return _fill; }
		public function set fill(value:*):void {
			_fill = value;
			// update this to use binding correctly
			(_fill as IEventDispatcher).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler);
			render();
		}
		
		private var _stroke:*;
		public function get stroke():* { return _stroke; }
		public function set stroke(value:*):void {
			_stroke = value;
			render();
		}
		
		private var _target:Object;
		public function get target():Object { return _target; }
		public function set target(value:Object):void {
			_target = value;
			render();
		}
		
		public function Rect(target:Object = null)
		{
			this.target = target;
			_style = {};
		}
		
		public function render():void {
			var graphics:Vector.<Graphics> = reflex.graphics.resolveGraphics(target);
			for each(var g:Graphics in graphics) {
				g.clear();
				drawTo(g);
			}
		}
		
		private function drawTo(graphics:Graphics):void {
			if(width > 0 && height > 0) {
				var rectangle:Rectangle = new Rectangle(0, 0, width, height);
				if(stroke != null) { stroke.apply(graphics, rectangle, new Point()); }
				if(fill != null) { fill.begin(graphics, rectangle, new Point()); }
				graphics.drawRoundRect(_x, _y, _width, _height, _radiusX, _radiusY);
				if(fill != null) { fill.end(graphics); }
			}
		}
		
		private function propertyChangeHandler(event:PropertyChangeEvent):void {
			render();
		}
		
	}
}