////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2007 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package mx.resources
{

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.TimerEvent;
import flash.system.SecurityDomain;
import flash.utils.getDefinitionByName;
import flash.utils.Timer;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.core.Singleton;
//import mx.events.ModuleEvent;
//import mx.events.ResourceEvent;
//import mx.modules.IModuleInfo;
//import mx.modules.ModuleManager;
//import mx.utils.StringUtil;

/**
 *  This class is used to get a single instance of the IResourceManager
 *  implementation.
 *  The IResourceManager and IResourceBundle interfaces work together
 *  to provide internationalization support for Flex applications.
 *
 *  <p>A single instance of an IResourceManager implementation
 *  manages all localized resources
 *  for a Flex application.</p>
 *  
 *  @see mx.resources.IResourceManager
 *  @see mx.resources.IResourceBundle
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ResourceManager
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Linker dependency on implementation class.
     */
    private static var implClassDependency:ResourceManagerImpl;

    /**
     *  @private
     *  The sole instance of the ResourceManager.
     */
    private static var instance:IResourceManager;
    
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Gets the single instance of the ResourceManager class.
     *  This object manages all localized resources for a Flex application.
     *  
     *  @return An object implementing IResourceManager.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function getInstance():IResourceManager
    {
        if (!instance)
        {
			/*
            CONFIG::performanceInstrumentation
            {
                var perfUtil:mx.utils.PerfUtil = mx.utils.PerfUtil.getInstance();
                perfUtil.markTime("ResourceManager.getInstance().start");
            }
            */
			if (!Singleton.getClass("mx.resources::IResourceManager"))
				// install ResourceManagerImpl if not registered already
				Singleton.registerClass("mx.resources::IResourceManager",
					Class(getDefinitionByName("mx.resources::ResourceManagerImpl")));


            try
			{
				instance = IResourceManager(
					Singleton.getInstance("mx.resources::IResourceManager"));
			}
			catch(e:Error)
			{
				// In non-Flex apps and modules, the Singleton manager
				// won't have been initialized by SystemManager
				// or FlexModuleFactory (since these don't get linked in)
				// so the above call to getInstance() will throw an exception.
				// In this situation, the ResourceManager simply creates
				// its own ResourceManagerImpl.
				instance = new ResourceManagerImpl();
			}
/*
            CONFIG::performanceInstrumentation
            {
                perfUtil.markTime("ResourceManager.getInstance().end");
            }
*/
        }
        
        return instance;
    }
    
}

}