package reflex.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.collections.IList;
	import mx.core.IStateClient2;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	import reflex.behaviors.IBehavior;
	import reflex.collections.SimpleCollection;
	import reflex.containers.Container;
	import reflex.display.MeasurableItem;
	import reflex.display.PropertyDispatcher;
	import reflex.display.StatefulItem;
	import reflex.display.StyleableItem;
	import reflex.framework.IMeasurable;
	import reflex.framework.IMeasurablePercent;
	import reflex.injection.HardCodedInjector;
	import reflex.injection.IReflexInjector;
	import reflex.invalidation.IReflexInvalidation;
	import reflex.invalidation.LifeCycle;
	import reflex.measurement.resolveHeight;
	import reflex.measurement.resolveWidth;
	import reflex.measurement.setSize;
	import reflex.metadata.resolveCommitProperties;
	import reflex.skins.ISkin;
	
	
	
	/**
	 * @alpha
	 */
	public class Component extends StatefulItem
	{
		
		private var _explicitWidth:Number;
		private var _explicitHeight:Number;
		/*
		private var _percentWidth:Number;
		private var _percentHeight:Number;
		*/
		private var _skin:Object;
		private var _behaviors:IList = new SimpleCollection(); // injection issues
		//private var _queue:Array;
		
		private var _states:Array;
		private var _currentState:String;
		
		private var _enabled:Boolean = true;
		
		private var _injector:IReflexInjector;// = new HardCodedInjector();
		
		public function get injector():IReflexInjector { return _injector; }
		public function set injector(value:IReflexInjector):void {
			_injector = value;
			if(_injector) {
				var length:int = _behaviors ? _behaviors.length : 0;
				for(var i:int = 0; i < length; i++) {
					var item:IBehavior = _behaviors.getItemAt(i) as IBehavior;
					_injector.injectInto(item);
				}
			}
		}
		
		override public function set display(value:Object):void {
			super.display = value;
			if(_skin) {
				_skin.display = value;
			}
		}
		
		public function Component()
		{
			super();
			_behaviors.addEventListener(CollectionEvent.COLLECTION_CHANGE, behaviorsCollectionChangeHandler, false, 0, true);
			//this.addEventListener(LifeCycle.INITIALIZE, initialize);
		}
		
		override protected function initialize():void {
			super.initialize();
			if(_skin) {
				injector.injectInto(_skin);
				_skin.display = display;
			}
		}
		
		[ArrayElementType("reflex.behaviors.IBehavior")]
		[Bindable(event="behaviorsChange")]
		[Inspectable(name="Behaviors", type=Array)]
		/**
		 * A collection of behavior objects.
		 * 
		 * To set behaviors in MXML:
		 * &lt;Component...&gt;
		 *   &lt;behaviors&gt;
		 *     &lt;SelectBehavior/&gt;
		 *     &lt;ButtonBehavior/&gt;
		 *   &lt;/behaviors&gt;
		 * &lt;/Component&gt;
		 */
		public function get behaviors():IList { return _behaviors; }
		public function set behaviors(value:*):void
		{
			if (value is Array) {
				var valueArray:Array = value as Array;
				var length:int = valueArray.length;
				for(var i:int = 0; i < length; i++) {
					var behavior:IBehavior = valueArray[i];
					_behaviors.addItem(behavior);
				}
				//_behaviors.source = value;
			} else if (value is IBehavior) {
				_behaviors.addItem(value);
				//_behaviors.source = [value];
			} else if(value is IList) {
				(value as IList)
				_behaviors = value;
			}
			dispatchEvent(new Event("behaviorsChange"));
		}
		
		[Bindable(event="skinChange")]
		[Inspectable(name="Skin", type=Class)]
		public function get skin():Object { return _skin; }
		public function set skin(value:Object):void
		{
			if (_skin == value) {
				return;
			}
			
			if (_skin is ISkin) {
				(_skin as ISkin).target = null;
			}
			
			var oldSkin:Object = _skin;
			_skin = value;
			
			if (_skin is ISkin) {
				(_skin as ISkin).target = this;
			}
			if(injector && _skin) {
				injector.injectInto(_skin);
			}
			
			// invalidation in skin
			//_skin.invalidate(LifeCycle.INVALIDATE);
			//_skin.invalidate(LifeCycle.MEASURE);
			//_skin.invalidate(LifeCycle.LAYOUT);
			invalidate(LifeCycle.MEASURE);
			invalidate(LifeCycle.LAYOUT);
			dispatchEvent(new Event("skinChange"));
		}
		
		private function behaviorsCollectionChangeHandler(event:CollectionEvent):void {
			switch(event.kind) {
				case CollectionEventKind.ADD:
					for each(var item:IBehavior in event.items) {
						item.target = this;
						if(injector) { injector.injectInto(item); }
					}
					break;
				
			}
		}
		
		
		[PercentProxy("percentWidth")]
		[Bindable(event="widthChange")]
		override public function get width():Number {
			if(!isNaN(_explicitWidth)) { return _explicitWidth; }
			if(_skin) { return _skin.width; }
			return 0;
		}
		override public function set width(value:Number):void {
			_explicitWidth = value;
			reflex.measurement.setSize(skin, value, height);
			//skin.width = value;
		}
		
		[PercentProxy("percentHeight")]
		[Bindable(event="heightChange")]
		override public function get height():Number {
			if(!isNaN(_explicitHeight)) { return _explicitHeight; }
			if(_skin) { return _skin.height; }
			return 0;
		}
		override public function set height(value:Number):void {
			notify("height", _explicitHeight, _explicitHeight = value);
			reflex.measurement.setSize(skin, width, value);
			//skin.height = value;
		}
		/*
		public function get percentWidth():Number { return _percentWidth; }
		public function set percentWidth(value:Number):void {
			_percentWidth = value;
		}
		
		public function get percentHeight():Number { return _percentHeight; }
		public function set percentHeight(value:Number):void {
			_percentHeight = value;
		}
		
		public function get explicitWidth():Number { return _explicitWidth; }
		public function get explicitHeight():Number { return _explicitHeight; }
		
		public function get measuredWidth():Number { return skin.width; }
		public function get measuredHeight():Number { return skin.height; }
		*/
		override public function setSize(width:Number, height:Number):void {
			super.setSize(width, height);
			reflex.measurement.setSize(skin, width, height);
		}
		/*
		override protected function onMeasure(event:Event):void {
			if(skin) {
				if (isNaN(explicitWidth)) {
					var w:Number = reflex.measurement.resolveWidth(skin);
					_measuredWidth = w; // explicit width of skin becomes measured width of component
				}
				if(isNaN(explicitHeight)) {
					var h:Number = reflex.measurement.resolveHeight(skin);
					_measuredHeight = h; // explicit height of skin becomes measured height of component
				}
			}
		}
		*/
	}
}
