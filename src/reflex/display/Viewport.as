package reflex.display
{
	import flight.binding.Bind;
	import flight.events.PropertyEvent;
	import flight.list.IList;
	import flight.position.IPosition;
	
	public class Viewport extends Container
	{
		[Bindable]
		public var hPosition:IPosition;
		
		[Bindable]
		public var vPosition:IPosition;
		
		private var clipRect:ScrollRect;
		private var _container:Container;
		
		public function Viewport()
		{
			clipRect = new ScrollRect();
			hPosition = clipRect.hPosition;
			vPosition = clipRect.vPosition;
			Bind.addBinding(clipRect, "width", this, "displayWidth");
			Bind.addBinding(clipRect, "height", this, "displayHeight");
			Bind.addBinding(this, "container.width", this, "displayWidth");
			Bind.addBinding(this, "container.height", this, "displayHeight");
			container = new Container();
		}
		
		[Bindable(event="containerChange")]
		public function get container():Container
		{
			return _container;
		}
		public function set container(value:Container):void
		{
			if (_container == value) {
				return;
			}
			
			if (_container != null) {
				removeChild(_container);
			}
			
			_container = PropertyEvent.change(this, "container", _container, value);
			_container.freeform = true;
			clipRect.target = _container;
			
			if (_container != null) {
				addChild(_container);
			}
			PropertyEvent.dispatch(this);
		}
		
		override public function get children():IList
		{
			return _container == null ? null : _container.children;
		}
		override public function set children(value:*):void
		{
			if (_container == null) {
				return;
			}
			_container.children = value;
		}
		
	}
}