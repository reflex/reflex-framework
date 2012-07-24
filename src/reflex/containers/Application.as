package reflex.containers
{
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.collections.IList;
	import mx.core.IStateClient;
	import mx.core.IStateClient2;
	
	import reflex.framework.IStateful;
	import reflex.injection.IReflexInjector;
	import reflex.invalidation.Interval;
	import reflex.invalidation.Invalidation;
	import reflex.invalidation.LifeCycle;
	import reflex.layouts.BasicLayout;
	
	
	//[Frame(factoryClass="reflex.tools.flashbuilder.ReflexApplicationLoader")]
	[SWF(widthPercent="100%", heightPercent="100%", frameRate="30")]
	[DefaultProperty("content")]
	/**
	 * @alpha
	 */
	public class Application extends Sprite implements IStateful
	{
		
		include "../framework/PropertyDispatcherImplementation.as";
		include "../framework/StatefulImplementation.as";
		
		public var injector:IReflexInjector;
		
		private var _container:Group;
		public function get container():Group { return _container; }
		
		public function get content():IList { return _container ? _container.content : null; }
		public function set content(value:*):void {
			if(_container) {
				_container.content = value;
			}
		}
		
		private var _backgroundColor:uint;
		[Bindable(event="backgroundColorChange")] // the compiler knows to look for this, so we don't really draw anything for it
		public function get backgroundColor():uint { return _backgroundColor; }
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
			//notify("backgroundColor", _backgroundColor, _backgroundColor = value);
		}
		
		public var owner:Object = null;
		
		public function Application()
		{
			super();
			preinitialize();
		}
		
		protected function preinitialize():void {
			_container = new Group();
			_container.display = this;
			if (stage) initialize();
			else addEventListener(Event.ADDED_TO_STAGE, initialize);
			
		}
		
		//private var interval:Interval;
        protected function initialize(e:Event = null):void {
			// Application is the only Reflex thing not in a container
			
			var contextMenu:ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			this.contextMenu = contextMenu;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			_container.owner = owner = this.stage;
			Invalidation.stage = this.stage;
			Invalidation.app = _container;
			//interval = new Interval(true);
			//var injector:IReflexInjector = new C(); // only instantiating in Application
			injector.injectInto(_container);
			//_container.layout = new BasicLayout();
			stage.addChild(this);
			//this.addChild(container.display as DisplayObject);
			onStageResize(null);
        }
		
		private function onStageResize(event:Event):void {
			_container.width = stage.stageWidth;
			_container.height = stage.stageHeight;
		}
		
		
	}
}