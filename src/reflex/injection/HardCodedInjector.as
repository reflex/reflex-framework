package reflex.injection
{
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import reflex.animation.Animator;
	import reflex.animation.IAnimator;
	import reflex.behaviors.ButtonBehavior;
	import reflex.behaviors.SelectBehavior;
	import reflex.binding.Bind;
	import reflex.collections.SimpleCollection;
	import reflex.components.Button;
	import reflex.components.Component;
	import reflex.components.List;
	import reflex.components.ListItem;
	import reflex.components.Scroller;
	import reflex.containers.Application;
	import reflex.containers.Container;
	import reflex.containers.Group;
	import reflex.containers.HGroup;
	import reflex.containers.IContainer;
	import reflex.containers.VGroup;
	import reflex.data.Position;
	import reflex.display.FlashDisplayHelper;
	import reflex.display.IDisplayHelper;
	import reflex.display.MeasurableItem;
	import reflex.display.StyleableItem;
	import reflex.graphics.BitmapImage;
	import reflex.invalidation.IReflexInvalidation;
	import reflex.invalidation.Invalidation;
	import reflex.invalidation.LifeCycle;
	import reflex.layouts.BasicLayout;
	import reflex.layouts.HorizontalLayout;
	import reflex.layouts.VerticalLayout;
	import reflex.skins.ButtonSkin;
	import reflex.skins.ListItemSkin;
	import reflex.skins.ListSkin;
	import reflex.skins.ScrollerSkin;
	import reflex.skins.Skin;
	
	/**
	 * Default Injector is hard coded right now.
	 * - the idea is that we can create a more dynamic injector later
	 * - and allow devs to wrap their favorite 3rd party injector using the interface
	 **/
	public class HardCodedInjector implements IReflexInjector
	{
		
		private var invalidation:Invalidation = new Invalidation();
		private var animator:IAnimator = new Animator();
		private var helper:IDisplayHelper = new FlashDisplayHelper();
		
		public function initialize(stage:Stage, app:IEventDispatcher):void {
			invalidation.stage = stage;
			invalidation.app = app;
			invalidation.registerPhase(LifeCycle.INITIALIZE, Event, 400, false);
			invalidation.registerPhase(LifeCycle.COMMIT, Event, 300, false);
			invalidation.registerPhase(LifeCycle.MEASURE, Event, 200, true);
			invalidation.registerPhase(LifeCycle.LAYOUT, Event, 100, false);
		}
		
		public function injectInto(instance:Object):void {
			// move concrete references out? - later
			// inject on metadata? - later
			// 3rd party injection? - later
			
			if(instance is Container ||
				instance is Component) {
				if(instance.injector == null) { instance.injector = this; }
				
			}
			
			if(instance is Container) {
				if(instance.animator == null) { instance.animator = animator; }
			}
			
			if(instance is StyleableItem) {
				if(instance.helper == null) { instance.helper = helper; }
			}
			
			if(instance is MeasurableItem) {
				if(instance.invalidation == null) { instance.invalidation = invalidation; }
			}
			/*
			if(instance is BitmapImage) {
				if(instance.display == null) { instance.display = new Bitmap(); }
			}
			*/
			if((instance is MeasurableItem && !(instance is Skin)) || instance is Component) { // skins are assigned the target display
				if(instance.display == null) { instance.display = new Sprite(); }
			}
			
			if(instance is Container) {
				if(instance.content == null) { instance.content = new SimpleCollection(); }
				if(instance.horizontal == null) { instance.horizontal = new Position(); }
				if(instance.vertical == null) { instance.vertical = new Position(); }
			}
			
			if(instance is Component) {
				if(instance.behaviors == null) { instance.behaviors = new SimpleCollection(); }
			}
			
			// constructor replacement
			/*
			if(Object(instance).constructor == Scroller) {
				instance.layout = new BasicLayout();
				instance.skin = new ScrollerSkin();
			}
			
			if(Object(instance).constructor == List) {
				instance.skin = new ListSkin();
			}
			*/
			
			// default component definitions
			
			if(Object(instance).constructor == ListItem) {
				if(instance.skin == null) { instance.skin = new ListItemSkin(); }
				instance.behaviors.addItem(new ButtonBehavior(instance as IEventDispatcher));
				instance.behaviors.addItem(new SelectBehavior(instance as IEventDispatcher));
			}
			
			if(Object(instance).constructor == Button) {
				if(instance.skin == null) { instance.skin = new ButtonSkin(); }
				instance.behaviors.addItem(new ButtonBehavior(instance as IEventDispatcher));
			}
			
			
			//if(Object(instance).constructor == Group) {
			if(instance is Group) {
				if(instance.layout == null) { instance.layout = new BasicLayout(); }
			}
			//if(Object(instance).constructor == HGroup) {
			if(instance is HGroup) {
				if(instance.layout == null) { instance.layout = new HorizontalLayout(); }
			}
			//if(Object(instance).constructor == VGroup) {
			if(instance is VGroup) {
				if(instance.layout == null) { instance.layout = new VerticalLayout(); }
			}
			
			instance.dispatchEvent(new Event(LifeCycle.INITIALIZE));
			
		}
		
	}
}