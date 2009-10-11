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
		
		
		[Bindable] override public var enabled:Boolean;
		
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
		
		// Invalidation
		
		private var _invalidated:Array = [];
		
		/**
		 * Invalidate this component. The <code>validateMethod</code>
		 * function will be called in the validation cycle on stage render.
		 * Priority may be used to cause certain types of functionality to
		 * validate before than others, such as measure before layout.
		 * 
		 * @param The validation method to be called during the validation cycle.
		 * @param Optional priority to cause some validation methods to be
		 * triggered before others.
		 */
		public function invalidate(validationMethod:Function, priority:uint = 0, ...params):void
		{
			if (stage) {
				stage.invalidate();
			}
			
			// make sure the same method isn't added twice.
			if (isInvalidated(validationMethod)) {
				_invalidated.push({method: validationMethod, priority: priority, params: params});
				addEventListener(Event.RENDER, onRender);
			}
		}
		
		
		/**
		 * Whether or not this object has been invalidated and set to run its
		 * validation methods on the next render.
		 */
		public function get invalidated():Boolean
		{
			return _invalidated.length > 0;
		}
		
		
		/**
		 * Checks whether a method has already been invalidated.
		 * 
		 * @param The validation method which may have been invalidated.
		 * @return Whether that method was already invalidated.
		 */
		public function isInvalidated(validationMethod:Function):Boolean
		{
			var length:uint = _invalidated.length;
			for (var i:uint = 0; i < length; i++) {
				if (_invalidated[i].method == validationMethod) {
					return true;
				}
			}
			return false;
		}
		
		
		/**
		 * Removes a validation method from the invalidation queue. This method
		 * will no longer run on the next validation cycle.
		 * 
		 * @param The validation method that was invalidated.
		 * @return Whether the method was invalidated. Return false if the
		 * method was not previously invalidated.
		 */
		public function uninvalidate(validationMethod:Function):Boolean
		{
			var length:uint = _invalidated.length;
			for (var i:uint = 0; i < length; i++) {
				if (_invalidated[i].method == validationMethod) {
					_invalidated.splice(i, 0);
					if (!invalidated) {
						removeEventListener(Event.RENDER, onRender);
					}
					return true;
				}
			}
			return false;
		}
		
		
		/**
		 * Run the validation cycle for all invalidated methods.
		 * 
		 * @return Whether any validation methods were run.
		 */
		public function validate():Boolean
		{
			if (!invalidated) return false;
			removeEventListener(Event.RENDER, onRender);
			
			_invalidated.sortOn("priority", Array.NUMERIC);
			
			for each (var obj:Object in _invalidated) {
				obj.method.apply(null, obj.params);
			}
			
			_invalidated.length = 0;
			return true;
		}
		
		
		/**
		 * Triggers the validation cycle. Sorts validation methods by their
		 * priority and runs them.
		 */
		protected function onRender(event:Event):void
		{
			validate();
		}
		
		
		/**
		 * If this was invalidated while off the stage, it didn't get a chance
		 * to tell the stage to invalidate. Well, now it does! Go you, Mr.
		 * Component.
		 */
		protected function onAddedToStage(event:Event):void
		{
			if (invalidated) stage.invalidate();
		}
		
	}
}