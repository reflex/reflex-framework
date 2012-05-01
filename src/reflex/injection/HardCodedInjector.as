package reflex.injection
{
	
	import reflex.components.Component;
	import reflex.containers.Application;
	import reflex.containers.Container;
	import reflex.containers.Group;
	import reflex.display.Display;
	import reflex.invalidation.HardCodedInvalidation;
	import reflex.invalidation.IReflexInvalidation;
	import reflex.layouts.BasicLayout;
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
			if(instance is Display /*|| instance is Skin*/) {
				instance.invalidation = invalidation;
			}
			if(instance is Container) {
				instance.injector = this;
			}
			
			
			if(Object(instance).constructor == Group) {
				instance.layout = new BasicLayout();
			}
		}
		
	}
}