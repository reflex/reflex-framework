package reflex.graphics
{
	
	public interface IDrawable
	{
		
		function set target(value:Object):void;
		function render():void;
		
		function setSize(w:Number, h:Number):void;
		
	}
}