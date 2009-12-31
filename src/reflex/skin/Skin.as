package reflex.skin
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import flight.list.IList;
	
	import reflex.core.ISkin;
	import reflex.core.ISkinnable;
	
	/**
	 * Skin is a convenient base class for many skins, a swappable graphical
	 * definition. Skins decorate a target Sprite by drawing on its surface,
	 * adding children to the Sprite, or both.
	 */
	public class Skin implements ISkin
	{
		[Bindable]
		public var target:Sprite;
		
		[Bindable]
		public var state:String;
		
		public function getSkinPart(part:String):InteractiveObject
		{
			return (part in target) ? target[part] : null;
		}
		
	}
}