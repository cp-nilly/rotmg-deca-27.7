package com.junkbyte.console.view
{
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.text.TextField;
    import com.junkbyte.console.Console;
    import flash.events.TextEvent;
    import flash.events.MouseEvent;
    import com.junkbyte.console.ConsoleConfig;
    import com.junkbyte.console.ConsoleStyle;
    import flash.geom.Rectangle;
    import flash.events.Event;
    import flash.display.DisplayObject;
    import flash.text.TextFieldAutoSize;

    public class ConsolePanel extends Sprite 
    {

        public static const DRAGGING_STARTED:String = "draggingStarted";
        public static const DRAGGING_ENDED:String = "draggingEnded";
        public static const SCALING_STARTED:String = "scalingStarted";
        public static const SCALING_ENDED:String = "scalingEnded";
        public static const VISIBLITY_CHANGED:String = "visibilityChanged";
        private static const TEXT_ROLL:String = "TEXT_ROLL";

        private var _snaps:Array;
        private var _dragOffset:Point;
        private var _resizeTxt:TextField;
        protected var console:Console;
        protected var bg:Sprite;
        protected var scaler:Sprite;
        protected var txtField:TextField;
        protected var minWidth:int = 18;
        protected var minHeight:int = 18;
        private var _movedFrom:Point;
        public var moveable:Boolean = true;

        public function ConsolePanel(_arg1:Console)
        {
            this.console = _arg1;
            this.bg = new Sprite();
            this.bg.name = "background";
            addChild(this.bg);
        }

        private static function onTextFieldMouseOut(_arg1:MouseEvent):void
        {
            TextField(_arg1.currentTarget).dispatchEvent(new TextEvent(TEXT_ROLL));
        }

        private static function onTextFieldMouseMove(e:MouseEvent):void
        {
            var index:int;
            var scrollH:Number;
            var w:Number;
            var X:XML;
            var txtformat:XML;
            var field:TextField = (e.currentTarget as TextField);
            if (field.scrollH > 0)
            {
                scrollH = field.scrollH;
                w = field.width;
                field.width = (w + scrollH);
                index = field.getCharIndexAtPoint((field.mouseX + scrollH), field.mouseY);
                field.width = w;
                field.scrollH = scrollH;
            }
            else
            {
                index = field.getCharIndexAtPoint(field.mouseX, field.mouseY);
            };
            var url:String;
            if (index > 0)
            {
                try
                {
                    X = new XML(field.getXMLText(index, (index + 1)));
                    if (X.hasOwnProperty("textformat"))
                    {
                        txtformat = (X["textformat"][0] as XML);
                        if (txtformat)
                        {
                            url = txtformat.@url;
                        };
                    };
                }
                catch(err:Error)
                {
                    url = null;
                };
            };
            field.dispatchEvent(new TextEvent(TEXT_ROLL, false, false, url));
        }


        protected function get config():ConsoleConfig
        {
            return (this.console.config);
        }

        protected function get style():ConsoleStyle
        {
            return (this.console.config.style);
        }

        protected function init(_arg1:Number, _arg2:Number, _arg3:Boolean=false, _arg4:Number=-1, _arg5:Number=-1, _arg6:int=-1):void
        {
            this.bg.graphics.clear();
            this.bg.graphics.beginFill((((_arg4 >= 0)) ? _arg4 : this.style.backgroundColor), (((_arg5 >= 0)) ? _arg5 : this.style.backgroundAlpha));
            if (_arg6 < 0)
            {
                _arg6 = this.style.roundBorder;
            };
            if (_arg6 <= 0)
            {
                this.bg.graphics.drawRect(0, 0, 100, 100);
            }
            else
            {
                this.bg.graphics.drawRoundRect(0, 0, (_arg6 + 10), (_arg6 + 10), _arg6, _arg6);
                this.bg.scale9Grid = new Rectangle((_arg6 * 0.5), (_arg6 * 0.5), 10, 10);
            };
            this.scalable = _arg3;
            this.width = _arg1;
            this.height = _arg2;
        }

        public function close():void
        {
            this.stopDragging();
            this.console.panels.tooltip();
            if (parent)
            {
                parent.removeChild(this);
            };
            dispatchEvent(new Event(Event.CLOSE));
        }

        override public function set visible(_arg1:Boolean):void
        {
            super.visible = _arg1;
            dispatchEvent(new Event(VISIBLITY_CHANGED));
        }

        override public function set width(_arg1:Number):void
        {
            if (_arg1 < this.minWidth)
            {
                _arg1 = this.minWidth;
            };
            if (this.scaler)
            {
                this.scaler.x = _arg1;
            };
            this.bg.width = _arg1;
        }

        override public function set height(_arg1:Number):void
        {
            if (_arg1 < this.minHeight)
            {
                _arg1 = this.minHeight;
            };
            if (this.scaler)
            {
                this.scaler.y = _arg1;
            };
            this.bg.height = _arg1;
        }

        override public function get width():Number
        {
            return (this.bg.width);
        }

        override public function get height():Number
        {
            return (this.bg.height);
        }

        public function registerSnaps(_arg1:Array, _arg2:Array):void
        {
            this._snaps = [_arg1, _arg2];
        }

        protected function registerDragger(_arg1:DisplayObject, _arg2:Boolean=false):void
        {
            if (_arg2)
            {
                _arg1.removeEventListener(MouseEvent.MOUSE_DOWN, this.onDraggerMouseDown);
            }
            else
            {
                _arg1.addEventListener(MouseEvent.MOUSE_DOWN, this.onDraggerMouseDown, false, 0, true);
            };
        }

        private function onDraggerMouseDown(_arg1:MouseEvent):void
        {
            if (((!(stage)) || (!(this.moveable))))
            {
                return;
            };
            this._resizeTxt = this.makeTF("positioningField", true);
            this._resizeTxt.mouseEnabled = false;
            this._resizeTxt.autoSize = TextFieldAutoSize.LEFT;
            addChild(this._resizeTxt);
            this.updateDragText();
            this._movedFrom = new Point(x, y);
            this._dragOffset = new Point(mouseX, mouseY);
            this._snaps = [[], []];
            dispatchEvent(new Event(DRAGGING_STARTED));
            stage.addEventListener(MouseEvent.MOUSE_UP, this.onDraggerMouseUp, false, 0, true);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onDraggerMouseMove, false, 0, true);
        }

        private function onDraggerMouseMove(_arg1:MouseEvent=null):void
        {
            if (this.style.panelSnapping == 0)
            {
                return;
            };
            var _local2:Point = this.returnSnappedFor((parent.mouseX - this._dragOffset.x), (parent.mouseY - this._dragOffset.y));
            x = _local2.x;
            y = _local2.y;
            this.updateDragText();
        }

        private function updateDragText():void
        {
            this._resizeTxt.text = (((("<low>" + x) + ",") + y) + "</low>");
        }

        private function onDraggerMouseUp(_arg1:MouseEvent):void
        {
            this.stopDragging();
        }

        private function stopDragging():void
        {
            this._snaps = null;
            if (stage)
            {
                stage.removeEventListener(MouseEvent.MOUSE_UP, this.onDraggerMouseUp);
                stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onDraggerMouseMove);
            };
            if (((this._resizeTxt) && (this._resizeTxt.parent)))
            {
                this._resizeTxt.parent.removeChild(this._resizeTxt);
            };
            this._resizeTxt = null;
            dispatchEvent(new Event(DRAGGING_ENDED));
        }

        public function moveBackSafePosition():void
        {
            if (this._movedFrom != null)
            {
                if (((((((((x + this.width) < 10)) || (((stage) && ((stage.stageWidth < (x + 10))))))) || (((y + this.height) < 10)))) || (((stage) && ((stage.stageHeight < (y + 20)))))))
                {
                    x = this._movedFrom.x;
                    y = this._movedFrom.y;
                };
                this._movedFrom = null;
            };
        }

        public function get scalable():Boolean
        {
            return (((this.scaler) ? true : false));
        }

        public function set scalable(_arg1:Boolean):void
        {
            var _local2:uint;
            if (((_arg1) && (!(this.scaler))))
            {
                _local2 = (8 + (this.style.controlSize * 0.5));
                this.scaler = new Sprite();
                this.scaler.name = "scaler";
                this.scaler.graphics.beginFill(0, 0);
                this.scaler.graphics.drawRect((-(_local2) * 1.5), (-(_local2) * 1.5), (_local2 * 1.5), (_local2 * 1.5));
                this.scaler.graphics.endFill();
                this.scaler.graphics.beginFill(this.style.controlColor, this.style.backgroundAlpha);
                this.scaler.graphics.moveTo(0, 0);
                this.scaler.graphics.lineTo(-(_local2), 0);
                this.scaler.graphics.lineTo(0, -(_local2));
                this.scaler.graphics.endFill();
                this.scaler.buttonMode = true;
                this.scaler.doubleClickEnabled = true;
                this.scaler.addEventListener(MouseEvent.MOUSE_DOWN, this.onScalerMouseDown, false, 0, true);
                addChildAt(this.scaler, (getChildIndex(this.bg) + 1));
            }
            else
            {
                if (((!(_arg1)) && (this.scaler)))
                {
                    if (contains(this.scaler))
                    {
                        removeChild(this.scaler);
                    };
                    this.scaler = null;
                };
            };
        }

        private function onScalerMouseDown(_arg1:Event):void
        {
            this._resizeTxt = this.makeTF("resizingField", true);
            this._resizeTxt.mouseEnabled = false;
            this._resizeTxt.autoSize = TextFieldAutoSize.RIGHT;
            this._resizeTxt.x = -4;
            this._resizeTxt.y = -17;
            this.scaler.addChild(this._resizeTxt);
            this.updateScaleText();
            this._dragOffset = new Point(this.scaler.mouseX, this.scaler.mouseY);
            this._snaps = [[], []];
            this.scaler.stage.addEventListener(MouseEvent.MOUSE_UP, this.onScalerMouseUp, false, 0, true);
            this.scaler.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.updateScale, false, 0, true);
            dispatchEvent(new Event(SCALING_STARTED));
        }

        private function updateScale(_arg1:Event=null):void
        {
            var _local2:Point = this.returnSnappedFor(((x + mouseX) - this._dragOffset.x), ((y + mouseY) - this._dragOffset.x));
            _local2.x = (_local2.x - x);
            _local2.y = (_local2.y - y);
            this.width = (((_local2.x < this.minWidth)) ? this.minWidth : _local2.x);
            this.height = (((_local2.y < this.minHeight)) ? this.minHeight : _local2.y);
            this.updateScaleText();
        }

        private function updateScaleText():void
        {
            this._resizeTxt.text = (((("<low>" + this.width) + ",") + this.height) + "</low>");
        }

        public function stopScaling():void
        {
            this.onScalerMouseUp(null);
        }

        private function onScalerMouseUp(_arg1:Event):void
        {
            this.scaler.stage.removeEventListener(MouseEvent.MOUSE_UP, this.onScalerMouseUp);
            this.scaler.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.updateScale);
            this.updateScale();
            this._snaps = null;
            if (((this._resizeTxt) && (this._resizeTxt.parent)))
            {
                this._resizeTxt.parent.removeChild(this._resizeTxt);
            };
            this._resizeTxt = null;
            dispatchEvent(new Event(SCALING_ENDED));
        }

        public function makeTF(_arg1:String, _arg2:Boolean=false):TextField
        {
            var _local3:TextField = new TextField();
            _local3.name = _arg1;
            _local3.styleSheet = this.style.styleSheet;
            if (_arg2)
            {
                _local3.background = true;
                _local3.backgroundColor = this.style.backgroundColor;
            };
            return (_local3);
        }

        private function returnSnappedFor(_arg1:Number, _arg2:Number):Point
        {
            return (new Point(this.getSnapOf(_arg1, true), this.getSnapOf(_arg2, false)));
        }

        private function getSnapOf(_arg1:Number, _arg2:Boolean):Number
        {
            var _local6:Number;
            var _local3:Number = (_arg1 + this.width);
            var _local4:Array = this._snaps[((_arg2) ? 0 : 1)];
            var _local5:int = this.style.panelSnapping;
            for each (_local6 in _local4)
            {
                if (Math.abs((_local6 - _arg1)) < _local5)
                {
                    return (_local6);
                };
                if (Math.abs((_local6 - _local3)) < _local5)
                {
                    return ((_local6 - this.width));
                };
            };
            return (_arg1);
        }

        protected function registerTFRoller(_arg1:TextField, _arg2:Function, _arg3:Function=null):void
        {
            _arg1.addEventListener(MouseEvent.MOUSE_MOVE, onTextFieldMouseMove, false, 0, true);
            _arg1.addEventListener(MouseEvent.ROLL_OUT, onTextFieldMouseOut, false, 0, true);
            _arg1.addEventListener(TEXT_ROLL, _arg2, false, 0, true);
            if (_arg3 != null)
            {
                _arg1.addEventListener(TextEvent.LINK, _arg3, false, 0, true);
            };
        }


    }
}

