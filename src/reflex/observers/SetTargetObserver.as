package reflex.observers
{
	public class SetTargetObserver implements IPropertyObserver
	{
		public static var instance:SetTargetObserver = new SetTargetObserver(); 
		
		
		public function allowPropertyChange(target:Object, name:String, currentValue:*, newValue:*):Boolean
		{
			return true;
		}
		
		public function propertyChanging(target:Object, name:String, currentValue:*, newValue:*):*
		{
			
		}
		
		public function propertyChange(target:Object, name:String, oldValue:*, newValue:*):void
		{
			if (oldValue != null && "target" in oldValue) {
				oldValue.target = null;
			}
			
			if (newValue != null && "target" in newValue) {
				newValue.target = target;
			}
		}
	}
}