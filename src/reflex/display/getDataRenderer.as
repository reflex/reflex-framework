package reflex.display
{
	import flash.display.DisplayObject;
	
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	
	public function getDataRenderer(data:*, template:Object):Object
	{
		var instance:Object;
		if(template is IDataTemplate) {
			instance = (template as IDataTemplate).createDisplayObject(data);
		} else if(template is IFactory) {
			instance = (template as IFactory).newInstance();
		} else if(template is Class) {
			instance = new (template as Class);
		} else if(template is Function) {
			instance = (template as Function)(data);
		} else if(data is DisplayObject) {
			instance = data as DisplayObject;
		}
		if (instance is IDataRenderer) {
			(instance as IDataRenderer).data = data;
		}
		return instance;
	}
	
}