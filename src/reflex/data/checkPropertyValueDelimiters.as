package reflex.data {
	
	public function checkPropertyValueDelimiters(delimitedString:String):void {
		var delimiterRegExp:RegExp = /^[^:;]+:([^:;]+;[^:;]+:)*[^:;]+;?$/;
		
		var isValid:Boolean = delimiterRegExp.test(delimitedString);
		
		if (!isValid)
			throw new Error("Property/Value strings must be delimited using a \":\" to separate properties from their values ... and a \";\" to separate Property/Value groups.  For example: \"property1:value1;property2:value2;property3:value3\"");
	}
}