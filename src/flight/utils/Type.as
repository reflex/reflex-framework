package flight.utils
{
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The static Type class contains a collection of type-specific utilities,
	 * including object reflection. Reflection is described in XML, which
	 * format is documented in the <code>flash.utils</code> package. XML
	 * descriptions are cached for performance.
	 * 
	 * @see		flash.utils#describeType
	 */
	public class Type
	{
		// global cache improves reflection performance significantly
		private static var typeCache:Dictionary = new Dictionary();
		
		/**
		 * Evaluates whether an object or class is derived from a specific
		 * data type, class or interface. The isType() method is comparable to
		 * ActionScript's <code>is</code> operator except that it also makes
		 * class to class evaluations.
		 * 
		 * @param	value			The object or class to evaluate.
		 * @param	type			The data type to check against.
		 * 
		 * @return					True if the object or class is derived from
		 * 							the data type.
		 */
		public static function isType(value:Object, type:Class):Boolean
		{
			if ( !(value is Class) ) {
				return value is type;
			}
			
			if (value == type) {
				return true;
			}
			
			var inheritance:XMLList = describeInheritance(value);
			return Boolean( inheritance.(@type == getQualifiedClassName(type)).length() > 0 );
		}
		
		/**
		 * Determines the property type without accessing the property directly.
		 * Evaluation is based on the property definition and not by its value.
		 * 
		 * @param	value			An object or class containing the property
		 * 							definition to evaluate.
		 * @param	property		The name of the property to be evaluated
		 * 
		 * @return					The class definition of the property type,
		 * 							as described by the property definition, or
		 * 							null if no definition was found.
		 */
		public static function getPropertyType(value:Object, property:String):Class
		{
			if ( !(value is Class) && !(property in value) ) {
				return null;
			}
			
			// retrieve the correct property from the property list
			var propList:XMLList = describeProperties(value).(@name == property);
			
			return (propList.length() > 0) ? getDefinitionByName( propList[0].@type ) as Class : null;
		}
		
		/**
		 * Ensures a class has a registered alias for object serialization and
		 * remoting. If the class doesn't yet have an alias it will be
		 * registered with it's full qualified class name, for example:
		 * <code>flight.utils.Type</code>. If the class has already been
		 * assigned an alias then its previous registration will be honored.
		 * 
		 * @param	value			The object or class to register.
		 * 
		 * @return					True if the registration was successful,
		 * 							otherwise the object already has an alias.
		 * 
		 * @see		flash.net#registerClassAlias
		 */
		public static function registerType(value:Object):Boolean
		{
			if ( !(value is Class) ) {
				value = getType(value);
			}
			
			// if not already registered
			var alias:String = describeType(value).@alias;
			if (alias.length) {
				return false;
			}
			
			registerClassAlias(getQualifiedClassName(value).split("::").join("."), value as Class);
			return true;
		}
		
		/**
		 * Primary reflection method, producing an XML description of the object
		 * or class specified. Results are cached internally for performance.
		 * 
		 * @param	value			The object or class to introspect.
		 * @param	refreshCache	Forces a new description to be generated,
		 * 							useful only when a class alias has changed.
		 * 
		 * @return					An XML description, which format is
		 * 							documented in the <code>flash.utils</code>
		 * 							package.
		 * 
		 * @see		flash.utils#describeType
		 */
		public static function describeType(value:Object, refreshCache:Boolean = false):XML
		{
			if ( !(value is Class) ) {
				value = getType(value);
			}
			
			if (refreshCache || typeCache[value] == null) {
				typeCache[value] = flash.utils.describeType(value);
			}
			
			return typeCache[value];
		}
		
		/**
		 * Targeted reflection describing an object's inheritance, including
		 * extended classes and implemented interfaces.
		 * 
		 * @param	value			The object or class to introspect.
		 * 
		 * @return					A list of XML inheritance descriptions.
		 */
		public static function describeInheritance(value:Object):XMLList
		{
			return describeType(value).factory.*.(localName() == "extendsClass" || localName() == "implementsInterface");
		}
		
		/**
		 * Targeted reflection describing an object's properties, including both
		 * accessor's (getter/setters) and pure properties.
		 * 
		 * @param	value			The object or class to introspect.
		 * @param	metadataType	Optional filter to return only those
		 * 							property descritions containing the
		 * 							specified metadata.
		 * 
		 * @return					A list of XML property descriptions.
		 */
		public static function describeProperties(value:Object, metadataType:String = null):XMLList
		{
			var properties:XMLList = describeType(value).factory.*.(localName() == "accessor" || localName() == "variable");
			
			return (metadataType == null) ? properties : properties.(child("metadata").(@name == metadataType).length() > 0);
		}
		
		
		/**
		 * Targeted reflection describing an object's methods.
		 * 
		 * @param	value			The object or class to introspect.
		 * @param	metadataType	Optional filter to return only those
		 * 							method descritions containing the
		 * 							specified metadata.
		 * 
		 * @return					A list of XML method descriptions.
		 */
		public static function describeMethods(value:Object, metadataType:String = null):XMLList
		{
			var methods:XMLList = describeType(value).factory.method;
			
			return (metadataType == null) ? methods : methods.(child("metadata").(@name == metadataType).length() > 0);
		}
		
	}
}