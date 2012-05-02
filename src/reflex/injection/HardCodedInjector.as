package reflex.injection
{
	
	import flash.events.IEventDispatcher;
	
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
	import reflex.containers.VGroup;
	import reflex.display.Display;
	import reflex.invalidation.HardCodedInvalidation;
	import reflex.invalidation.IReflexInvalidation;
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
		
		private var invalidation:IReflexInvalidation = new HardCodedInvalidation();
		
		public function injectInto(instance:Object):void {
			// move concrete references out? - later
			// inject on metadata? - later
			// 3rd party injection? - later
			
			if(instance is Container ||
				instance is Component ||
				instance is Skin) {
				if(instance.injector == null) { instance.injector = this; }
			}
			
			if(instance is Display /*|| instance is Skin*/) {
				if(instance.invalidation == null) { instance.invalidation = invalidation; }
			}
			
			
			if(instance is Container) {
				if(instance.content == null) { instance.content = new SimpleCollection(); }
			}
			
			if(instance is Skin) {
				if(instance.content == null) { instance.content = new SimpleCollection(); }
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
			
			
			
			
			if(Object(instance).constructor == Group) {
				instance.layout = new BasicLayout();
			}
			if(Object(instance).constructor == HGroup) {
				instance.layout = new HorizontalLayout();
			}
			if(Object(instance).constructor == VGroup) {
				instance.layout = new VerticalLayout();
			}
		}
		
	}
}