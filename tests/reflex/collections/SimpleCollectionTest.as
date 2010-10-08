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
			var listener:Function = Async.asyncHandler(this, collectionChangeHandler, 500, CollectionEvent.COLLECTION_CHANGE, timeoutHandler);
			(collection as IEventDispatcher).addEventListener(CollectionEvent.COLLECTION_CHANGE, listener, false, 0, false);
			collection.addItem("test");
		}
		
		private function collectionChangeHandler(event:CollectionEvent, type:String):void {
			switch(event.kind) {
				case CollectionEventKind.ADD:
					Assert.assertEquals("test", event.items[0]);
					break;
			}
		}
		
		protected function timeoutHandler(type:String):void {
			Assert.fail(type + ": timed out.");
		}
		
	}
}