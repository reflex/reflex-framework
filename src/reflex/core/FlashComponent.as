package reflex.core
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	// Measurement is just stubbed out for now, invalidation will need to be in here as well or in another class we extend
	public class FlashComponent extends MovieClip implements IMeasurable, IMeasurableRange, IPercentSize
	{
		
		[Bindable("xChanged")]
		[Inspectable(category="General")]
		override public function get x():Number { return super.x; }
		override public function set x(value:Number):void {
			if (super.x == value) return;
			super.x = value;
			//invalidateProperties();
			dispatchEvent(new Event("xChanged"));
		}
		
		[Bindable("yChanged")]
		[Inspectable(category="General")]
		override public function get y():Number { return super.y; }
		override public function set y(value:Number):void {
			if (super.y == value) return;
			super.y = value;
			//invalidateProperties();
			dispatchEvent(new Event("yChanged"));
		}
		
		[Bindable("widthChanged")]
		[Inspectable(category="General")]
		[PercentProxy("percentWidth")]
		override public function get width():Number { return _explicitWidth; }
		override public function set width(value:Number):void {
			//if (_explicitWidth == value) return;
			_explicitWidth = value;
			//invalidateProperties();
			dispatchEvent(new Event("widthChanged"));
		}
		
		[Bindable("heightChanged")]
		[Inspectable(category="General")]
		[PercentProxy("percentHeight")]
		override public function get height():Number { return _explicitHeight; }
		override public function set height(value:Number):void {
			//if (_explicitHeight == value) return;
			_explicitHeight = value;
			//invalidateProperties();
			dispatchEvent(new Event("heightChanged"));
		}
		
		
		// IMeasurable
		
		private var _explicitWidth:Number = 100;
		private var _explicitHeight:Number = 60;
		private var _measuredWidth:Number = 0;
		private var _measuredHeight:Number = 0;
		
		public function get explicitWidth():Number { return _explicitWidth; }
		public function set explicitWidth(value:Number):void {
			_explicitWidth = value;
		}
		
		public function get explicitHeight():Number { return _explicitHeight; }
		public function set explicitHeight(value:Number):void {
			_explicitHeight = value;
		}
		
		public function get measuredWidth():Number { return _measuredWidth; }
		public function set measuredWidth(value:Number):void {
			_measuredWidth = value;
		}
		
		public function get measuredHeight():Number { return _measuredHeight; }
		public function set measuredHeight(value:Number):void {
			_measuredHeight = value;
		}
		
		
		// IPercentSize
		
		private var _percentWidth:Number;
		private var _percentHeight:Number;
		
		public function get percentWidth():Number { return _percentWidth; }
		public function set percentWidth(value:Number):void {
			_percentWidth = value;
		}
		
		public function get percentHeight():Number { return _percentHeight; }
		public function set percentHeight(value:Number):void {
			_percentHeight = value;
		}
		
		
		// IMeasurableRange
		
		private var _explicitMinWidth:Number;
		private var _explicitMaxWidth:Number;
		private var _explicitMinHeight:Number;
		private var _explicitMaxHeight:Number;
		private var _measuredMinWidth:Number;
		private var _measuredMinHeight:Number;
		
		public function get minWidth():Number { return _explicitMinWidth; }
		public function set minWidth(value:Number):void {
			_explicitMinWidth = value;
		}
		
		public function get maxWidth():Number { return _explicitMaxWidth; }
		public function set maxWidth(value:Number):void {
			_explicitMaxWidth = value;
		}
		
		public function get minHeight():Number { return _explicitMinHeight; }
		public function set minHeight(value:Number):void {
			_explicitMinHeight = value;
		}
		
		public function get maxHeight():Number { return _explicitMaxHeight; }
		public function set maxHeight(value:Number):void {
			_explicitMaxHeight = value;
		}
		
		public function get measuredMinWidth():Number { return _measuredMinWidth; }
		public function set measuredMinWidth(value:Number):void {
			_measuredMinWidth = value;
		}
		
		public function get measuredMinHeight():Number { return _measuredMinHeight; }
		public function set measuredMinHeight(value:Number):void {
			_measuredMinHeight = value;
		}
		
	}
}