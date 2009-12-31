package reflex.core
{
	import reflex.behaviors.CompositeBehavior;

	public interface IBehavioral
	{
		function get behaviors():CompositeBehavior;
		function set behaviors(value:*):void;
	}
}