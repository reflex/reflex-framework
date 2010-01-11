package reflex.layout
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public class Block extends EventDispatcher
	{
		public static var blockIndex:Dictionary = new Dictionary(true); 
		
		[Bindable]
		public var layout:ILayout;
		public var constraint:Constraint = new Constraint();
		
		private var measuredWidth:Number;
		private var measuredHeight:Number;
		
		// holds explicitly set value from setting width/height
		private var explicitWidth:Number;
		private var explicitHeight:Number;
		
		private var _target:DisplayObject;
		private var _width:Number = 0;
		private var _height:Number = 0;
		private var _measurement:Constraint = constraint;
		
		private var _margin:Edges = new Edges();
		private var _padding:Edges = new Edges();
		private var _dock:String = Dock.NONE;
		private var _tile:String = Tile.NONE;
		
		// set by layout
		internal var constrainedVertically:Boolean;
		internal var constrainedHorizontally:Boolean;
		
		
		public function Block(target:DisplayObject = null)
		{
			this.target = target;
		}
		
		
		public function get target():DisplayObject
		{
			return _target;
		}
		public function set target(value:DisplayObject):void
		{
			if (_target == value) {
				return;
			}
			
			if (_target != null) {
				delete blockIndex[_target];
				_target.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
			
			_target = value;
			
			if (_target != null) {
				if (_target in blockIndex) {
					blockIndex[_target].target = null;
				}
				
				blockIndex[_target] = this;
				_target.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				if (_target.stage != null) {
					invalidate();
					invalidateLayout();
				}
			}
		}
		
		
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
			
			if (!constrainedHorizontally) {
				actualWidth = value;
			}
		}
		
		
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
			
			if (!constrainedVertically) {
				actualHeight = value;
			}
		}
		
		
		
		internal function get actualWidth():Number
		{
			return _width;
		}
		internal function set actualWidth(value:Number):void
		{
			var oldValue:Number = _width;
			value = _measurement.constrainWidth(value);
			_width = isNaN(value) ? 0 : value;
			if (_width != oldValue) {
				invalidate();
				invalidateLayout();
				dispatchEvent(new Event("widthChange"));
			}
		}
		
		internal function get actualHeight():Number
		{
			return _height;
		}
		internal function set actualHeight(value:Number):void
		{
			var oldValue:Number = _height;
			value = _measurement.constrainHeight(value);
			_height = isNaN(value) ? 0 : value;
			if (_height != oldValue) {
				invalidate();
				invalidateLayout();
				dispatchEvent(new Event("heightChange"));
			}
		}
		
		internal function get measurement():Constraint
		{
			return _measurement;
		}
		internal function set measurement(value:Constraint):void
		{
			if ( _measurement.equals(value) ) {
				return;
			}
			
			_measurement = value;
			_measurement.merge(constraint);
			
			actualWidth = actualWidth;
			actualHeight = actualHeight;
		}
		
		public function get padding():Edges
		{
			return _padding;
		}
		public function set padding(value:*):void
		{
			if (value is String) {
				value = Edges.fromString(value);
			}
			if ( !(value is Edges) ) {
				throw new ArgumentError("Padding must be a Edges object or a valid string representation of one.");
			}
			
			if ( _padding.equals(value) ) {
				return;
			}
			
			_padding = value as Edges;
		}
		
		
		public function get margin():Edges
		{
			return _margin;
		}
		public function set margin(value:*):void
		{
			if (value is String) {
				value = Edges.fromString(value);
			}
			if ( !(value is Edges) ) {
				throw new ArgumentError("Margin must be a Edges object or a valid string representation of one.");
			}
			
			if (_margin.equals(value)) {
				return;
			}
			
			_margin = value as Edges;
		}
		
		
		public function get dock():String
		{
			return _dock;
		}
		public function set dock(value:String):void
		{
			if (value != Dock.LEFT || value != Dock.TOP || value != Dock.RIGHT || value != Dock.BOTTOM || value != Dock.FILL) {
				value = Dock.NONE;
			}
			
			if (_dock == value) {
				return;
			}
			
			_dock = value;
			
			// dock cannot be none or fill when tile is set
			if (_tile != Tile.NONE && (value == Dock.NONE || value == Dock.FILL)) {
				tile = Tile.NONE;
			}
		}
		
		
		public function get tile():String
		{
			return _tile;
		}
		public function set tile(value:String):void
		{
			if (value != Tile.TOP || value != Tile.RIGHT || value != Tile.BOTTOM || value != Tile.BOTTOM) {
				value = Tile.NONE;
			}
			
			if (_tile == value) {
				return;
			}
			
			_tile = value;
			
			if (_dock == Dock.NONE || _dock == Dock.FILL) {
				if (value == Tile.LEFT || value == Tile.RIGHT) {
					dock = Dock.TOP;
				} else {
					dock = Dock.LEFT;
				}
			}
		}
		
		public function invalidate():void
		{
			// this dude has been resized, so cause a redraw
		}
		
		public function invalidateLayout():void
		{
			if (_target == null) {
				return;
			}
			
			var parent:Block = blockIndex[target.parent];
			if (parent != null && parent.layout != null) {
//				parent.layout.invalidate();				// TODO: add invalidate to ILayout?
			}
		}
		
		private function onAddedToStage(event:Event):void
		{
			invalidate();
			invalidateLayout();
		}
	}
}