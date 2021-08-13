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

/*
 *  The methods here would normally just be in IDisplayObject,
 *  but for backward compatibility, they have to be included
 *  directly into IFlexDisplayObject, so they are kept in 
 *  this separate include file.
 */

    /**
     *  @copy flash.display.DisplayObject#root
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get root():DisplayObject;


    /**
     *  @copy flash.display.DisplayObject#stage
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get stage():Stage;


    /**
     *  @copy flash.display.DisplayObject#name
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get name():String;
    function set name(value:String):void;


    /**
     *  @copy flash.display.DisplayObject#parent
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get parent():DisplayObjectContainer;


    /**
     *  @copy flash.display.DisplayObject#mask
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get mask():DisplayObject;
    function set mask(value:DisplayObject):void;


    /**
     *  @copy flash.display.DisplayObject#visible
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get visible():Boolean;
    function set visible(value:Boolean):void;


    /**
     *  @copy flash.display.DisplayObject#x
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get x():Number;
    function set x(value:Number):void;


    /**
     *  @copy flash.display.DisplayObject#y
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get y():Number;
    function set y(value:Number):void;


    /**
     *  @copy flash.display.DisplayObject#scaleX
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get scaleX():Number;
    function set scaleX(value:Number):void;


    /**
     *  @copy flash.display.DisplayObject#scaleY
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get scaleY():Number;
    function set scaleY(value:Number):void;


    /**
     *  @copy flash.display.DisplayObject#mouseX
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get mouseX():Number; // note: no setter


    /**
     *  @copy flash.display.DisplayObject#mouseY
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get mouseY():Number; // note: no setter


    /**
     *  @copy flash.display.DisplayObject#rotation
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get rotation():Number;
    function set rotation(value:Number):void;


    /**
     *  @copy flash.display.DisplayObject#alpha
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get alpha():Number;
    function set alpha(value:Number):void;


    /**
     *  @copy flash.display.DisplayObject#width
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get width():Number;
    function set width(value:Number):void;

    /**
     *  @copy flash.display.DisplayObject#height
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get height():Number;
    function set height(value:Number):void;


    /**
     *  @copy flash.display.DisplayObject#cacheAsBitmap
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get cacheAsBitmap():Boolean;
    function set cacheAsBitmap(value:Boolean):void;

    /**
     *  @copy flash.display.DisplayObject#opaqueBackground
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get opaqueBackground():Object;
    function set opaqueBackground(value:Object):void;


    /**
     *  @copy flash.display.DisplayObject#scrollRect
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get scrollRect():Rectangle;
    function set scrollRect(value:Rectangle):void;


    /**
     *  @copy flash.display.DisplayObject#filters
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get filters():Array;
    function set filters(value:Array):void;

    /**
     *  @copy flash.display.DisplayObject#blendMode
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get blendMode():String;
    function set blendMode(value:String):void;

    /**
     *  @copy flash.display.DisplayObject#transform
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get transform():Transform;
    function set transform(value:Transform):void;

    /**
     *  @copy flash.display.DisplayObject#scale9Grid
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get scale9Grid():Rectangle;
    function set scale9Grid(innerRectangle:Rectangle):void;

    /**
     *  @copy flash.display.DisplayObject#globalToLocal()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function globalToLocal(point:Point):Point;

    /**
     *  @copy flash.display.DisplayObject#localToGlobal()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function localToGlobal(point:Point):Point;

    /**
     *  @copy flash.display.DisplayObject#getBounds()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getBounds(targetCoordinateSpace:DisplayObject):Rectangle;

    /**
     *  @copy flash.display.DisplayObject#getRect()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getRect(targetCoordinateSpace:DisplayObject):Rectangle;

    /**
     *  @copy flash.display.DisplayObject#loaderInfo
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get loaderInfo() : LoaderInfo;

    /**
     *  @copy flash.display.DisplayObject#hitTestObject()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function hitTestObject(obj:DisplayObject):Boolean;

    /**
     *  @copy flash.display.DisplayObject#hitTestPoint()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean=false):Boolean;

    /**
     *  @copy flash.display.DisplayObject#accessibilityProperties
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get accessibilityProperties() : AccessibilityProperties;
    function set accessibilityProperties( value : AccessibilityProperties ) : void;
    
