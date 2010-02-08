package reflex.components
{
	
	[DefaultProperty("label")]
	public class Button extends Component
	{
		[Bindable] public var label:String;
		[Bindable] public var selected:Boolean;
		
		public function Button()
		{
		}
		
	}
}