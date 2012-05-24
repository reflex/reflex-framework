package reflex.containers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.IList;
	import mx.core.mx_internal;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.states.IOverride;
	import mx.states.State;
	
	import reflex.animation.AnimationToken;
	import reflex.animation.Animator;
	import reflex.animation.IAnimator;
	import reflex.collections.SimpleCollection;
	import reflex.collections.convertToIList;
	import reflex.components.Component;
	import reflex.components.IStateful;
	import reflex.display.FlashDisplayHelper;
	import reflex.display.IDisplayHelper;
	import reflex.display.MeasurableItem;
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
	public class Container extends MeasurableItem implements IContainer, IStateful
	{
		
		private var _layout:ILayout;
		private var _template:Object;
		private var templateChanged:Boolean;
		
		private var _content:IList; // a mix of data and/or Reflex Components
		private var contentChanged:Boolean;
		
		private var renderers:Array; // just reflex components
		
		private var _states:Array;
		private var _transitions:Array;
		private var _currentState:String;
		
		
		private var animator:IAnimator = new Animator();
		
		
		
		private var _injector:IReflexInjector;// = new HardCodedInjector();
		public function get injector():IReflexInjector { return _injector; }
		public function set injector(value:IReflexInjector):void {
			_injector = value;
		}
		
		public function getRenderers():Array { return renderers.concat(); }
		
		
		
		// IStateful implementation
		
		[Bindable(event="statesChange")]
		public function get states():Array { return _states; }
		public function set states(value:Array):void {
			notify("states", _states, _states = value);
		}
		
		[Bindable(event="transitionsChange")]
		public function get transitions():Array { return _transitions; }
		public function set transitions(value:Array):void {
			notify("transitions", _transitions, _transitions = value);
		}
		
		[Bindable(event="currentStateChange")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void {
			if (_currentState == value) {
				return;
			}
			// might need to add invalidation for this later
			reflex.states.removeState(this, _currentState, states);
			notify("currentState", _currentState, _currentState = value);
			reflex.states.applyState(this, _currentState, states);
		}
		
		public function hasState(state:String):Boolean {
			for each(var s:Object in states) {
				if(s.name == state) {
					return true;
				}
			}
			return false;
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
				renderers = [];
			}
			_content = reflex.collections.convertToIList(value);
			if (_content) {
				_content.addEventListener(CollectionEvent.COLLECTION_CHANGE, onChildrenChange);
			}
			contentChanged = true;
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
			invalidate(LifeCycle.MEASURE);
			invalidate(LifeCycle.LAYOUT);
			notify("template", oldTemplate, _template);
		}
		
		override public function setSize(width:Number, height:Number):void {
			super.setSize(width, height);
			invalidate(LifeCycle.LAYOUT);
		}
		
		override protected function commit(event:Event):void {
			super.commit(event);
			if(contentChanged || templateChanged) {
				reset(_content ? _content.toArray() : []);
				contentChanged = false;
				templateChanged = false;
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
				var tokens:Array = layout.update(_content.toArray(), generateTokens(), rectangle);
				animateToTokens(renderers, tokens);
			}
		}
		
		private function generateTokens():Array {
			// we'll want to pool these tokens later
			var tokens:Array = [];
			var length:int = renderers ? renderers.length : 0;
			for( var i:int = 0; i < length; i++) {
				var renderer:Object = renderers[i];
				var token:AnimationToken = new AnimationToken(renderer.x, renderer.y, renderer.width, renderer.height);
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
				animator.moveItem(renderer, token);
			}
			animator.end();
		}
		
		private function onChildrenChange(event:CollectionEvent):void
		{
			var child:DisplayObject;
			var loc:int = event.location;
			switch (event.kind) {
				//case ListEventKind.ADD :
				case CollectionEventKind.ADD :
					add(event.items, loc);
					break;
				case CollectionEventKind.REMOVE :
					remove(event.items, event.oldLocation);
					break;
				case CollectionEventKind.REPLACE :
					helper.removeChild(display, event.items[1]);
					//addChildAt(event.items[0], loc);
					break;
				case CollectionEventKind.RESET :
				default:
					reset(event.items);
					break;
			}
			invalidate(LifeCycle.LAYOUT);
		}
		
		private function add(items:Array, index:int):void {
			// move this to helper
			//var children:Array = reflex.templating.addItemsAt(display, items, index, _template);
			
			var length:int = items ? items.length : 0;
			for(var i:int = 0; i < length; i++) {
				var item:Object = items[i];
				var renderer:Object = reflex.templating.getDataRenderer(display, item, _template);//children[i];
				if(renderer is Component) { // need to make this generic
					(renderer as Component).owner = this;
				}
				if(injector) { injector.injectInto(renderer); }
				helper.addChild(display, renderer.display);
				renderers.splice(index+i, 0, renderer);
				
			}
			
			invalidate(LifeCycle.MEASURE);
			invalidate(LifeCycle.LAYOUT);
		}
		
		private function remove(items:Array, index:int):void {
			// this isn't working with templating yet
			var child:Object;
			for each (child in items) {
				if(child is Component) { // need to make this generic
					(child as Component).owner = null;
				}
				//var index:int = content.getItemIndex(child); //renderers.indexOf(child);
				var renderer:Object = renderers.splice(index, 1)[0];
				if((renderer is DisplayObject) 
					&& helper.contains(display, renderer as DisplayObject)) {
					helper.removeChild(display, renderer as DisplayObject);
				}
			}
			invalidate(LifeCycle.MEASURE);
			invalidate(LifeCycle.LAYOUT);
		}
		
		private function reset(items:Array):void {
			
			while (helper.getNumChildren(display)) {
				var child:Object = helper.removeChildAt(display, helper.getNumChildren(display)-1);
				if(child is Component) { // need to make this generic
					(child as Component).owner = null;
				}
			}
			
			renderers = [];
			var length:int = items ? items.length : 0;
			for(var i:int = 0; i < length; i++) {
				var item:Object = items[i];
				var renderer:Object = reflex.templating.getDataRenderer(display, item, template);
				if(renderer is Component) { // need to make this generic
					(renderer as Component).owner = this;
				}
				if(injector) { injector.injectInto(renderer); }
				
				// renderer is actually not a DisplayObject now
				helper.addChild(display, renderer.display);
				renderers.push(renderer);
			}
			
			invalidate(LifeCycle.LAYOUT);
		}
		
		
	}
}