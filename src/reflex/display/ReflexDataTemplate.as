package reflex.display
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import reflex.graphics.IDrawable;

	public class ReflexDataTemplate implements IDataTemplate
	{
		
		public function createDisplayObject(data:*):Object
		{
			if(data is IDrawable) {
				var shape:Shape = new Shape();
				(data as IDrawable).target = shape;
				//(data as IDrawable).render();
				//shape.graphics.beginFill(0x000000, 1);
				//shape.graphics.drawRect(0, 0, 100, 100);
				//shape.graphics.endFill();
				return shape;
			} else {
				return data;
			}
		}
		
	}
}