package mx.styles
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	
	import mx.core.IMXMLObject;
	
	import reflex.styles.IStylable;

	public class StyleManager implements IMXMLObject
	{
		protected static var collapseSpace:RegExp = new RegExp("\\t+| {2,}", "g");
		protected static var addMissingTypes:RegExp = new RegExp("(^| )(#|\\.|:)", "g");
		protected static var selectors:Object = {};
		protected static var declarations:Array = [];
		
		/**
		 * Grab a reference to the stage so we can set styles when items are
		 * added.
		 */
		public function initialized(document:Object, id:String):void
		{
			init(document.stage);
		}
		
		public static function init(stage:Stage):void
		{
			stage.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, true);
			stage.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, true);
		}
		
		protected static function onAddedToStage(event:Event):void
		{
			var displayObject:DisplayObject = event.target as DisplayObject;
			updateStyles(displayObject);
			if (displayObject is IStylable) {
				displayObject.addEventListener("stateChange", onStateChange);
			}
		}
		
		protected static function onRemovedFromStage(event:Event):void
		{
			var displayObject:DisplayObject = event.target as DisplayObject;
			if (displayObject is IStylable) {
				displayObject.removeEventListener("stateChange", onStateChange);
			}
		}
		
		protected static function onStateChange(event:Event):void
		{
			var displayObject:DisplayObject = event.target as DisplayObject;
			updateStyles(displayObject);
		}
		
		protected static function updateStyles(displayObject:DisplayObject):void
		{
			var styles:Object = getStyles(displayObject);
			var i:String;
			
			// set classes first, then properties
			for (i in styles) {
				if (styles[i] is Class) {
					if (!applyStyle(displayObject, i.split("."), styles[i])) {
						trace(i, "was not able to be set on", displayObject);
					}
				}
			}
			
			// now set properties
			for (i in styles) {
				if ( !(styles[i] is Class) ) {
					if (!applyStyle(displayObject, i.split("."), styles[i])) {
						trace(i, "was not able to be set on", displayObject);
					}
				}
			}
		}
		
		protected static function applyStyle(obj:Object, props:Array, value:*):Boolean
		{
			var len:uint = props.length;
			try {
				for (var j:uint = 0; j < len; j++) {
					var name:String = props[j];
					if (j < len - 1) {
						obj = obj[name];
					} else {
						obj[name] = value;
					}
				}
				return true;
			} catch (e:Error) {}
			
			return false;
		}
		
		public static function getStyles(obj:Object):Object
		{
			var declaration:CSSStyleDeclaration;
			
			var matches:Array = [];
			for each (declaration in declarations) {
				if (declaration.selector.match(obj)) {
					matches.push(declaration);
				}
			}
			matches.sortOn("specificity", Array.NUMERIC);
			var styles:Object = {};
			for each (declaration in matches) {
				var prefix:String = "";
				if (declaration.selector.property) {
					prefix = declaration.selector.property + ".";
				}
				mergeObjects(styles, declaration.styles, prefix);
			}
			return styles;
		}
		
		protected static function mergeObjects(mergeTo:Object, mergeFrom:Object, prefix:String = ""):Object
		{
			for (var name:String in mergeFrom) {
				mergeTo[prefix + name] = mergeFrom[name];
			}
			return mergeTo;
		}
		
		public static function getStyleDeclaration(selector:String):CSSStyleDeclaration
		{
			return null;
		}
		
		
		public static function setStyleDeclaration(selector:String, styleDeclaration:CSSStyleDeclaration):void
		{
			declarations.push(styleDeclaration);
		}
		
		
		public static function clearStyleDeclaration(selector:String, unload:Boolean):void
		{
			
		}
	}
}