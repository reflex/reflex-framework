package mx.styles
{
	public interface IStyleManager2
	{
		
		function setStyleDeclaration(selector:String, styleDeclaration:CSSStyleDeclaration):void;
		function getStyleDeclaration(selector:String):CSSStyleDeclaration;
		//function initProtoChainRoots():void;
	}
}