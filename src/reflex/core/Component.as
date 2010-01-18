package reflex.core
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import reflex.behaviors.CompositeBehavior;
	import reflex.utils.MetaInjector;
	
	// Ideally we'll compile for Flash/Flex by extending FlashComponent or FlexComponent here
	public class Component extends FlashComponent implements IBehavioral, ISkinnable
	{
		
		private var _behaviors:CompositeBehavior;
		
		public function Component()
		{
			MetaInjector.createDefaults(this);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		[ArrayElementType("reflex.core.IBehavior")]
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
		public function get behaviors():Object
		{
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
		
		
		private var _skin:Object; [Bindable]
		public function get skin():Object { return _skin; }
		public function set skin(value:Object):void {
			removeSkin(_skin);
			_skin = value;
			addSkin(_skin);
		}
		
		private function removeSkin(skin:Object):void {
			if(skin && skin is ISkin) {
				if(skin is DisplayObject && this.contains(skin as DisplayObject)) {
					this.removeChild(skin as DisplayObject);
				}
				skin.data = null;
			}
		}
		
		private function addSkin(skin:Object):void {
			if(skin && skin is ISkin) {
				skin.data = this;
				if(skin is DisplayObject) {
					this.addChild(skin as DisplayObject);
				}
			}
		}
		
		
	}
}