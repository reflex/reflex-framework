package reflex.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import reflex.behaviors.CompositeBehavior;
	import reflex.behaviors.IBehavior;
	import reflex.behaviors.IBehavioral;
	import reflex.display.MeasuredSprite;
	import reflex.display.StyleableSprite;
	import reflex.display.addItem;
	import reflex.events.InvalidationEvent;
	import reflex.measurement.resolveHeight;
	import reflex.measurement.resolveWidth;
	import reflex.measurement.setSize;
	import reflex.metadata.resolveCommitProperties;
	import reflex.skins.ISkin;
	import reflex.skins.ISkinnable;
	import reflex.styles.IStyleable;
	
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
	public class Component extends StyleableSprite implements IBehavioral, ISkinnable
	{
		
		static public const MEASURE:String = "measure";
		InvalidationEvent.registerPhase(MEASURE, 0, true);
		
		
		private var _skin:Object;
		private var _behaviors:CompositeBehavior;
		
		
		public function Component()
		{
			_behaviors = new CompositeBehavior(this);
			reflex.metadata.resolveCommitProperties(this);
			addEventListener(MEASURE, onMeasure, false, 0, true);
		}
		
		
		
		[ArrayElementType("reflex.behaviors.IBehavior")]
		[Bindable(event="behaviorsChange")]
		[Inspectable(name="Behaviors", type=Array)]
		/**
		 * A dynamic object or hash map of behavior objects. <code>behaviors</code>
		 * is effectively read-only, but setting either an IBehavior or array of
		 * IBehavior to this property will add those behaviors to the <code>behaviors</code>
		 * object/map.
		 * 
		 * To set behaviors in MXML:
		 * &lt;Component...&gt;
		 *   &lt;behaviors&gt;
		 *     &lt;SelectBehavior/&gt;
		 *     &lt;ButtonBehavior/&gt;
		 *   &lt;/behaviors&gt;
		 * &lt;/Component&gt;
		 */
		public function get behaviors():CompositeBehavior
		{
			return _behaviors;
		}
		public function set behaviors(value:*):void
		{
			/*
			var change:PropertyChange = PropertyChange.begin();
			value = change.add(this, "behaviors", _behaviors, value);
			*/
			_behaviors.clear();
			if (value is Array) {
				_behaviors.add(value);
			} else if (value is IBehavior) {
				_behaviors.add([value]);
			}
			//change.commit();
			dispatchEvent(new Event("behaviorsChange"));
		}
		
		[Bindable(event="skinChange")]
		[Inspectable(name="Skin", type=Class)]
		public function get skin():Object
		{
			return _skin;
		}
		public function set skin(value:Object):void
		{
			_skin = value;
			if(_skin is ISkin) {
				(_skin as ISkin).target = this;
			} else if(_skin is DisplayObject) {
				reflex.display.addItem(this, _skin);
			}
			reflex.measurement.setSize(skin, width, height);
			dispatchEvent(new Event("skinChange"));
			InvalidationEvent.invalidate(this, MEASURE);
		}
		
		[CommitProperties("width,height,skin")]
		public function updateSkinSize():void {
			
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
		
		private function onMeasure(event:InvalidationEvent):void {
			if((isNaN(explicite.width) || isNaN(explicite.height)) && skin) {
				measured.width = reflex.measurement.resolveWidth(skin); // explicite width of skin becomes measured width of component
				measured.height = reflex.measurement.resolveHeight(skin); // explicite height of skin becomes measured height of component
			}
		}
		
	}
}
