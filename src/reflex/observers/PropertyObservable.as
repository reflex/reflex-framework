package reflex.observers
{
	public final class PropertyObservable implements IPropertyObservable
	{
		private var target:IPropertyObservable;
		private var observers:Array = [];
		
		public function PropertyObservable(target:IPropertyObservable = null):void
		{
			this.target = target || this;
		}
		
		public function addPropertyObserver(observer:IPropertyObserver):void
		{
			if (observers.indexOf(observer) != -1) return;
			observers.push(observer);
		}
		
		public function removePropertyObserver(observer:IPropertyObserver):void
		{
			var index:int = observers.indexOf(observer);
			if (index == -1) return;
			observers.splice(index, 1);
		}
		
		public function changeProperty(name:String, oldValue:*, newValue:*):*
		{
			if (!allowPropertyChange("skin", oldValue, newValue)) return oldValue;
			newValue = propertyChanging("skin", oldValue, newValue);
			if (!allowPropertyChange("skin", oldValue, newValue)) return oldValue;
			propertyChange("skin", oldValue, newValue);
			return newValue;
		}
		
		private function allowPropertyChange(name:String, currentValue:*, newValue:*):Boolean
		{
			for each (var observer:IPropertyObserver in observers) {
				if (!observer.allowPropertyChange(target, name, currentValue, newValue)) {
					return false;
				}
			}
			return true;
		}
		
		private function propertyChanging(name:String, currentValue:*, newValue:*):*
		{
			for each (var observer:IPropertyObserver in observers) {
				var result:* = observer.propertyChanging(target, name, currentValue, newValue);
				if (result !== undefined) newValue = result;
			}
			return newValue;
		}
		
		private function propertyChange(name:String, oldValue:*, newValue:*):void
		{
			for each (var observer:IPropertyObserver in observers) {
				observer.propertyChange(target, name, oldValue, newValue);
			}
		}
	}
}