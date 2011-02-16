package reflex.collections {
	import mx.collections.IList;

	public function convertToIList(value:*):IList {
		var ilist:IList;

		if (value == null) {
			ilist = null;
		} else if (value is IList) {
			ilist = value as IList;
		} else if (value is Array) {
			ilist = new SimpleCollection(value);
		} else if (reflex.collections.isVector(value)) {
			ilist = new SimpleCollection(reflex.collections.convertIndexedObjectToArray(value));
		} else {
			ilist = new SimpleCollection([value]);
		}

		return ilist;
	}
}