package mx.mxml
{
	
	import mx.binding.ArrayElementWatcher;
	import mx.binding.BindingManager;
	import mx.binding.FunctionReturnWatcher;
	import mx.binding.RepeaterComponentWatcher;
	import mx.binding.RepeaterItemWatcher;
	import mx.binding.StaticPropertyWatcher;
	import mx.binding.XMLWatcher;
	import mx.core.ClassFactory;
	import mx.core.FontAsset;
	import mx.core.IStateClient2;
	import mx.core.Repeater;
	import mx.styles.CSSStyleDeclaration;
	
	/**
	 * Pulls various Flex classes into the Reflex swc.
	 * These classes are not referenced by Reflex and are not required to build Reflex in Flash Pro or AS3 projects.
	 * They will not be pulled into you swf unless you use MXML. When using MXML (with MXMLC) these classes are sometimes
	 * pulled into projects automatically by the compiler. We make them available to the compiler here so that project setup does 
	 * not require any outside Flex SDK references.
	 */
	public class FlexReferences
	{
		
		// binding
		static private var bm:BindingManager;
		static private var aw:ArrayElementWatcher;
		static private var frw:FunctionReturnWatcher;
		static private var rcw:RepeaterComponentWatcher;
		static private var riw:RepeaterItemWatcher;
		static private var spw:StaticPropertyWatcher;
		static private var xw:XMLWatcher;
		
		// core
		static private var cf:ClassFactory;
		static private var fa:FontAsset;
		
		// states & styles
		static private var sc2:mx.core.IStateClient2;
		static private var csd:CSSStyleDeclaration;
		
	}
}