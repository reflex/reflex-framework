package reflex.collections
{
	import flash.events.IEventDispatcher;
	
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;

	public class SimpleCollectionTest
	{
		
		private var C:Class = SimpleCollection;
		
		[Test(async)]
		public function testAddItem():void {
			var collection:IList= new C();
			collection.addItem("test1");
			collection.addItem("test2");
			var listener:Function = Async.asyncHandler(this, collectionChangeHandler, 500, "test3", timeoutHandler);
			(collection as IEventDispatcher).addEventListener(CollectionEvent.COLLECTION_CHANGE, listener, false, 0, false);
			collection.addItem("test3");
		}
		
		[Test(async)]
		public function testSource():void {
			var collection:SimpleCollection = new C();
			var source:Array = [];
			var listener:Function = Async.asyncHandler(this, collectionChangeHandler, 500, source, timeoutHandler);
			(collection as IEventDispatcher).addEventListener(CollectionEvent.COLLECTION_CHANGE, listener, false, 0, false);
			collection.source = source;
		}
		
		[Test(async)]
		public function testSourceNull():void {
			var collection:SimpleCollection = new C();
			var source:Array = null;
			var listener:Function = Async.asyncHandler(this, collectionChangeHandler, 500, source, timeoutHandler);
			(collection as IEventDispatcher).addEventListener(CollectionEvent.COLLECTION_CHANGE, listener, false, 0, false);
			collection.source = source; // makes sure null doesn't throw an error
		}
		
		private function collectionChangeHandler(event:CollectionEvent, data:Object):void {
			switch(event.kind) {
				case CollectionEventKind.RESET:
					if(data == null) {
						// blank array is given for null source
						Assert.assertEquals(0, event.items.length);
					} else {
						for(var i:int = 0; i < event.items.length; i++) {
							Assert.assertEquals(data[i], event.items[i]);
						}
					}
					break;
				case CollectionEventKind.ADD:
					Assert.assertEquals(data, event.items[0]);
					Assert.assertEquals(2, event.location); // tests location index
					break;
			}
		}
		
		protected function timeoutHandler(type:String):void {
			Assert.fail(type + ": timed out.");
		}
		
	}
}