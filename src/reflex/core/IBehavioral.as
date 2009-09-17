package reflex.core
{
	import reflex.behaviors.BehaviorMap;

	public interface IBehavioral
	{
		function get behaviors():BehaviorMap;
		function set behaviors(value:*):void;
	}
}