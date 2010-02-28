package reflex.observers
{
	public interface IPropertyObservable
	{
		function addPropertyObserver(observer:IPropertyObserver):void;
		
		function removePropertyObserver(observer:IPropertyObserver):void;
	}
}