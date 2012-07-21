import flash.events.MouseEvent;

import reflex.display.IDisplayHelper;

private var _x:Number = 0;
private var _y:Number = 0;
private var _scaleX:Number = 1;
private var _scaleY:Number = 1;

public var filters:Object; // todo: ?
public var mask:Object; // todo: ?

private var _visible:Boolean = true;
private var _enabled:Boolean = true;


[Bindable(event="enabledChange")]
public function get enabled():Boolean { return _enabled; }
public function set enabled(value:Boolean):void {
	if(display) { display.mouseEnabled = value; }
	notify("enabled", _enabled, _enabled = value);
}

[Bindable(event="xChange")]
public function get x():Number { return _x; } // needed for display == null, but doesn't respect transform/matrix changes ???
public function set x(value:Number):void {
	if(display) { display.x = value; }
	notify("x", _x, _x = value);
}

[Bindable(event="yChange")]
public function get y():Number { return _y; }
public function set y(value:Number):void {
	if(display) { display.y = value; }
	notify("y", _y, _y = value);
}

[Bindable(event="scaleXChange")]
public function get scaleX():Number { return _scaleX; }
public function set scaleX(value:Number):void {
	if(display) { display.scaleX = value; }
	notify("scaleX", _scaleX, _scaleX = value);
}

[Bindable(event="scaleYChange")]
public function get scaleY():Number { return _scaleY; }
public function set scaleY(value:Number):void {
	if(display) { display.scaleY = value; }
	notify("scaleY", _scaleY, _scaleY = value);
}

[Bindable(event="visibleChange")]
public function get visible():Boolean { return _visible; }
public function set visible(value:Boolean):void {
	if(display) { display.visible = value; }
	notify("visible", _visible, _visible = value);
}

private var _display:Object;// = new Sprite();
public function get display():Object { return _display; }
public function set display(value:Object):void {
	if(_display is IEventDispatcher) {
		(_display as IEventDispatcher).removeEventListener(MouseEvent.MOUSE_OVER, eventRepeater, false);
		(_display as IEventDispatcher).removeEventListener(MouseEvent.MOUSE_OUT, eventRepeater, false);
		(_display as IEventDispatcher).removeEventListener(MouseEvent.MOUSE_UP, eventRepeater, false);
		(_display as IEventDispatcher).removeEventListener(MouseEvent.MOUSE_DOWN, eventRepeater, false);
		(_display as IEventDispatcher).removeEventListener(MouseEvent.CLICK, eventRepeater, false);
		(_display as IEventDispatcher).removeEventListener(LifeCycle.INITIALIZE, eventRepeater, false);
		(_display as IEventDispatcher).removeEventListener(LifeCycle.INVALIDATE, eventRepeater, false);
		(_display as IEventDispatcher).removeEventListener(LifeCycle.MEASURE, eventRepeater, false);
		(_display as IEventDispatcher).removeEventListener(LifeCycle.LAYOUT, eventRepeater, false);
	}
	_display = value;
	if(_display is IEventDispatcher) {
		(_display as IEventDispatcher).addEventListener(MouseEvent.MOUSE_OVER, eventRepeater, false, 0, true);
		(_display as IEventDispatcher).addEventListener(MouseEvent.MOUSE_OUT, eventRepeater, false, 0, true);
		(_display as IEventDispatcher).addEventListener(MouseEvent.MOUSE_UP, eventRepeater, false, 0, true);
		(_display as IEventDispatcher).addEventListener(MouseEvent.MOUSE_DOWN, eventRepeater, false, 0, true);
		(_display as IEventDispatcher).addEventListener(MouseEvent.CLICK, eventRepeater, false, 0, true);
		(_display as IEventDispatcher).addEventListener(LifeCycle.INITIALIZE, eventRepeater, false, 0, true);
		(_display as IEventDispatcher).addEventListener(LifeCycle.INVALIDATE, eventRepeater, false, 0, true);
		(_display as IEventDispatcher).addEventListener(LifeCycle.MEASURE, eventRepeater, false, 0, true);
		(_display as IEventDispatcher).addEventListener(LifeCycle.LAYOUT, eventRepeater, false, 0, true);
	}
	if(_display) {
		_display.x = _x;
		_display.y = _y;
		_display.scaleX = _scaleX;
		_display.scaleY = _scaleY;
		_display.visible = _visible;
	}
}

private var _helper:IDisplayHelper;// = new FlashDisplayHelper();
public function get helper():IDisplayHelper { return _helper; }
public function set helper(value:IDisplayHelper):void {
	_helper = value;
}

private function eventRepeater(event:Event):void {
	this.dispatchEvent(event);
}