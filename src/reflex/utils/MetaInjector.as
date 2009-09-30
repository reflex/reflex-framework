package reflex.utils
{
	import flash.utils.getDefinitionByName;
	
	import reflex.metadata.ClassDirectives;
	import reflex.metadata.DefaultSetting;
	
	public class MetaInjector
	{
		
		static public function createDefaults(target:Object):void {
			// create default assignments based on metadata
			var directives:ClassDirectives = MetaUtil.resolveDirectives(target);
			var defaultSettings:Array = directives.defaultSettings.concat().reverse();
			for each(var directive:DefaultSetting in defaultSettings) {
				updateProperty(target, directive.property, directive.value);
			}
		}
		
		static private function updateProperty(target:Object, property:String, value:String):void {
			if(target[property]==null) {
				if(value.indexOf(",") != -1) {
					var items:Array = [];
					var split:Array = value.split(",");
					var length:int = split.length;
					for(var i:int = 0; i < length; i++) {
						var className:String = split[i];
						var ItemClass:Object = getDefinitionByName(className.replace(" ", ""));
						items.push(new ItemClass());
					}
					target[property] = items;
				} else {
					var ValueClass:Object = getDefinitionByName(value);
					target[property] = new ValueClass();
				}
			}
		}
		
	}
}