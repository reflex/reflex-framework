package reflex.behaviors
{
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
	
	[SkinState("up")]
	[SkinState("over")]
	[SkinState("down")]
	
	public class MovieClipSkinBehavior extends Behavior
	{
		
		public static const UP:String = "up";
		public static const OVER:String = "over";
		public static const DOWN:String = "down";
		
		[Bindable]
		[Binding(target="target.currentState")]
		public var currentState:String = UP;
		
		[Bindable]
		[Binding(target="target.skin")]
		public var movieclip:MovieClip;
		
		public function MovieClipSkinBehavior(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		// ====== Event Listeners ====== //
		
		[PropertyListener(target="movieclip")]
		public function onMovieClip(object:MovieClip):void
		{
			// trace(object);
		}
		
		[PropertyListener(target="currentState")]
		public function onState(object:String):void
		{
			if(movieclip) {
				gotoState(movieclip, object);
			}
		}
		
		// we'll update this for animated/play animations later
		private function gotoState(clip:MovieClip, state:String):void {
			var frames:Array = clip.currentLabels;
			for each(var label:FrameLabel in frames) {
				if(label.name == state) {
					clip.gotoAndStop(label.frame);
				}
			}
			
			var length:int = clip.numChildren; // recurse (for now)
			for(var i:int = 0; i < length; i++) {
				var child:DisplayObject = clip.getChildAt(i);
				if(child is MovieClip) {
					gotoState(child as MovieClip, state);
				}
			}
		}
		
	}
}