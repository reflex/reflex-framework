package reflex.containers
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mx.collections.IList;
	import mx.core.mx_internal;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.graphics.IFill;
	import mx.states.IOverride;
	import mx.states.State;
	
	import reflex.animation.AnimationToken;
	import reflex.animation.AnimationType;
	import reflex.animation.Animator;
	import reflex.animation.IAnimator;
	import reflex.collections.SimpleCollection;
	import reflex.collections.convertToIList;
	import reflex.components.Component;
	import reflex.data.IPosition;
	import reflex.display.FlashDisplayHelper;
	import reflex.display.IDisplayHelper;
	import reflex.display.MeasurableItem;
	import reflex.display.StatefulItem;
	import reflex.events.ContainerEvent;
	import reflex.framework.IDataContainer;
	import reflex.framework.IStateful;
	import reflex.injection.IReflexInjector;
	import reflex.invalidation.IReflexInvalidation;
	import reflex.invalidation.LifeCycle;
	import reflex.layouts.BasicLayout;
	import reflex.layouts.ILayout;
	import reflex.states.applyState;
	import reflex.states.removeState;
	import reflex.templating.getDataRenderer;
	
	//use namespace mx_internal;
	
	[Style(name="left")]
	[Style(name="right")]
	[Style(name="top")]
	[Style(name="bottom")]
	[Style(name="horizontalCenter")]
	[Style(name="verticalCenter")]
	[Style(name="dock")]
	//[Style(name="align")]
	
	[Event(name="initialize", type="flash.events.Event")]
	[Event(name="create", type="flash.events.Event")]
	
	[DefaultProperty("content")]
	
	/**
	 * Container is a cornerstone class of Reflex. 
	 * Anything that holds anything extends this (though it's never referenced concretely in the framework).
	 * It delegates item renderers, layout and dependency injection among other things.
	 * As such, it doesn't do too much internally besides provide coordination of the multiple systems.
	 * @alpha
	 */
	public class Container extends StatefulItem implements IDataContainer
	{
		
		private var _layout:ILayout;
		private var _template:Object;
		private var templateChanged:Boolean;
		
		private var _content:IList; // a mix of data and/or Reflex Components
		private var contentChanged:Boolean;
		private var layoutChanged:Boolean;
		
		private var _fill:IFill;
		private var fillChanged:Boolean;
		
		private var renderers:Array = []; // just reflex components
		private var itemRenderers:Dictionary = new Dictionary(true);
		private var rendererItems:Dictionary = new Dictionary(true);
		private var animationType:String = AnimationType.GENERIC; // generic, add, remove, reset, layout, resize, drag, scroll ... ?
		
		public function getItemForRenderer(renderer:Object):* {
			return rendererItems[renderer];
		}
		
		public function getRendererForItem(item:*):Object {
			return itemRenderers[item];
		}
		
		public function getRenderers():Array { return renderers.concat(); }
		
		private var _animator:IAnimator;//= new Animator();
		public function get animator():IAnimator { return _animator; }
		public function set animator(value:IAnimator):void {
			_animator = value;
		}
		
		
		private var _injector:IReflexInjector;// = new HardCodedInjector();
		public function get injector():IReflexInjector { return _injector; }
		public function set injector(value:IReflexInjector):void {
			_injector = value;
		}
		
		private var _horizontal:IPosition; [Bindable(event="horizontalChange")]
		public function get horizontal():IPosition { return _horizontal; }
		public function set horizontal(value:IPosition):void {
			if(_horizontal is IEventDispatcher) {
				(_horizontal as IEventDispatcher).removeEventListener("valueChange", positionChangeHandler);
			}
			notify("horizontal", _horizontal, _horizontal = value);
			if(_horizontal is IEventDispatcher) {
				(_horizontal as IEventDispatcher).addEventListener("valueChange", positionChangeHandler);
			}
		}
		
		private var _vertical:IPosition; [Bindable(event="verticalChange")]
		public function get vertical():IPosition { return _vertical; }
		public function set vertical(value:IPosition):void {
			if(_vertical is IEventDispatcher) {
				(_vertical as IEventDispatcher).removeEventListener("valueChange", positionChangeHandler);
			}
			notify("vertical", _vertical, _vertical = value);
			if(_vertical is IEventDispatcher) {
				(_vertical as IEventDispatcher).addEventListener("valueChange", positionChangeHandler);
			}
		}
		
		private function positionChangeHandler(event:Event):void {
			//trace(vertical.value);
			//this.display.y = vertical.value;
			animationType = AnimationType.SCROLL;
			onLayout(null); // skip render event
			//this.invalidate(LifeCycle.LAYOUT);
		}
		
		[Bindable(event="fillChange")]
		public function get fill():IFill { return _fill; }
		public function set fill(value:IFill):void {
			fillChanged = true;
			notify("fill", _fill, _fill = value);
			invalidate(LifeCycle.INVALIDATE);
		}
		
		
		
		/**
		 * @inheritDoc
		 */
		[ArrayElementType("Object")]
		[Bindable(event="contentChange")]
		public function get content():IList { return _content; }
		public function set content(value:*):void
		{
			if (_content == value) {
				return;
			}
			
			var oldContent:IList = _content;
			
			if (_content) {
				_content.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onChildrenChange);
				removeItems(_content.toArray(), 0);
			}
			_content = reflex.collections.convertToIList(value);
			if (_content) {
				_content.addEventListener(CollectionEvent.COLLECTION_CHANGE, onChildrenChange);
			}
			contentChanged = true;
			animationType = AnimationType.RESET;
			invalidate(LifeCycle.INVALIDATE);
			invalidate(LifeCycle.MEASURE);
			invalidate(LifeCycle.LAYOUT);
			notify("content", oldContent, _content);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="layoutChange")]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void {
			if (_layout == value) {
				return;
			}
			var oldLayout:ILayout = _layout;
			if (_layout) { _layout.target = null; }
			_layout = value;
			if (_layout) { _layout.target = this; }
			layoutChanged = true;
			animationType = AnimationType.LAYOUT;
			invalidate(LifeCycle.MEASURE);
			invalidate(LifeCycle.LAYOUT);
			notify("layout", oldLayout, _layout);
		}
		
		[Bindable(event="templateChange")]
		public function get template():Object { return _template; }
		public function set template(value:Object):void {
			if (_template == value) {
				return;
			}
			var oldTemplate:Object = _template;
			_template = value;
			templateChanged = true;
			animationType = AnimationType.RESET;
			invalidate(LifeCycle.MEASURE);
			invalidate(LifeCycle.LAYOUT);
			notify("template", oldTemplate, _template);
		}
		
		override public function setSize(width:Number, height:Number):void {
			super.setSize(width, height);
			animationType = AnimationType.RESIZE;
			invalidate(LifeCycle.LAYOUT);
		}
		
		override protected function commit(event:Event):void {
			super.commit(event);
			if(contentChanged || templateChanged) {
				reset(_content ? _content.toArray() : []);
				contentChanged = false;
				templateChanged = false;
			}
			if(fillChanged) {
				drawBackground();
				fillChanged = false;
			}
		}
		
		override protected function onMeasure(event:Event):void {
			super.onMeasure(event);
			// the compiler gives us root styles like this. yay?
			if(styleDeclaration.defaultFactory != null) {
				var f:Function = styleDeclaration.defaultFactory;
				var t:* = f.apply(style);
				styleDeclaration.defaultFactory = null
			}
			if ((isNaN(explicitWidth) || isNaN(explicitHeight)) 
				//|| (isNaN(percentWidth) || isNaN(percentHeight))
				&& layout) {
				var point:Point = layout.measure(renderers);
				if (point.x != measuredWidth || point.y != measuredHeight) {
					_measuredWidth = point.x;
					_measuredHeight = point.y;
				}
			}
		}
		
		override protected function onLayout(event:Event):void {
			super.onLayout(event);
			if (layout) {
				var rectangle:Rectangle = new Rectangle(0, 0, unscaledWidth, unscaledHeight);
				var tokens:Array = layout.update(_content ? _content.toArray() : [], generateTokens(), rectangle);
				animateToTokens(renderers, tokens);
			}
			drawBackground();
		}
		
		private function drawBackground():void {
			if(fill && display && display.graphics) {
				var g:Graphics = display.graphics;
				g.clear();
				fill.begin(g, new Rectangle(0, 0, unscaledWidth, unscaledHeight), new Point());
				g.drawRect(0, 0, unscaledWidth, unscaledHeight);
				fill.end(g);
			}
		}
		
		private function generateTokens():Array {
			// we'll want to pool these tokens later
			var tokens:Array = [];
			var length:int = renderers ? renderers.length : 0;
			for( var i:int = 0; i < length; i++) {
				var renderer:Object = renderers[i];
				var token:AnimationToken = animator.createAnimationToken(renderer);
				tokens.push(token);
			}
			return tokens;
		}
		
		private function animateToTokens(renderers:Array, tokens:Array):void {
			animator.begin();
			var length:int = renderers ? renderers.length : 0;
			for( var i:int = 0; i < length; i++) {
				var renderer:Object = renderers[i];
				var token:AnimationToken = tokens[i];
				//if(layoutChanged) {
					//animator.addItem(renderer, token);
				//} else {
					animator.moveItem(renderer, token, animationType);
				//}
			}
			animator.end();
			layoutChanged = false;
			animationType = AnimationType.GENERIC;
		}
		
		private function onChildrenChange(event:CollectionEvent):void
		{
			//var child:DisplayObject;
			switch (event.kind) {
				case CollectionEventKind.ADD :
					animationType = AnimationType.ADD;
					addItems(event.items, event.location);
					//invalidate(LifeCycle.MEASURE);
					//invalidate(LifeCycle.LAYOUT);
					break;
				case CollectionEventKind.REMOVE :
					animationType = AnimationType.REMOVE;
					removeItems(event.items, event.oldLocation);
					//invalidate(LifeCycle.MEASURE);
					//invalidate(LifeCycle.LAYOUT);
					break;
				case CollectionEventKind.REPLACE :
					animationType = AnimationType.REPLACE;
					helper.removeChild(display, event.items[1]);
					//addChildAt(event.items[0], loc);
					//invalidate(LifeCycle.MEASURE);
					//invalidate(LifeCycle.LAYOUT);
					break;
				case CollectionEventKind.RESET :
				default:
					animationType = AnimationType.RESET;
					reset(event.items);
					//invalidate(LifeCycle.MEASURE);
					//invalidate(LifeCycle.LAYOUT);
					break;
			}
			invalidate(LifeCycle.MEASURE);
			invalidate(LifeCycle.LAYOUT);
		}
		
		private function reset(items:Array):void {
			removeItems(items, 0);
			//renderers = [];
			addItems(items, 0);
		}
		
		private function addItems(items:Array, index:int):void {
			var length:int = items ? items.length : 0;
			for(var i:int = 0; i < length; i++) {
				var item:Object = items[i];
				var renderer:Object = reflex.templating.getDataRenderer(display, item, _template);
				if(renderer is Component) { // need to make this generic
					(renderer as Component).owner = this;
				}
				if(injector) { injector.injectInto(renderer); }
				
				// renderer is actually not a DisplayObject now
				helper.addChild(display, renderer);
				//renderers.push(renderer);
				renderers.splice(index+i, 0, renderer);
				
				itemRenderers[item] = renderer;
				rendererItems[renderer] = item;
				
				dispatchEvent(new ContainerEvent(ContainerEvent.ITEM_ADDED, item, renderer));
			}
		}
		
		private function removeItems(items:Array, index:int):void {
			/*
			while (helper.getNumChildren(display)) {
			var child:Object = helper.removeChildAt(display, helper.getNumChildren(display)-1);
			if(child is Component) { // need to make this generic
			(child as Component).owner = null;
			}
			}
			*/
			
			// this isn't working with templating yet
			//var child:Object;
			for each (var item:Object in items) {
				
				var renderer:Object = itemRenderers[item];
				if(renderer is Component) { // need to make this generic
					(renderer as Component).owner = null;
				}
				//var renderer:Object = renderers.splice(index, 1)[0];
				if(helper.contains(display, renderer)) {
					helper.removeChild(display, renderer);
				}
			}
		}
		
	}
}