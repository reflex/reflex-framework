package reflex.display
{
	import reflex.components.IStateful;
	import reflex.styles.IStyleable;
	
	/**
	 * Provides a styling and state management implementation
	 * 
	 * @alpha
	 */
	public class StyleableSprite extends MeasuredSprite implements IStyleable, IStateful
	{
		
		private var _id:String;
		private var _styleName:String;
		private var _style:Object;
		
		private var _states:Array;
		private var _currentState:String;
		
		
		public function StyleableSprite() {
			_style = new Object(); // need to make object props bindable - something like ObjectProxy but lighter?
		}
		
		
		// IStyleable implementation
		
		[Bindable]
		public function get id():String { return _id; }
		public function set id(value:String):void {
			_id = value;
		}
		
		[Bindable]
		public function get styleName():String { return _styleName;}
		public function set styleName(value:String):void {
			_styleName = value;
		}
		
		[Bindable] 
		public function get style():Object { return _style; }
		public function set style(value:*):void { // this needs expanding
			if(value is String) {
				var token:String = value as String;
				var assignments:Array = token.split(";");
				for each(var assignment:String in assignments) {
					var split:Array = assignment.split(":");
					var property:String = split[0];
					var v:String = split[1];
					_style[property] = v;
				}
			}
		}
		
		public function setStyle(property:String, value:*):void {
			style[property] = value;
		}
		
		
		// IStateful implementation
		
		[Bindable]
		public function get states():Array { return _states; }
		public function set states(value:Array):void {
			_states = value;
			dispatchEvent(new Event("statesChange"));
		}
		
		
		[Bindable(event="currentStateChange")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void
		{
			_currentState = value;
			dispatchEvent(new Event("currentStateChange"));
		}
		
	}
}