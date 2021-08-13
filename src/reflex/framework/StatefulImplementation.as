import reflex.states.removeState;
import reflex.states.applyState;


private var _states:Array;
private var _transitions:Array;
private var _currentState:String;

// IStateful implementation

[Bindable(event="statesChange")]
public function get states():Array { return _states; }
public function set states(value:Array):void {
	notify("states", _states, _states = value);
}

[Bindable(event="transitionsChange")]
public function get transitions():Array { return _transitions; }
public function set transitions(value:Array):void {
	notify("transitions", _transitions, _transitions = value);
}

[Bindable(event="currentStateChange")]
public function get currentState():String { return _currentState; }
public function set currentState(value:String):void {
	if (_currentState == value) {
		return;
	}
	// might need to add invalidation for this later
	reflex.states.removeState(this, _currentState, states);
	notify("currentState", _currentState, _currentState = value);
	reflex.states.applyState(this, _currentState, states);
}

public function hasState(state:String):Boolean {
	for each(var s:Object in states) {
		if(s.name == state) {
			return true;
		}
	}
	return false;
}