package
{
	/**
	 * @private
	 * This class is used to link additional classes into reflex.swc
	 * beyond those that are found by dependecy analysis starting from the
	 * classes specified in manifest.xml. For example, compiler-required
	 * references to Flex classes for use of an MXML workflow and the [Bindable]
	 * metadata tag in AS3-only projects - many of these classes are never
	 * actually used, not even in the auto-generated code.
	 */
	internal class FlexClasses
	{
		import mx.core.IMXMLObject;						IMXMLObject;
		import mx.core.IFlexModuleFactory;				IFlexModuleFactory;
		
		//import mx.collections.IList;					IList;
		
		// binding references for use of the [Bindable] metadata tag
		import mx.binding.BindingManager;				BindingManager;
		import mx.core.IPropertyChangeNotifier;			IPropertyChangeNotifier;
		import mx.utils.ObjectProxy;					ObjectProxy;
		import mx.utils.UIDUtil;						UIDUtil;
		
		// mx core references for use of MXML
		import mx.styles.StyleManager;					StyleManager;
		import mx.core.ClassFactory;					ClassFactory;
		import mx.core.DeferredInstanceFromClass;		DeferredInstanceFromClass;
		import mx.core.DeferredInstanceFromFunction;	DeferredInstanceFromFunction;
		
		// binding references for use of the curly-brace binding in MXML
		import mx.binding.IWatcherSetupUtil;			IWatcherSetupUtil;
		// Required class for Flash Buider 4 binding in AS3 projects
		import mx.binding.IBindingClient;				IBindingClient;
		import mx.binding.IWatcherSetupUtil2;			IWatcherSetupUtil2;
		import mx.binding.ArrayElementWatcher;			ArrayElementWatcher;
		import mx.binding.FunctionReturnWatcher;		FunctionReturnWatcher;
		import mx.binding.PropertyWatcher;				PropertyWatcher;
		import mx.binding.RepeaterComponentWatcher;		RepeaterComponentWatcher;
		import mx.binding.RepeaterItemWatcher;			RepeaterItemWatcher;
		import mx.binding.StaticPropertyWatcher;		StaticPropertyWatcher;
		import mx.binding.XMLWatcher;					XMLWatcher;
	}

}
