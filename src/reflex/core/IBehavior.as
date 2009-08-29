package reflex.core
{
	public interface IBehavior
	{
		function get owner():IComponent;
		function set owner(value:IComponent):void;
	}
}