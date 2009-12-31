package reflex.core
{
	import reflex.behavior.CompositeBehavior;

	public interface IBehavioral
	{
		function get behaviors():CompositeBehavior;
		function set behaviors(value:*):void;
	}
}