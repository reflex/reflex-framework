package reflex.skins
{
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	import reflex.animation.AnimationToken;
	import reflex.animation.Animator;
	import reflex.animation.IAnimator;
	import reflex.binding.Bind;
	import reflex.collections.SimpleCollection;
	import reflex.collections.convertToIList;
	import reflex.components.IStateful;
	import reflex.containers.Container;
	import reflex.containers.IContainer;
	import reflex.display.FlashDisplayHelper;
	import reflex.display.IDisplayHelper;
	import reflex.display.PropertyDispatcher;
	import reflex.injection.HardCodedInjector;
	import reflex.injection.IReflexInjector;
	import reflex.invalidation.IReflexInvalidation;
	import reflex.invalidation.LifeCycle;
	import reflex.layouts.BasicLayout;
	import reflex.layouts.ILayout;
	import reflex.measurement.IMeasurable;
	import reflex.measurement.IMeasurablePercent;
	import reflex.measurement.IMeasurements;
	import reflex.metadata.resolveBindings;
	import reflex.metadata.resolveCommitProperties;
	import reflex.states.applyState;
	import reflex.states.removeState;
	import reflex.templating.getDataRenderer;
	
	/**
	 * Skin is a convenient base class for many skins, a swappable graphical
	 * definition. Skins decorate a target Sprite by drawing on its surface,
	 * adding children to the Sprite, or both.
	 * @alpha
	 */
	[DefaultProperty("content")]
	public class Skin extends Container implements ISkin
	{
		
		
		
		private var _target:IEventDispatcher;
		private var _template:Object;
		private var _content:IList;
		private var _layout:ILayout;
		
		public function Skin()
		{
			super();
			reflex.metadata.resolveBindings(this);
		}
		
		
		[Bindable(event="targetChange")]
		public function get target():IEventDispatcher { return _target; }
		public function set target(value:IEventDispatcher):void
		{
			if (_target == value) {
				return;
			}
			
			var oldValue:Object = _target;
			_target = value;
			if (layout) {
				layout.target = _target;
			}
			
			if (this.hasOwnProperty('hostComponent')) {
				this['hostComponent'] = _target;
			}
			
			if (_target != null) {
				display = (target as Object).display;
				// skin measurement occurs before component measurement
				//target.addEventListener(LifeCycle.MEASURE, onMeasure, false, 1, true);
				//target.addEventListener(LifeCycle.LAYOUT, onLayout, false, 1, true);
				//invalidate(LifeCycle.MEASURE);
				//invalidate(LifeCycle.LAYOUT);
				reflex.metadata.resolveCommitProperties(this);
			}
			
			//var items:Array = content.toArray();
			//reset(items);
			notify("target", oldValue, _target);
		}
		
		
	}
}
