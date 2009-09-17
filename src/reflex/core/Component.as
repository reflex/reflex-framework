package reflex.core
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import reflex.behaviors.BehaviorMap;
	
	public class Component extends MovieClip implements IBehavioral, ISkinnable
	{
		protected var _behaviorMap:BehaviorMap;
		
		
		public function Component()
		{
			_behaviorMap = new BehaviorMap(this);
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
			return _behaviorMap;
		}
		
		public function set behaviors(value:*):void
		{
			if (value is Array) {
				_behaviorMap.add(value);
			} else if (value is IBehavior) {
				_behaviorMap[IBehavior(value).name] = value;
			}
		}
		
		
		private var _skin:ISkin; [Bindable]
		public function get skin():ISkin { return _skin; }
		public function set skin(value:ISkin):void {
			removeSkin(_skin);
			_skin = value;
			addSkin(_skin);
		}
		
		private function removeSkin(skin:ISkin):void {
			if(skin) {
				if(skin is DisplayObject && this.contains(skin as DisplayObject)) {
					this.removeChild(skin as DisplayObject);
				}
				skin.data = null;
			}
		}
		
		private function addSkin(skin:ISkin):void {
			if(skin) {
				skin.data = this;
				if(skin is DisplayObject) {
					this.addChild(skin as DisplayObject);
				}
			}
		}
		
		// todo: Invalidation
		// todo: Measurement
		
	}
}