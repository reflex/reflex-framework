package reflex.events
{
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * The ButtonEvent transforms InteractiveObjects into buttons by adding the common
	 * mouse-related events that make up a buttons behavior. The ButtonEvent class is a
	 * unique Event subclass because it is never instantiated and dispatched. Instances of
	 * the ButtonEvent are unused in favor of the standard MouseEvent type in order to
	 * maintain consistency with the native "rollOver" and "rollOut" events. All Button
	 * events are non-bubbling.
	 */
	public class ButtonEvent extends MouseEvent
	{
		/**
		 * Defines the value of the type property of a press event object. The press
		 * event is dispatched when the primary mouse button is pressed.
		 */
		public static const PRESS:String = "press";
		
		/**
		 */
		public static const HOLD:String = "hold";
		
		/**
		 * Defines the value of the type property of a drag event object. The drag
		 * event is dispatched anytime the mouse moves while it is being pressed.
		 */
		public static const DRAG:String = "drag";
		
		/**
		 * Defines the value of the type property of a dragOver event object. The dragOver
		 * event is dispatched when the mouse moves over the target while it is being pressed.
		 */
		public static const DRAG_OVER:String = "dragOver";
		
		/**
		 * Defines the value of the type property of a dragOut event object. The dragOut event
		 * is dispatched when the mouse moves off of the target while it is being pressed.
		 */
		public static const DRAG_OUT:String = "dragOut";
		
		/**
		 * Defines the value of the type property of a release event object. The release
		 * event is dispatched when the primary mouse button is released over the target.
		 */
		public static const RELEASE:String = "release";
		
		/**
		 * Defines the value of the type property of a releaseOutside event object. The releaseOutside
		 * event is dispatched when the primary mouse button is released off of the target.
		 */
		public static const RELEASE_OUTSIDE:String = "releaseOutside";
		
		/**
		 * Defines the value of the type property of a releaseOutside event object. The releaseOutside
		 * event is dispatched when the primary mouse button is released off of the target.
		 */
		public static const STATE_UP:String = "stateUp";
		
		/**
		 * Defines the value of the type property of a releaseOutside event object. The releaseOutside
		 * event is dispatched when the primary mouse button is released off of the target.
		 */
		public static const STATE_OVER:String = "stateOver";
		
		/**
		 * Defines the value of the type property of a releaseOutside event object. The releaseOutside
		 * event is dispatched when the primary mouse button is released off of the target.
		 */
		public static const STATE_DOWN:String = "stateDown";
		
		/**
		 * An index of all button's that are currently effected by a mouse press.
		 * Index values track whether the mouse is over the indexed Button's at any given moment.
		 */
		private static var pressedIndex:Dictionary = new Dictionary(true);
		private static var pressedX:Dictionary = new Dictionary(true);
		private static var pressedY:Dictionary = new Dictionary(true);
		
		private static var DELAY_INTERVAL:int = 300;
		private static var HOLD_INTERVAL:int = 30;
		
		/**
		 * The makeButton static method is the primary method of the ButtonEvent, transforming a
		 * target InteractiveObject into a Button. By adding the ButtonEvent event types any
		 * InteractiveObject may become a Button, including Sprites, TextFields, even the Stage.
		 * 
		 * @param	object				This InteractiveObject will be modified to respond to the
		 * 								mouse with the appropriate Button events.
		 * @param	includeCallbacks	When set to true, any callback methods that are defined will
		 * 								be triggered automatically. A callback method is a method
		 * 								defined on Button with a magic name, the event name, prepended
		 * 								with the prefix "on" (for example "onPress()", "onRelease()",
		 * 								"onStateUp()"). Callbacks have no parameters.
		 * @return	Returns the object that was converted for convenience.
		 */
		public static function initialize(button:IEventDispatcher, includeCallbacks:Boolean = false):IEventDispatcher
		{
			button.addEventListener(MouseEvent.MOUSE_DOWN,	onMouseDown,	false, 0xFF);
			button.addEventListener(MouseEvent.ROLL_OVER,	onRollOver,		false, 0xFF);
			button.addEventListener(MouseEvent.ROLL_OUT,	onRollOut,		false, 0xFF);
			button.addEventListener(MouseEvent.MOUSE_UP,	onMouseUp,		false, 0xFF);
			
			if (includeCallbacks) {
				
				button.addEventListener(MouseEvent.CLICK,			onCallbackEvent);
				button.addEventListener(MouseEvent.DOUBLE_CLICK,	onCallbackEvent);
				button.addEventListener(MouseEvent.ROLL_OVER,		onCallbackEvent);
				button.addEventListener(MouseEvent.ROLL_OUT,		onCallbackEvent);
				button.addEventListener(PRESS,						onCallbackEvent);
				button.addEventListener(DRAG,						onCallbackEvent);
				button.addEventListener(DRAG_OVER,					onCallbackEvent);
				button.addEventListener(DRAG_OUT,					onCallbackEvent);
				button.addEventListener(RELEASE,					onCallbackEvent);
				button.addEventListener(RELEASE_OUTSIDE,			onCallbackEvent);
				button.addEventListener(HOLD,						onCallbackEvent);
				button.addEventListener(STATE_UP,					onCallbackEvent);
				button.addEventListener(STATE_OVER,					onCallbackEvent);
				button.addEventListener(STATE_DOWN,					onCallbackEvent);
			}
			
			return button;
		}
		
		public static function deinitialize(button:InteractiveObject):InteractiveObject
		{
			button.removeEventListener(MouseEvent.MOUSE_DOWN,	onMouseDown);
			button.removeEventListener(MouseEvent.ROLL_OVER,	onRollOver);
			button.removeEventListener(MouseEvent.ROLL_OUT,		onRollOut);
			button.removeEventListener(MouseEvent.MOUSE_UP,		onMouseUp);
			
			button.removeEventListener(MouseEvent.CLICK,		onCallbackEvent);
			button.removeEventListener(MouseEvent.DOUBLE_CLICK,	onCallbackEvent);
			button.removeEventListener(MouseEvent.ROLL_OVER,	onCallbackEvent);
			button.removeEventListener(MouseEvent.ROLL_OUT,		onCallbackEvent);
			button.removeEventListener(PRESS,					onCallbackEvent);
			button.removeEventListener(DRAG,					onCallbackEvent);
			button.removeEventListener(DRAG_OVER,				onCallbackEvent);
			button.removeEventListener(DRAG_OUT,				onCallbackEvent);
			button.removeEventListener(RELEASE,					onCallbackEvent);
			button.removeEventListener(RELEASE_OUTSIDE,			onCallbackEvent);
			button.removeEventListener(HOLD,					onCallbackEvent);
			button.removeEventListener(STATE_UP,				onCallbackEvent);
			button.removeEventListener(STATE_OVER,				onCallbackEvent);
			button.removeEventListener(STATE_DOWN,				onCallbackEvent);
			
			return button;
		}
		
		public var deltaX:Number = 0;
		public var deltaY:Number = 0;
		
		/**
		 * Though the ButtonEvent constructor is defined, ButtonEvents are never instantiated.
		 * All ButtonEvent types are dispatched as MouseEvents.
		 */
		public function ButtonEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false,
									localX:Number = NaN, localY:Number = NaN, relatedObject:InteractiveObject = null,
									ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false,
									buttonDown:Boolean = false, delta:int = 0, deltaX:Number = 0, deltaY:Number = 0)
		{
			super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
			this.deltaX = deltaX;
			this.deltaY = deltaY;
		}
		
		/**
		 * The dispatch process for all ButtonEvent events.
		 */
		private static function dispatchButtonEvent(button:InteractiveObject, type:String, event:MouseEvent = null, mouseEventType:Boolean = false):void
		{
			// performance improvement when dispatch is aborted while there are no listeners
			// note: there are always listeners when including callbacks
			if ( !button.hasEventListener(type) ) {
				return;
			}
			
			var classType:Class = mouseEventType ? MouseEvent : ButtonEvent;
			if (event == null) {
				event = new classType(type, false, false, button.mouseX, button.mouseY, null, false, false, false, pressedIndex[button] != null);
			} else {
				event = new classType(type, false, false, button.mouseX, button.mouseY, event.relatedObject,
									  event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta);
			}
			
			if (!mouseEventType && pressedIndex[button] != null) {
				ButtonEvent(event).deltaX = button.mouseX - pressedX[button];
				ButtonEvent(event).deltaY = button.mouseY - pressedY[button];
			}
			
			button.dispatchEvent(event);
		}
		
		/**
		 * mouseDown event listener. Triggers press and stateDown events and
		 * sets up stage listeners for mouse move and release.
		 */
		private static function onMouseDown(event:MouseEvent):void
		{
			var button:InteractiveObject = event.currentTarget as InteractiveObject;
				button.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				button.stage.addEventListener(MouseEvent.MOUSE_UP, onRelease);
				button.stage.addEventListener(Event.MOUSE_LEAVE, onRelease);
				
			pressedIndex[button] = setTimeout(onHold, DELAY_INTERVAL, button);
			pressedX[button] = button.mouseX;
			pressedY[button] = button.mouseY;
			dispatchButtonEvent(button, PRESS, event);
			dispatchButtonEvent(button, STATE_DOWN, event);
		}
		
		/**
		 * mouseMove event listener. Triggers drag event for all pressed buttons
		 */
		private static function onMouseMove(event:MouseEvent):void
		{
			for (var i:* in pressedIndex) {
				var button:InteractiveObject = i as InteractiveObject;
				dispatchButtonEvent(button, DRAG, event);
			}
		}
		
		/**
		 * rollOver event listener. Triggers dragOver and stateDown events for
		 * pressed buttons and a stateOver event if the mouse isn't pressed.
		 */
		private static function onRollOver(event:MouseEvent):void
		{
			if (event is ButtonEvent) {
				return;
			}
			var button:InteractiveObject = event.currentTarget as InteractiveObject;
			
			if (pressedIndex[button] != null) {
				pressedIndex[button] = setTimeout(onHold, HOLD_INTERVAL, button);
				dispatchButtonEvent(button, DRAG_OVER, event);
				dispatchButtonEvent(button, STATE_DOWN, event);
			} else if (!event.buttonDown) {
				dispatchButtonEvent(button, STATE_OVER, event);
			}
		}
		
		/**
		 * rollOut event listener. Triggers dragOut and stateOver events for
		 * pressed buttons and a stateUp event if the mouse isn't pressed.
		 */
		private static function onRollOut(event:MouseEvent):void
		{
			var button:InteractiveObject = event.currentTarget as InteractiveObject;
			
			if (pressedIndex[button] != null) {
				clearTimeout(pressedIndex[button]);
				pressedIndex[button] = -1;
				dispatchButtonEvent(button, DRAG_OUT, event);
				dispatchButtonEvent(button, STATE_OVER, event);
			} else if (!event.buttonDown) {
				dispatchButtonEvent(button, STATE_UP, event);
			}
		}
		
		/**
		 * mouseUp event listener. Triggers rollOver and stateOver events for
		 * buttons that were not previously being pressed.
		 */
		private static function onMouseUp(event:MouseEvent):void
		{
			var button:InteractiveObject = event.currentTarget as InteractiveObject;
			if (pressedIndex[button] == null) {
				dispatchButtonEvent(button, MouseEvent.ROLL_OVER, event, true);
				dispatchButtonEvent(button, STATE_OVER, event);
			}
		}
		
		/**
		 */
		private static function onHold(button:InteractiveObject):void
		{
			dispatchButtonEvent(button, HOLD);
			pressedIndex[button] = setTimeout(onHold, HOLD_INTERVAL, button);
		}
		
		/**
		 * mouseUp event listener. Triggers release and stateOver events for
		 * buttons that were just pressed and are still under the mouse, and
		 * releaseOutside and stateUp events for buttons that were just pressed
		 * and are no longer under the mouse. Also removes stage listeners for
		 * mouse move and release.
		 */
		private static function onRelease(event:Event):void
		{
			var stage:Stage = event.currentTarget as Stage;
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onRelease);
				stage.removeEventListener(Event.MOUSE_LEAVE, onRelease);
			
			for (var i:* in pressedIndex) {
				var button:InteractiveObject = i as InteractiveObject;
				
				if (pressedIndex[button] != -1) {
					dispatchButtonEvent(button, RELEASE, event as MouseEvent);
					dispatchButtonEvent(button, STATE_OVER, event as MouseEvent);
				} else {
					dispatchButtonEvent(button, RELEASE_OUTSIDE, event as MouseEvent);
					dispatchButtonEvent(button, STATE_UP, event as MouseEvent);
				}
				
				clearTimeout(pressedIndex[button]);
				delete pressedIndex[button];
				delete pressedX[button];
				delete pressedY[button];
			}
		}
		
		/**
		 * Single listener for all callback events. This method is set up to listen
		 * to each ButtonEvent, evaluate if a callback of the appropriate name is
		 * available, and execute the callback. It also causes a screen refresh via
		 * updateAfterEvent after callback execution - this increases the perceived
		 * responsiveness of the button to a user.
		 */
		private static function onCallbackEvent(event:MouseEvent):void
		{
			var button:InteractiveObject = event.currentTarget as InteractiveObject;
			var callback:String = event.type;
			callback = "on" + callback.substr(0, 1).toUpperCase() + callback.substr(1);
			
			if (callback in button) {
				if (button[callback].length == 1) {
					button[callback](event);
				} else {
					button[callback]();
				}
				event.updateAfterEvent();
			}
		}
		
	}
}