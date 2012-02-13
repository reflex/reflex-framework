package reflex.components
{
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	
	import reflex.behaviors.ButtonBehavior;
	import reflex.behaviors.SelectBehavior;
	import reflex.binding.Bind;
	import reflex.binding.DataChange;
	import reflex.skins.ISkin;
	import reflex.skins.ListItemSkin;
	
	/**
	 * @alpha
	 */
	public class ListItem extends Button implements IDataRenderer, IFactory
	{
		
		private var _data:Object;
		
		[Bindable(event="dataChange")]
		public function get data():Object { return _data; }
		public function set data(value:Object):void {
			DataChange.change(this, "data", _data, _data = value);
		}
		
		
		public function ListItem()
		{
			super();
			initialize();
		}
		
		private function initialize():void {
			skin = new ListItemSkin();
			behaviors.addItem(new ButtonBehavior(this));
			behaviors.addItem(new SelectBehavior(this));
			Bind.addBinding(this, "skin.labelDisplay.text", this, "data.label");
			Bind.addBinding(this, "skin.labelDisplay.text", this, "data.name");
			Bind.addBinding(this, "skin.currentState", this, "currentState", false);
			measured.width = 210;
			measured.height = 88;
			percentWidth = 100;
		}
		
		public function newInstance():* {
			var n:String = flash.utils.getQualifiedClassName(this);
			var C:Class = getDefinition( n );

			var instance:ListItem = new C();
			
			if (skin == null)
				throw new Error("Trying to create a new instance of ListItemDefinition using a ListItemDefinition object that does not have a skin defined.  ListItemDefinition.newInstance() requires that a skin is defined.");
			
			var sn:String = flash.utils.getQualifiedClassName(skin);
			var sC:Class = getDefinition( sn );
			instance.skin = new sC() as ISkin;
			return instance;
		}
		
		private function getDefinition( name:String ):Class
		{
			var C:Class;
			try{ 
				C = flash.utils.getDefinitionByName( name ) as Class
			} catch ( error:Error )
			{
				if( loaderInfo )
				{
					C = loaderInfo.applicationDomain.getDefinition( name ) as Class;
				}
				if( !C )
				{
					trace( "ListItem: Unable to retrieve definition of Class '" + name + "'." );
					throw error;
				}
			}
			return C; 
		}
		
	}
}