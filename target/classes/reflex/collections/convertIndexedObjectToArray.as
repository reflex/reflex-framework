package reflex.collections {
	
	public function convertIndexedObjectToArray(indexedObject:Object):Array {
		var array:Array = [];
		
		var indexedObjectLength:int = indexedObject.length;
		
		for (var i:int = 0; i < indexedObjectLength; i++ ) {
			array[i] = indexedObject[i];
		}
		
		return array;
	}
}