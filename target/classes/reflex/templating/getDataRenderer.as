package reflex.templating
{
	import flash.display.DisplayObject;
	
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	
	import reflex.graphics.IDrawable;
	
	/**
	 * Returns a renderer to be used for the given data according to the given template.
	 */
	public function getDataRenderer(container:Object, data:*, template:Object):Object
	{
		var instance:*;
		if (template is IDataTemplate) {
			instance = (template as IDataTemplate).createDisplayObject(data);
		} else if (template is IFactory) {
			instance = (template as IFactory).newInstance();
		} else if (template is Class) {
			var C:Class = template as Class;
			instance = new C();
		} else if (template is Function) {
			instance = (template as Function)(data);
		} else if (data is DisplayObject) {
			instance = data as DisplayObject;
		}
		if (instance is IDataRenderer) {
			(instance as IDataRenderer).data = data;
		}
		if (data is IDrawable) {
			(data as IDrawable).target = container;
		}
		return instance != null ? instance : data;
	}
	
}