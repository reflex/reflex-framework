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
	
	import reflex.injection.HardCodedInjector;
	import reflex.injection.IReflexInjector;
	import reflex.invalidation.Invalidation;
	import reflex.invalidation.LifeCycle;
	import reflex.layouts.BasicLayout;
	
	
	//[Frame(factoryClass="reflex.tools.flashbuilder.ReflexApplicationLoader")]
	[SWF(widthPercent="100%", heightPercent="100%", frameRate="30")]
	[DefaultProperty("content")]
	/**
	 * @alpha
	 */
	public class Application extends Sprite
	{
		
		private var container:Container;
		
		private var _content:Object;
		
		public function get content():Object { return _content; }
		public function set content(value:Object):void {
			_content = value;
			container.content = value;
		}
		
		private var _backgroundColor:uint;
		
		// the compiler knows to look for this, so we don't really draw anything for it
		[Bindable(event="backgroundColorChange")]
		public function get backgroundColor():uint { return _backgroundColor; }
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
			//notify("backgroundColor", _backgroundColor, _backgroundColor = value);
		}
		
		//public var viewSourceURL:String;
		
		public var owner:Object = null;
		
		public function Application()
		{
			super();
			container = new Container();
			this.addChild(container.display as DisplayObject);
			if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
		}

        private function init(e:Event = null):void {
			// Application is the only Reflex thing not in a container
			
			
			var contextMenu:ContextMenu = new ContextMenu();
			/*if(viewSourceURL != null && viewSourceURL != "") {
				var viewSourceCMI:ContextMenuItem = new ContextMenuItem("View Source", true);
				viewSourceCMI.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
				contextMenu.customItems.push(viewSourceCMI);
			}*/
			contextMenu.hideBuiltInItems();
			this.contextMenu = contextMenu;

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			
            onInit()
			onStageResize(null);
        }

        protected function onInit():void {
            //OVERRIDE FOR STAGE ENABLED SETUP
			Invalidation.stage = this.stage;
			var injector:IReflexInjector = new HardCodedInjector(); // only instantiating in Application
			injector.injectInto(container);
			container.layout = new BasicLayout();
        }
		
		private function onStageResize(event:Event):void
		{
			container.width = stage.stageWidth;
			container.height = stage.stageHeight;
			//if(isNaN(explicit.width)) { unscaledWidth = stage.stageWidth; }
			//if(isNaN(explicit.height)) { unscaledHeight = stage.stageHeight; }
			//invalidation.invalidate(this, LifeCycle.LAYOUT);
		}
		
		public function onMeasure(event:Event):void {
			// no measurement in Application
			// the compiler gives us root styles like this. yay?
			/*
			if(container.styleDeclaration.defaultFactory != null) {
				var f:Function = container.styleDeclaration.defaultFactory;
				var t:* = f.apply(style);
				container.styleDeclaration.defaultFactory = null
			}*/
		}
		/*
		override public function setSize(width:Number, height:Number):void {
			// no measurement in application
		}
		*/
		/*
		private function menuItemSelectHandler(event:ContextMenuEvent):void {
			var request:URLRequest = new URLRequest(viewSourceURL);
			navigateToURL(request, "_blank");
		}
		*/
	}
}