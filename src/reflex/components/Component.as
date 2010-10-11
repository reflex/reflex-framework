package reflex.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	import reflex.behaviors.IBehavior;
	import reflex.behaviors.IBehavioral;
	import reflex.binding.DataChange;
	import reflex.collections.SimpleCollection;
	import reflex.display.Display;
	import reflex.invalidation.Invalidation;
	import reflex.measurement.resolveHeight;
	import reflex.measurement.resolveWidth;
	import reflex.measurement.setSize;
	import reflex.metadata.resolveCommitProperties;
	import reflex.skins.ISkin;
	import reflex.skins.ISkinnable;
	import reflex.templating.addItem;
	
	[Style(name="left")]
	[Style(name="right")]
	[Style(name="top")]
	[Style(name="bottom")]
	[Style(name="horizontalCenter")]
	[Style(name="verticalCenter")]
	[Style(name="dock")]
	[Style(name="align")]
	
	/**
	 * @alpha
	 */
	public class Component extends Display implements IBehavioral, ISkinnable
	{
		
		static public const MEASURE:String = "measure";
		Invalidation.registerPhase(MEASURE, 200, false);
		
		private var _skin:Object;
		private var _behaviors:SimpleCollection;
		
		private var _states:Array;
		private var _currentState:String;
		
		private var _enabled:Boolean = true;
		
		public function Component()
		{
			super();
			_behaviors = new SimpleCollection();
			_behaviors.addEventListener(CollectionEvent.COLLECTION_CHANGE, behaviorsCollectionChangeHandler, false, 0, true);
			reflex.metadata.resolveCommitProperties(this);
			addEventListener(MEASURE, onMeasure, false, 0, true);
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
				var length:int = (value as Array).length;
				for(var i:int = 0; i < length; i++) {
					var behavior:IBehavior = (value as Array)[0];
					_behaviors.addItem(behavior);
				}
				//_behaviors.source = value;
			} else if (value is IBehavior) {
				_behaviors.addItem(value);
				//_behaviors.source = [value];
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
			var oldSkin:Object = _skin;
			_skin = value;
			if (_skin is ISkin) {
				(_skin as ISkin).target = this;
			} else if (_skin is DisplayObject) {
				reflex.templating.addItem(this, _skin);
			}
			Invalidation.invalidate(this, MEASURE);
			dispatchEvent(new Event("skinChange"));
		}
		
		[Bindable(event="enabledChange")]
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void {
			mouseEnabled = mouseChildren = value;
			DataChange.change(this, "enabled", _enabled, _enabled = value);
		}
		
		[Bindable(event="currentStateChange")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void
		{
			DataChange.change(this, "currentState", _currentState, _currentState = value);
		}
		
		private function behaviorsCollectionChangeHandler(event:CollectionEvent):void {
			switch(event.kind) {
				case CollectionEventKind.ADD:
					for each(var item:IBehavior in event.items) {
						item.target = this;
					}
					break;
				
			}
		}
		
		// needs more thought
		
		override public function set width(value:Number):void {
			super.width = value;
			reflex.measurement.setSize(skin, value, height);
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			reflex.measurement.setSize(skin, width, value);
		}
		
		override public function setSize(width:Number, height:Number):void {
			super.setSize(width, height);
			reflex.measurement.setSize(skin, width, height);
		}
		
		private function onMeasure(event:Event):void {
			if ((isNaN(explicit.width) || isNaN(explicit.height)) && skin) {
				var w:Number = reflex.measurement.resolveWidth(skin);
				var h:Number = reflex.measurement.resolveHeight(skin);
				measured.width = w; // explicit width of skin becomes measured width of component
				measured.height = h; // explicit height of skin becomes measured height of component
			}
		}
		
	}
}
