/*
* From the Stealth SDK, a UI framework for the Flash Developer.
* Copyright (c) 2011 Tyler Wright - Flight XD.
* Permission is hereby granted to use, modify, and distribute this file
* in accordance with the terms of the license agreement accompanying it.
*/

package reflex.invalidation
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Interval extends Timer
	{
		private static const display:DisplayObject = new Shape();
		
		public static const global:Interval = new Interval();
		global.start();
		
		public function Interval(timelineSynced:Boolean = true)
		{
			super(1000 / 60);
			this.timelineSynced = timelineSynced;
		}
		
		override public function get running():Boolean { return _timelineSynced ? _running : super.running; }
		private var _running:Boolean;
		
		override public function get currentCount():int { return _timelineSynced ? _currentCount : super.currentCount; }
		private var _currentCount:int = 0;
		
		override public function set repeatCount(value:int):void
		{
			super.repeatCount = value;
			if (_timelineSynced && super.repeatCount != 0 && super.repeatCount <= currentCount) {
				stop();
				dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
			}
		}
		
		public function get timelineSynced():Boolean { return _timelineSynced; }
		public function set timelineSynced(value:Boolean):void
		{
			stop();
			_timelineSynced = value;
			start();
		}
		private var _timelineSynced:Boolean;
		
		override public function reset():void
		{
			if (_timelineSynced) {
				stop();
				_currentCount = 0;
			} else {
				super.reset();
			}
		}
		
		override public function start():void
		{
			if (repeatCount != 0 && repeatCount <= currentCount) {
				return;
			}
			
			if (_timelineSynced) {
				display.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				_running = true;
			} else {
				addEventListener(TimerEvent.TIMER, onTimer, false, -10);
				super.start();
			}
		}
		
		override public function stop():void
		{
			if (_timelineSynced) {
				display.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_running = false;
			} else {
				removeEventListener(TimerEvent.TIMER, onTimer);
				super.stop();
			}
		}
		
		private function onEnterFrame(event:Event):void
		{
			_currentCount++;
			dispatchEvent(new TimerEvent(TimerEvent.TIMER));
			if (repeatCount != 0 && repeatCount <= currentCount) {
				stop();
				dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
			}
		}
		
		private function onTimer(event:TimerEvent):void
		{
			event.updateAfterEvent();
		}
	}
}