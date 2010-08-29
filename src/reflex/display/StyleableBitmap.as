package reflex.display
{
	import flash.events.Event;
	
	import flight.events.PropertyEvent;
	
	import reflex.components.IStateful;
	import reflex.styles.IStyleable;
	
	/**
	 * Provides a styling and state management implementation
	 * 
	 * @alpha
	 */
	public class StyleableBitmap extends MeasuredBitmap implements IStyleable
	{
		
		private var _id:String;
		private var _styleName:String;
		private var _style:Object;
		
		
		public function StyleableBitmap() {
			_style = new Object(); // need to make object props bindable - something like ObjectProxy but lighter?
		}
		
		
		// IStyleable implementation
		
		[Bindable(event="idChange")]
		public function get id():String { return _id; }
		public function set id(value:String):void {
			if(_id == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "id", _id, _id = value);
		}
		
		[Bindable(event="styleNameChange")]
		public function get styleName():String { return _styleName;}
		public function set styleName(value:String):void {
			if(_styleName == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "styleName", _styleName, _styleName= value);
		}
		
		[Bindable(event="styleChange")]
		public function get style():Object { return _style; }
		public function set style(value:*):void { // this needs expanding in the future
			if(value is String) {
				var token:String = value as String;
				var assignments:Array = token.split(";");
				for each(var assignment:String in assignments) {
					var split:Array = assignment.split(":");
					if(split.length == 2) {
						var property:String = split[0].replace(/\s+/g, "");
						var v:String = split[1].replace(/\s+/g, "");
						_style[property] = v;
					}
				}
			}
		}
		
		public function getStyle(property:String):* {
			return style[property];
		}
		
		public function setStyle(property:String, value:*):void {
			style[property] = value;
		}
		
	}
}