package reflex.skins
{
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import reflex.binding.Bind;
	import reflex.binding.DataChange;
	
	public class MovieClipSkin extends MovieClip implements ISkin
	{
		
		protected var unscaledWidth:Number = 160;
		protected var unscaledHeight:Number = 22;
		
		private var _target:Sprite;
		private var _currentState:String;
		
		[Bindable(event="targetChange")]
		public function get target():Sprite { return _target; }
		public function set target(value:Sprite):void {
			DataChange.change(this, "target", _target, _target = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="widthChange")]
		override public function get width():Number { return unscaledWidth; }
		override public function set width(value:Number):void {
			DataChange.change(this, "width", unscaledWidth, unscaledWidth = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="heightChange")]
		override public function get height():Number { return unscaledHeight; }
		override public function set height(value:Number):void {
			DataChange.change(this, "height", unscaledHeight, unscaledHeight = value);
		}
		
		public function MovieClipSkin():void {
			super();
			Bind.addBinding(this, "target.currentState", this, "currentState", false);
		}
		
		// ====== MovieClip State Handling ====== //
		
		[Bindable(event="currentStateChange")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void {
			if(value == _currentState) {
				return;
			}
			DataChange.change(this, "currentState", _currentState, _currentState = value);
			gotoState(this, _currentState); // invalidation?
		}
		
		public function hasState( state:String ):Boolean {
			return childHasState(this, state); // cache later
		}
		
		private function childHasState(clip:MovieClip, state:String):Boolean {
			var frames:Array = clip.currentLabels;
			for each(var label:FrameLabel in frames) {
				if (label.name == state) {
					return true;
				}
			}
			var length:int = clip.numChildren; // recurse (for now)
			for (var i:int = 0; i < length; i++) {
				var child:DisplayObject = clip.getChildAt(i);
				if (child is MovieClip) {
					var t:Boolean = childHasState(child as MovieClip, state);
					if(t) { return true; }
				}
			}
			return false;
		}
		
		// we'll update this for animated/play animations later
		private function gotoState(clip:MovieClip, state:String):void {
			var frames:Array = clip.currentLabels;
			for each(var label:FrameLabel in frames) {
				if (label.name == state) {
					clip.gotoAndStop(label.frame);
				}
			}
			var length:int = clip.numChildren; // recurse (for now)
			for (var i:int = 0; i < length; i++) {
				var child:DisplayObject = clip.getChildAt(i);
				if (child is MovieClip) {
					gotoState(child as MovieClip, state);
				}
			}
		}
		
	}
}