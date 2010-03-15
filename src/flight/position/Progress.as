package flight.position
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	
	import flight.events.PropertyEvent;
	
	/**
	 * Data object representing a progression of any type.
	 */
	[Bindable]
	public class Progress extends EventDispatcher implements IProgress
	{
		/**
		 * The type of progression represented by this object as a string, for
		 * example: "bytes", "packets" or "pixels".
		 */
		public var type:String = "";
		
		private var loader:IEventDispatcher;
		private var _position:Number = 0;
		private var _percent:Number = 0;
		private var _size:Number = 1;
		
		/**
		 * Constructs a Progress object, optionally allowing the instance to be
		 * tied to an IEventDispatcher dispatching a <code>ProgressEvent</code>.
		 * 
		 * @param	progressor			An IEventDispatcher object that
		 * 								dispatches a <code>ProgressEvent</code>.
		 */
		public function Progress(progressor:IEventDispatcher = null)
		{
			this.loader = progressor;
			if (progressor != null) {
				type = "bytes";
				progressor.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
			}
		}
		
		/**
		 * The current position in the progression, between 0 and
		 * <code>size</code>.
		 */
		public function get value():Number
		{
			return _position;
		}
		public function set value(value:Number):void
		{
			value = Math.max(0, Math.min(_size, value));
			if (_position == value) {
				return;
			}
			_position = value;
			percent = _position / _size;
		}
		
		/**
		 * The percent complete in the progress, as a number between 0 and 1
		 * with 1 being 100% complete.
		 */
		public function get percent():Number
		{
			return _percent;
		}
		public function set percent(value:Number):void
		{
			value = Math.max(0, Math.min(1, value));
			if (_percent == value) {
				return;
			}
			_percent = value;
			value = _percent * _size;
		}
		
		/**
		 * The total size of the progression.
		 */
		public function get size():Number
		{
			return _size;
		}
		public function set size(value:Number):void
		{
			value = Math.max(0, value);
			if (_size == value) {
				return;
			}
			_size = value;
			
			if (_position > _size) {
				value = _size;
			} else if (_position > 0) {
				percent = _position / _size;
			}
		}
		
		/**
		 * Listener to an IEventDispatcher on the "progress" event.
		 */
		private function onProgress(event:ProgressEvent):void
		{
			size = event.bytesTotal;
			value = event.bytesLoaded;
		}
		
	}
}