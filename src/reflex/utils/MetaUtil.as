package reflex.utils
{
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import reflex.metadata.Alias;
	import reflex.metadata.ClassDirectives;
	import reflex.metadata.DefaultSetting;
	import reflex.metadata.EventHandler;
	
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
				directives.aliases = baseClassDirectives.aliases.concat();
				directives.eventHandlers = baseClassDirectives.eventHandlers.concat();
				//directives.viewContracts = baseClassDirectives.viewContracts.concat();
				//directives.viewHandlers = baseClassDirectives.viewHandlers.concat();
				//directives.styles = baseClassDirectives.styles.concat();
				//directives.capacitors = baseClassDirectives.capacitors.concat();
				// methods are inherited down in describeTypeData.
			}
			
			var description:XML = flash.utils.describeType(type);
			//resolveStyleBindings(description, directives.styles);
			resolveAliases(description, directives.aliases);
			resolveEventHandlers(description, directives.eventHandlers);
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
		
		private static function resolveEventHandlers(description:XML, directives:Array):void {
			var metadata:XMLList = description.factory.metadata.(@name == "EventHandler");
			for (var i:int = 0; i < metadata.length(); i++) {
				var directive:EventHandler = new EventHandler();
				directive.dispatcher = null;
				directive.event = metadata[i].arg.(@key == "type").@value;
				directive.handler = metadata[i].arg.(@key == "handler").@value;
				directives.push(directive);
			}
			
			metadata = description.factory.accessor.metadata.(@name == "EventHandler");
			metadata += description.factory.variable.metadata.(@name == "EventHandler");
			for (i = 0; i < metadata.length(); i++) {
				directive = new EventHandler();
				directive.dispatcher = metadata[i].parent().@name;
				directive.event = metadata[i].arg.(@key == "type").@value;
				directive.handler = metadata[i].arg.(@key == "handler").@value;
				directives.push(directive);
			}
			
			metadata = description.factory.method.metadata.(@name == "EventHandler");
			for (i = 0; i < metadata.length(); i++) {
				directive = new EventHandler();
				var dispatcherArg:Object = metadata[i].arg.(@key == "dispatcher");
				directive.dispatcher = metadata[i].arg.(@key == "dispatcher").@value;
				if (directive.dispatcher == "") {
					directive.dispatcher = null;
				}
				directive.event = metadata[i].arg.(@key == "type" || @key == "").@value;
				directive.handler = metadata[i].parent().@name;
				if(directive.event == "" || directive.handler == "") {
					directive = resolveEventHandlerFromFunction(metadata[i].parent(), directive);
				}
				directives.push(directive);
			}
			
			// find reflex functions without metadata - we'll autowire them
			metadata = description.factory.method.(attribute("uri") == "http://reflex.io");
			for (i = 0; i < metadata.length(); i++) {
				var meta:XMLList = metadata.metadata.(@name == "EventHandler");
				if(meta.length() == 0) {
					directive = new EventHandler();
					directive = resolveEventHandlerFromFunction(metadata[i], directive);
					directives.push(directive);
				}
			}
		}
		
		// this parsing isn't very robust at the moment
		private static function resolveEventHandlerFromFunction(xml:XML, directive:EventHandler):EventHandler {
			var split:Array = xml.@name.toString().split("_");
			if(split.length == 2) {
				directive.dispatcher = split[0];
				directive.event = split[1].replace("Handler", "");
				directive.handler = xml.@name.toString();
			} else {
				directive.event = split[0].replace("Handler", "");
				directive.handler = xml.@name.toString();
			}
			return directive;
		}
		
		private static function resolveAliases(description:XML, directives:Array):void {
			var metadata:XMLList = description.factory.accessor.metadata.(@name == "Alias");
			metadata += description.factory.variable.metadata.(@name == "Alias");
			for (var i:int = 0; i < metadata.length(); i++) {
				var directive:Alias = new Alias();
				directive.property = metadata[i].parent().@name;
				directive.type = metadata[i].parent().@type;
				directives.push(directive);
			}
		}
		
	}
}