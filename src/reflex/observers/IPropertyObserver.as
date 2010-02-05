package reflex.observers
{
	public interface IPropertyObserver
	{
		/**
		 * Allows an observer to approve or disapprove of a property change.
		 * 
		 * @param The object which has a property being changed.
		 * @param The name of the property.
		 * @param The current value of the property.
		 * @param The new value the property will be set to.
		 * @return Whether or not the property should be allowed to be changed.
		 * A true will allow it.
		 */
		function allowPropertyChange(target:Object, name:String, currentValue:*, newValue:*):Boolean;
		
		/**
		 * Allows an observer to modify a property change. Uses of this
		 * functionality might include transitions/effects or styling.
		 * 
		 * @param The object which has a property being changed.
		 * @param The name of the property.
		 * @param The current value of the property.
		 * @param The new value the property will be set to.
		 * @return (Optional) The new value modified. If nothing (undefined) is
		 * returned then the value will remain the same.
		 */
		function propertyChanging(target:Object, name:String, currentValue:*, newValue:*):*;
		
		/**
		 * Allows an observer to respond to a property change.
		 * 
		 * @param The object which had a property changed.
		 * @param The name of the property.
		 * @param The old value of the property.
		 * @param The new value the property was set to.
		 */
		function propertyChange(target:Object, name:String, oldValue:*, newValue:*):void;
	}
}