package reflex.measurement
{
	
	
	
	/**
	 * The Measurements class holds values related to a object's dimensions.
	 * 
	 * @alpha
	 */
	public class Measurements implements IMeasurements
	{
		
		private var _width:Number;
		private var _height:Number;
		
		private var _minWidth:Number;
		private var _minHeight:Number;
		
		// should these be bindable?
		
		private var instance:IMeasurable;
		private var percent:IMeasurablePercent;
		
		/**
		 * @inheritDoc
		 */
		public function get width():Number { return _width; }
		public function set width(value:Number):void {
			if(_width == value) {
				return;
			}
			_width = value;
			if(instance.measured == this && (!isNaN(instance.explicit.width) || (percent != null && !isNaN(percent.percentWidth)))) {
				return;
			}
			
			/*
			if (instance.measured== this 
				&& isNaN(instance.explicit.width) 
				//&& (percent == null || isNaN(percent.percentWidth))
				) { // measured changes shouldn't update when explicit/percent is set
				instance.setSize(value, instance.height);
			}
			*/
			instance.setSize(value, instance.height);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get height():Number { return _height; }
		public function set height(value:Number):void {
			if(_height == value) {
				return;
			}
			_height = value;
			if(instance.measured == this && (!isNaN(instance.explicit.height) || (percent != null && !isNaN(percent.percentHeight)))) {
				return;
			}
			/*
			if (instance.measured == this 
				&& isNaN(instance.explicit.height)
				//&& (percent == null || isNaN(percent.percentHeight))
				) { // measured changes shouldn't update when explicit is set
				instance.setSize(instance.width, value); 
			}
			*/
			instance.setSize(instance.width, value);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get minWidth():Number { return _minWidth; }
		public function set minWidth(value:Number):void {
			_minWidth = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get minHeight():Number { return _minHeight; }
		public function set minHeight(value:Number):void {
			_minHeight = value;
		}
		
		// 160, 22
		public function Measurements(instance:IMeasurable, defaultWidth:Number = NaN, defaultHeight:Number = NaN) {
			this.instance = instance;
			this.percent = instance as IMeasurablePercent;
			_width = defaultWidth;
			_height = defaultHeight;
		}
		
	}
}