package reflex.containers
{
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import reflex.binding.DataChange;
	import reflex.invalidation.Invalidation;
	import reflex.layouts.BasicLayout;
	
	
	//[Frame(factoryClass="reflex.tools.flashbuilder.ReflexApplicationLoader")]
	[SWF(widthPercent="100%", heightPercent="100%", frameRate="30")]
	
	/**
	 * @alpha
	 */
	public class Application extends Container
	{
		
		private var _backgroundColor:uint;
		
		// the compiler knows to look for this, so we don't really draw anything for it
		[Bindable(event="backgroundColorChange")]
		public function get backgroundColor():uint { return _backgroundColor; }
		public function set backgroundColor(value:uint):void {
			DataChange.change(this, "backgroundColor", _backgroundColor, _backgroundColor = value);
		}
		
		//public var viewSourceURL:String;
		
		public function Application()
		{
			super();
			layout = new BasicLayout();
			if (stage == null) {
				return;
			}
			
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
			onStageResize(null);
		}
		
		private function onStageResize(event:Event):void
		{
			if(isNaN(explicit.width)) { unscaledWidth = stage.stageWidth; }
			if(isNaN(explicit.height)) { unscaledHeight = stage.stageHeight; }
			Invalidation.invalidate(this, LAYOUT);
		}
		
		override protected function onMeasure(event:Event):void {
			// no measurement in Application
			// the compiler gives us root styles like this. yay?
			if(styleDeclaration.defaultFactory != null) {
				var f:Function = styleDeclaration.defaultFactory;
				var t:* = f.apply(style);
				styleDeclaration.defaultFactory = null
			}
		}
		
		override public function setSize(width:Number, height:Number):void {
			// no measurement in application
		}
		
		/*
		private function menuItemSelectHandler(event:ContextMenuEvent):void {
			var request:URLRequest = new URLRequest(viewSourceURL);
			navigateToURL(request, "_blank");
		}
		*/
	}
}