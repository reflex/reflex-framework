package reflex.component
{
	import flash.display.MovieClip;
	
	import flight.list.IList;
	
	import reflex.behaviors.CompositeBehavior;
	import reflex.behaviors.IBehavior;
	import reflex.behaviors.IBehavioral;
	import reflex.display.BlockDisplay;
	import reflex.layout.ILayoutAlgorithm;
	import reflex.observers.CheckSameObserver;
	import reflex.observers.ClassObserver;
	import reflex.observers.IPropertyObservable;
	import reflex.observers.IPropertyObserver;
	import reflex.observers.PropertyObservable;
	import reflex.observers.SetTargetObserver;
	import reflex.skins.ISkin;
	import reflex.skins.ISkinnable;
	
	public class Component extends BlockDisplay implements IBehavioral, ISkinnable, IPropertyObservable
	{
		//[Bindable] override public var enabled:Boolean;
		private var propertyObservable:PropertyObservable;
		private var _behaviors:CompositeBehavior;
		
		public function Component()
		{
			propertyObservable = new PropertyObservable(this);
			addPropertyObserver(ClassObserver.instance);
			addPropertyObserver(CheckSameObserver.instance);
			addPropertyObserver(SetTargetObserver.instance);
		}
		
		override public function set layout(value:*):void
		{
			super.layout = changeProperty("layout", super.layout, value);
		}
		
		[Bindable]
		public var state:String;
		
		[Bindable]
		public var data:Object;
		
		[Bindable]
		public var children:IList;
		
		
		[ArrayElementType("reflex.behaviors.IBehavior")]
		/**
		 * A dynamic object or hash map of behavior objects. <code>behaviors</code>
		 * is effectively read-only, but setting either an IBehavior or array of
		 * IBehavior to this property will add those behaviors to the <code>behaviors</code>
		 * object/map.
		 * 
		 * To set behaviors in MXML:
		 * <Component...>
		 *   <behaviors>
		 *     <SelectBehavior/>
		 *     <ButtonBehavior/>
		 *   </behaviors>
		 * </Component>
		 */
		public function get behaviors():CompositeBehavior
		{
			if(_behaviors == null) {
				_behaviors = new CompositeBehavior(this);
			}
			return _behaviors;
		}
		
		public function set behaviors(value:*):void
		{
			if(_behaviors == null) {
				_behaviors = new CompositeBehavior(this);
			}
			_behaviors.clear();
			if (value is Array) {
				_behaviors.add(value);
			} else if (value is IBehavior) {
				_behaviors.add([value]);
			}
		}
		
		private var _skin:ISkin;
		
		[Bindable]
		public function get skin():ISkin
		{
			return _skin;
		}
		
		public function set skin(value:*):void
		{
			_skin = changeProperty("skin", _skin, value);
		}
		
		public function addPropertyObserver(observer:IPropertyObserver):void
		{
			propertyObservable.addPropertyObserver(observer);
		}
		
		public function removePropertyObserver(observer:IPropertyObserver):void
		{
			propertyObservable.removePropertyObserver(observer);
		}
		
		protected function changeProperty(name:String, oldValue:*, newValue:*):*
		{
			propertyObservable.changeProperty(name, oldValue, newValue);
		}
	}
}