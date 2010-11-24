package reflex.states
{
	
	import mx.states.IOverride;
	import mx.states.State;
	
	public function applyState(target:Object, name:String, states:Array):void
	{
		for each(var state:State in states) {
			if(state.name == name) {
				for each(var o:IOverride in state.overrides) {
					o.apply(target);
				}
				return;
			}
		}
	}
		
}