package reflex.framework
{
	import reflex.containers.IContainer;

	public interface IDataContainer extends IContainer
	{
		
		function get template():Object;
		function set template(value:Object):void;
		
		function getRendererForItem(item:*):Object;
		function getItemForRenderer(renderer:Object):*;
		function getRenderers():Array;
		
	}
}