package reflex.behaviors
{
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
	
	import reflex.binding.DataChange;
	
	[SkinState("up")]
	[SkinState("over")]
	[SkinState("down")]
	
	public class MovieClipSkinBehavior extends Behavior
	{
		
		public static const UP:String = "up";
		public static const OVER:String = "over";
		public static const DOWN:String = "down";
		
		private var _currentState:String = UP;
		private var _selected:Boolean = false;
		private var _enabled:Boolean = true;
		private var _movieclip:MovieClip;
		
		[Bindable(event="currentStateChange")]
		[Binding(target="target.currentState")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void {
			DataChange.change(this, "currentState", _currentState, _currentState = value);
			gotoState(_movieclip, getState()); // invalidation?
		}
		
		[Bindable(event="selectedChange")]
		[Binding(target="target.selected")]
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void {
			DataChange.change(this, "selected", _selected, _selected = value);
			gotoState(_movieclip, getState()); // invalidation?
		}
		
		[Bindable(event="enabledChange")]
		[Binding(target="target.enabled")]
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void {
			DataChange.change(this, "enabled", _enabled, _enabled = value);
			gotoState(_movieclip, getState()); // invalidation?
		}
		
		[Bindable(event="movieclipChange")]
		[Binding(target="target.skin")]
		public function get movieclip():MovieClip { return _movieclip; }
		public function set movieclip(value:MovieClip):void {
			DataChange.change(this, "movieclip", _movieclip, _movieclip = value);
			gotoState(_movieclip, getState()); // invalidation?
		}
		
		public function MovieClipSkinBehavior(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		private function getState():String {
			// skin state may be different then component currentState
			// this might be moved elsewhere later
			if(!enabled) { return "disabled"; }
			if(selected) { return "selected" + currentState.substr(0, 1).toUpperCase() + currentState.substr(1); }
			return currentState;
		}
		
		// ====== Event Listeners ====== //
		
		// we'll update this for animated/play animations later
		private function gotoState(clip:MovieClip, state:String):void {
			if(clip) {
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
}