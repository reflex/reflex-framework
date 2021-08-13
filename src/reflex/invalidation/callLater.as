/*
* From the Stealth SDK, a UI framework for the Flash Developer.
* Copyright (c) 2011 Tyler Wright - Flight XD.
* Permission is hereby granted to use, modify, and distribute this file
* in accordance with the terms of the license agreement accompanying it.
*/

package reflex.invalidation
{
	import flash.events.TimerEvent;
	
	public function callLater(method:Function, ticks:uint = 1, ...args):void
	{
		if (!ticks) {
			method.apply(null, args);
			return;
		}
		
		calls[method] = args;
		calls[method].ticks = ticks;
		
		if (!enabled) {
			enabled = true;
			Interval.global.addEventListener(TimerEvent.TIMER, callNow);
		}
	}
}

import flash.events.TimerEvent;
import flash.utils.Dictionary;

import reflex.invalidation.Interval;

internal var enabled:Boolean;
internal var calls:Dictionary = new Dictionary();
internal var callsEmpty:Dictionary = new Dictionary();

internal function callNow(event:TimerEvent):void
{
	var callsNow:Dictionary = calls;
	calls = callsEmpty;
	callsEmpty = callsNow;
	
	enabled = false;
	for (var method:Object in callsNow) {
		
		if (--callsNow[method].ticks) {
			enabled = true;
			calls[method] = callsNow[method];
		} else {
			method.apply(null, callsNow[method]);
		}
		delete callsNow[method];
	}
	
	if (!enabled) {
		Interval.global.removeEventListener(TimerEvent.TIMER, callNow);
	}
}