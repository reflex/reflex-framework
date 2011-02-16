package reflex.collections {

	public function isVector(value:*):Boolean {
		var valueIsVector:Boolean = true;
		
		try {
			var vector:Vector.<Object> = Vector.<Object>(value);
		} catch (e:Error) {
			valueIsVector = false;
		}
		
		return valueIsVector;
	}
}