package mx.states
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import mx.core.DeferredInstanceFromClass;
	import mx.core.DeferredInstanceFromFunction;
	
	import org.flexunit.Assert;
	
	import reflex.collections.SimpleCollection;
	
	public class AddItemsTest
	{
		
		// need tests for applying states to Arrays and generic Objects / DisplayObjects
		
		[Test]
		public function testAddItemsFirst():void
		{
			var override:AddItems = new AddItems();
			override.propertyName = "content";
			override.position = "first";
			
			var sprite:Sprite = new Sprite();
			override.itemsFactory = new DeferredInstanceFromFunction(function():* { return sprite; }, null);
			
			var children:Array = [new Shape(), new Shape()];
			var container:Object = {content: new SimpleCollection(children)}; // tricky mocking
			override.apply(container);
			Assert.assertEquals(sprite, container.content.getItemAt(0));
		}
		
		[Test]
		public function testAddItemsLast():void
		{
			var override:AddItems = new AddItems();
			override.propertyName = "content";
			override.position = "last";
			
			var sprite:Sprite = new Sprite();
			override.itemsFactory = new DeferredInstanceFromFunction(function():* { return sprite; }, null);
			
			var children:Array = [new Shape(), new Shape()];
			//override.relativeTo = children.concat();
			
			var container:Object = {content: new SimpleCollection(children)}; // tricky mocking
			override.apply(container);
			Assert.assertEquals(sprite, container.content.getItemAt(2));
		}
		
		[Test]
		public function testAddItemsBefore():void
		{
			var override:AddItems = new AddItems();
			override.propertyName = "content";
			override.position = "before";
			
			var sprite:Sprite = new Sprite();
			override.itemsFactory = new DeferredInstanceFromFunction(function():* { return sprite; }, null);
			
			var children:Array = [new Shape(), new Shape()];
			override.relativeTo = [children[1]];
			
			var container:Object = {content: new SimpleCollection(children)}; // tricky mocking
			override.apply(container);
			Assert.assertEquals(sprite, container.content.getItemAt(1));
		}
		
		/*
		[Test]
		public function testAddItemsAfter():void
		{
			var override:AddItems = new AddItems();
			override.propertyName = "content";
			override.position = "after";
			
			var sprite:Sprite = new Sprite();
			override.itemsFactory = new DeferredInstanceFromFunction(function():* { return sprite; }, null);
			
			var children:Array = [new Shape(), new Shape()];
			override.relativeTo = [children[0]];
			
			var container:Object = {content: new SimpleCollection(children)}; // tricky mocking
			override.apply(container);
			Assert.assertEquals(sprite, container.content.getItemAt(1));
		}
		*/
		
	}
}