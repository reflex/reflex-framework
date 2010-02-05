package reflex.observers
{
	public class CheckSameObserver implements IPropertyObserver
	{
		public static var instance:CheckSameObserver = new CheckSameObserver(); 
		
		public function allowPropertyChange(target:Object, name:String, currentValue:*, newValue:*):Boolean
		{
			return currentValue != newValue;
		}
		
		public function propertyChanging(target:Object, name:String, currentValue:*, newValue:*):*
		{
			return newValue;
		}
		
		public function propertyChange(target:Object, name:String, oldValue:*, newValue:*):void
		{
		}
	}
}