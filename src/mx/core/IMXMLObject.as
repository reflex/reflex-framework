package mx.core
{
	public interface IMXMLObject
	{
		/**
		 *  Called after the implementing object has been created and all
		 *  component properties specified on the MXML tag have been initialized.
		 *
		 *  @param document The MXML document that created this object.
		 *
		 *  @param id The identifier used by <code>document</code> to refer
		 *  to this object.
		 *  If the object is a deep property on <code>document</code>,
		 *  <code>id</code> is null.
		 */
		function initialized(document:Object, id:String):void;
	}
}