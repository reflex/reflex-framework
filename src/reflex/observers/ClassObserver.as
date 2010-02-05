package reflex.observers
{
	public class ClassObserver implements IPropertyObserver
	{
		public static var instance:ClassObserver = new ClassObserver(); 
		
		public function allowPropertyChange(target:Object, name:String, currentValue:*, newValue:*):Boolean
		{
			if (currentValue != null && newValue is Class && Object(currentValue).constructor == newValue) {
				return false;
			}
			return true;
		}
		
		public function propertyChanging(target:Object, name:String, currentValue:*, newValue:*):*
		{
			if (newValue is Class) {
				return new newValue();
			} else {
				return newValue;
			}
		}
		
		public function propertyChange(target:Object, name:String, oldValue:*, newValue:*):void
		{
		}
	}
}