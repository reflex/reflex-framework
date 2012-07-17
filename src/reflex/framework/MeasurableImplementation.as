// ActionScript file

private var _explicitWidth:Number;
private var _explicitHeight:Number;
protected var _measuredWidth:Number;
protected var _measuredHeight:Number;

private var _percentWidth:Number;
private var _percentHeight:Number;

protected var unscaledWidth:Number = 160;
protected var unscaledHeight:Number = 22;

// IMeasurable implementation

// these width/height setters need review in regards to scaling.
// I think I would perfer following Flex's lead here.

/**
 * @inheritDoc
 */
[PercentProxy("percentWidth")]
[Bindable(event="widthChange")]
public function get width():Number { return unscaledWidth; }
public function set width(value:Number):void {
	unscaledWidth = _explicitWidth = value;
	setSize(unscaledWidth, height);
}

/**
 * @inheritDoc
 */
[PercentProxy("percentHeight")]
[Bindable(event="heightChange")]
public function get height():Number { return unscaledHeight; }
public function set height(value:Number):void {
	unscaledHeight  = _explicitHeight = value;
	setSize(width, unscaledHeight);
}

/**
 * @inheritDoc
 */
//[Bindable(event="explicitChange", noEvent)]
public function get explicitWidth():Number { return _explicitWidth; }
public function get explicitHeight():Number { return _explicitHeight; }

/**
 * @inheritDoc
 */
//[Bindable(event="measuredChange", noEvent)]
public function get measuredWidth():Number { return _measuredWidth; }
public function get measuredHeight():Number { return _measuredHeight; }

/**
 * @inheritDoc
 */
[Bindable(event="percentWidthChange")]
public function get percentWidth():Number { return _percentWidth; }
public function set percentWidth(value:Number):void {
	notify("percentWidth", _percentWidth, _percentWidth = value);
}

/**
 * @inheritDoc
 */
[Bindable(event="percentHeightChange")]
public function get percentHeight():Number { return _percentHeight; }
public function set percentHeight(value:Number):void {
	notify("percentHeight", _percentHeight, _percentHeight = value);
}

/**
 * @inheritDoc
 */
public function setSize(width:Number, height:Number):void {
	if (unscaledWidth != width) { notify("width", unscaledWidth, unscaledWidth = width); }
	if (unscaledHeight != height) { notify("height", unscaledHeight, unscaledHeight = height); }
}