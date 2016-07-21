package com.google.analytics.debug
{
    import flash.display.DisplayObject;
    import flash.events.KeyboardEvent;
    import flash.events.Event;
    import com.google.analytics.GATracker;
    import flash.net.URLRequest;
    import com.google.analytics.core.GIFRequest;

    public class Layout implements ILayout 
    {

        private var _display:DisplayObject;
        private var _infoQueue:Array;
        private var _maxCharPerLine:int = 85;
        private var _hasInfo:Boolean;
        private var _warningQueue:Array;
        private var _hasDebug:Boolean;
        private var _hasWarning:Boolean;
        private var _mainPanel:Panel;
        private var _GRAlertQueue:Array;
        private var _debug:DebugConfiguration;
        public var visualDebug:Debug;
        private var _hasGRAlert:Boolean;

        public function Layout(_arg1:DebugConfiguration, _arg2:DisplayObject)
        {
            _display = _arg2;
            _debug = _arg1;
            _hasWarning = false;
            _hasInfo = false;
            _hasDebug = false;
            _hasGRAlert = false;
            _warningQueue = [];
            _infoQueue = [];
            _GRAlertQueue = [];
        }

        private function onKey(_arg1:KeyboardEvent=null):void
        {
            switch (_arg1.keyCode)
            {
                case _debug.showHideKey:
                    _mainPanel.visible = !(_mainPanel.visible);
                    return;
                case _debug.destroyKey:
                    destroy();
                    return;
            };
        }

        public function createWarning(_arg1:String):void
        {
            if (((_hasWarning) || (!(isAvailable()))))
            {
                _warningQueue.push(_arg1);
                return;
            };
            _arg1 = _filterMaxChars(_arg1);
            _hasWarning = true;
            var _local2:Warning = new Warning(_arg1, _debug.warningTimeout);
            addToPanel("analytics", _local2);
            _local2.addEventListener(Event.REMOVED_FROM_STAGE, _clearWarning, false, 0, true);
            if (_hasDebug)
            {
                visualDebug.writeBold(_arg1);
            };
        }

        public function bringToFront(_arg1:DisplayObject):void
        {
            _display.stage.setChildIndex(_arg1, (_display.stage.numChildren - 1));
        }

        public function createFailureAlert(_arg1:String):void
        {
            var _local2:AlertAction;
            if (_debug.verbose)
            {
                _arg1 = _filterMaxChars(_arg1);
                _local2 = new AlertAction("Close", "close", "close");
            }
            else
            {
                _local2 = new AlertAction("X", "close", "close");
            };
            var _local3:Alert = new FailureAlert(_debug, _arg1, [_local2]);
            addToPanel("analytics", _local3);
            if (_hasDebug)
            {
                if (_debug.verbose)
                {
                    _arg1 = _arg1.split("\n").join("");
                    _arg1 = _filterMaxChars(_arg1, 66);
                };
                visualDebug.writeBold(_arg1);
            };
        }

        public function init():void
        {
            var _local1:int = 10;
            var _local2:uint = (_display.stage.stageWidth - (_local1 * 2));
            var _local3:uint = (_display.stage.stageHeight - (_local1 * 2));
            var _local4:Panel = new Panel("analytics", _local2, _local3);
            _local4.alignement = Align.top;
            _local4.stickToEdge = false;
            _local4.title = ("Google Analytics v" + GATracker.version);
            _mainPanel = _local4;
            addToStage(_local4);
            bringToFront(_local4);
            if (_debug.minimizedOnStart)
            {
                _mainPanel.onToggle();
            };
            createVisualDebug();
            _display.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey, false, 0, true);
        }

        public function addToPanel(_arg1:String, _arg2:DisplayObject):void
        {
            var _local4:Panel;
            var _local3:DisplayObject = _display.stage.getChildByName(_arg1);
            if (_local3)
            {
                _local4 = (_local3 as Panel);
                _local4.addData(_arg2);
            }
            else
            {
                trace((('panel "' + _arg1) + '" not found'));
            };
        }

        private function _clearInfo(_arg1:Event):void
        {
            _hasInfo = false;
            if (_infoQueue.length > 0)
            {
                createInfo(_infoQueue.shift());
            };
        }

        private function _filterMaxChars(_arg1:String, _arg2:int=0):String
        {
            var _local6:String;
            var _local3 = "\n";
            var _local4:Array = [];
            var _local5:Array = _arg1.split(_local3);
            if (_arg2 == 0)
            {
                _arg2 = _maxCharPerLine;
            };
            var _local7:int;
            while (_local7 < _local5.length)
            {
                _local6 = _local5[_local7];
                while (_local6.length > _arg2)
                {
                    _local4.push(_local6.substr(0, _arg2));
                    _local6 = _local6.substring(_arg2);
                };
                _local4.push(_local6);
                _local7++;
            };
            return (_local4.join(_local3));
        }

        private function _clearGRAlert(_arg1:Event):void
        {
            _hasGRAlert = false;
            if (_GRAlertQueue.length > 0)
            {
                createGIFRequestAlert.apply(this, _GRAlertQueue.shift());
            };
        }

        public function createSuccessAlert(_arg1:String):void
        {
            var _local2:AlertAction;
            if (_debug.verbose)
            {
                _arg1 = _filterMaxChars(_arg1);
                _local2 = new AlertAction("Close", "close", "close");
            }
            else
            {
                _local2 = new AlertAction("X", "close", "close");
            };
            var _local3:Alert = new SuccessAlert(_debug, _arg1, [_local2]);
            addToPanel("analytics", _local3);
            if (_hasDebug)
            {
                if (_debug.verbose)
                {
                    _arg1 = _arg1.split("\n").join("");
                    _arg1 = _filterMaxChars(_arg1, 66);
                };
                visualDebug.writeBold(_arg1);
            };
        }

        public function isAvailable():Boolean
        {
            return (!((_display.stage == null)));
        }

        public function createAlert(_arg1:String):void
        {
            _arg1 = _filterMaxChars(_arg1);
            var _local2:Alert = new Alert(_arg1, [new AlertAction("Close", "close", "close")]);
            addToPanel("analytics", _local2);
            if (_hasDebug)
            {
                visualDebug.writeBold(_arg1);
            };
        }

        public function createInfo(_arg1:String):void
        {
            if (((_hasInfo) || (!(isAvailable()))))
            {
                _infoQueue.push(_arg1);
                return;
            };
            _arg1 = _filterMaxChars(_arg1);
            _hasInfo = true;
            var _local2:Info = new Info(_arg1, _debug.infoTimeout);
            addToPanel("analytics", _local2);
            _local2.addEventListener(Event.REMOVED_FROM_STAGE, _clearInfo, false, 0, true);
            if (_hasDebug)
            {
                visualDebug.write(_arg1);
            };
        }

        public function createGIFRequestAlert(message:String, request:URLRequest, ref:GIFRequest):void
        {
            if (_hasGRAlert)
            {
                _GRAlertQueue.push([message, request, ref]);
                return;
            };
            _hasGRAlert = true;
            var f:Function = function ():void
            {
                ref.sendRequest(request);
            };
            message = _filterMaxChars(message);
            var gra:GIFRequestAlert = new GIFRequestAlert(message, [new AlertAction("OK", "ok", f), new AlertAction("Cancel", "cancel", "close")]);
            addToPanel("analytics", gra);
            gra.addEventListener(Event.REMOVED_FROM_STAGE, _clearGRAlert, false, 0, true);
            if (_hasDebug)
            {
                if (_debug.verbose)
                {
                    message = message.split("\n").join("");
                    message = _filterMaxChars(message, 66);
                };
                visualDebug.write(message);
            };
        }

        public function createVisualDebug():void
        {
            if (!visualDebug)
            {
                visualDebug = new Debug();
                visualDebug.alignement = Align.bottom;
                visualDebug.stickToEdge = true;
                addToPanel("analytics", visualDebug);
                _hasDebug = true;
            };
        }

        public function addToStage(_arg1:DisplayObject):void
        {
            _display.stage.addChild(_arg1);
        }

        private function _clearWarning(_arg1:Event):void
        {
            _hasWarning = false;
            if (_warningQueue.length > 0)
            {
                createWarning(_warningQueue.shift());
            };
        }

        public function createPanel(_arg1:String, _arg2:uint, _arg3:uint):void
        {
            var _local4:Panel = new Panel(_arg1, _arg2, _arg3);
            _local4.alignement = Align.center;
            _local4.stickToEdge = false;
            addToStage(_local4);
            bringToFront(_local4);
        }

        public function destroy():void
        {
            _mainPanel.close();
            _debug.layout = null;
        }


    }
}

