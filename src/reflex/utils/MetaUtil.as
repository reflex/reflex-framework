package reflex.utils
{
	import flash.utils.Dictionary;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import reflex.metadata.ClassDirectives;
	import reflex.metadata.DefaultSetting;
	
	public class MetaUtil
	{
		
		private static var directivesByClassName:Dictionary = new Dictionary(false);
		
		/**
		 * Return metadata for a specific class instance. Results are cached by class.
		 * 
		 * @param instance The object to resolve metadata for
		 * @return All metadata associated with object (class and super-classes) 
		 */
		public static function resolveDirectives(instance:Object):ClassDirectives {
			var className:String = getQualifiedClassName(instance);
			return directivesForClass(className);
		}
		
		/**
		 * Return metadata for a specific class. Results are cached.
		 * 
		 * @param className The class to resolve metadata for
		 * @return All metadata associated with class and super-classes
		 */
		private static function directivesForClass(className:String):ClassDirectives {
			var directives:ClassDirectives = directivesByClassName[className];
			if(directives != null) { return directives; }
			
			directives = new ClassDirectives();
			var type:Class = ApplicationDomain.currentDomain.getDefinition(className) as Class;
			var baseClassName:String = getQualifiedSuperclassName(type);
			if(baseClassName != null) {
				var baseClassDirectives:ClassDirectives = directivesForClass(baseClassName);
				//directives.bindings = baseClassDirectives.bindings.concat();
				directives.defaultSettings = baseClassDirectives.defaultSettings.concat();
				//directives.modelAliases = baseClassDirectives.modelAliases.concat();
				//directives.modelHandlers = baseClassDirectives.modelHandlers.concat();
				//directives.viewContracts = baseClassDirectives.viewContracts.concat();
				//directives.viewHandlers = baseClassDirectives.viewHandlers.concat();
				//directives.styles = baseClassDirectives.styles.concat();
				//directives.capacitors = baseClassDirectives.capacitors.concat();
				// methods are inherited down in describeTypeData.
			}
			
			var description:XML = flash.utils.describeType(type);
			//resolveStyleBindings(description, directives.styles);
			//resolveModelAliases(description, directives.modelAliases);
			//resolveEventHandlers(description, directives.modelHandlers);
			//resolveViewContracts(description, directives.viewContracts);
			//resolveViewHandlers(description, directives.viewHandlers);
			resolveDefaultSettings(description, directives.defaultSettings);
			//resolveCapacitors(description, directives.capacitors);
			directivesByClassName[className] = directives;
			return directives;
		}
		
		private static function resolveDefaultSettings(description:XML, directives:Array):void {
			var metadata:XMLList = description.factory.metadata.(@name == "DefaultSetting");
			for (var i:int = 0; i < metadata.length(); i++) {
				var directive:DefaultSetting = new DefaultSetting();
				directive.property = metadata[i].arg.@key;
				directive.value = metadata[i].arg.@value;
				directives.unshift(directive);
			}
		}
		
	}
}