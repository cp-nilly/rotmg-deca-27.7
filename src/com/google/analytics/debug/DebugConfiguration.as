package com.google.analytics.debug
{
    import flash.ui.Keyboard;
    import flash.utils.getTimer;
    import flash.net.URLRequest;
    import com.google.analytics.core.GIFRequest;

    public class DebugConfiguration 
    {

        public var showHideKey:Number;
        private var _mode:VisualDebugMode;
        private var _verbose:Boolean = false;
        public var destroyKey:Number;
        public var GIFRequests:Boolean = false;
        public var showInfos:Boolean = true;
        public var infoTimeout:Number = 1000;
        public var minimizedOnStart:Boolean = false;
        private var _active:Boolean = false;
        public var traceOutput:Boolean = false;
        public var layout:ILayout;
        public var warningTimeout:Number = 1500;
        public var javascript:Boolean = false;
        public var showWarnings:Boolean = true;
        private var _visualInitialized:Boolean = false;

        public function DebugConfiguration()
        {
            _mode = VisualDebugMode.basic;
            showHideKey = Keyboard.SPACE;
            destroyKey = Keyboard.BACKSPACE;
            super();
        }

        public function get verbose():Boolean
        {
            return (_verbose);
        }

        public function set verbose(_arg1:Boolean):void
        {
            _verbose = _arg1;
        }

        public function set mode(_arg1:*):void
        {
            if ((_arg1 is String))
            {
                switch (_arg1)
                {
                    case "geek":
                        _arg1 = VisualDebugMode.geek;
                        break;
                    case "advanced":
                        _arg1 = VisualDebugMode.advanced;
                        break;
                    case "basic":
                    default:
                        _arg1 = VisualDebugMode.basic;
                };
            };
            _mode = _arg1;
        }

        public function success(_arg1:String):void
        {
            if (layout)
            {
                layout.createSuccessAlert(_arg1);
            };
            if (traceOutput)
            {
                trace((("[+] " + _arg1) + " !!"));
            };
        }

        public function get active():Boolean
        {
            return (_active);
        }

        private function _initializeVisual():void
        {
            if (layout)
            {
                layout.init();
                _visualInitialized = true;
            };
        }

        private function _destroyVisual():void
        {
            if (((layout) && (_visualInitialized)))
            {
                layout.destroy();
            };
        }

        public function warning(_arg1:String, _arg2:VisualDebugMode=null):void
        {
            if (_filter(_arg2))
            {
                return;
            };
            if (((layout) && (showWarnings)))
            {
                layout.createWarning(_arg1);
            };
            if (traceOutput)
            {
                trace((("## " + _arg1) + " ##"));
            };
        }

        private function _filter(_arg1:VisualDebugMode=null):Boolean
        {
            return (((_arg1) && ((int(_arg1) >= int(this.mode)))));
        }

        public function failure(_arg1:String):void
        {
            if (layout)
            {
                layout.createFailureAlert(_arg1);
            };
            if (traceOutput)
            {
                trace((("[-] " + _arg1) + " !!"));
            };
        }

        public function get mode()
        {
            return (_mode);
        }

        public function set active(_arg1:Boolean):void
        {
            _active = _arg1;
            if (_active)
            {
                _initializeVisual();
            }
            else
            {
                _destroyVisual();
            };
        }

        protected function trace(_arg1:String):void
        {
            var _local7:Array;
            var _local8:int;
            var _local2:Array = [];
            var _local3 = "";
            var _local4 = "";
            if (this.mode == VisualDebugMode.geek)
            {
                _local3 = (getTimer() + " - ");
                _local4 = (new Array(_local3.length).join(" ") + " ");
            };
            if (_arg1.indexOf("\n") > -1)
            {
                _local7 = _arg1.split("\n");
                _local8 = 0;
                while (_local8 < _local7.length)
                {
                    if (_local7[_local8] != "")
                    {
                        if (_local8 == 0)
                        {
                            _local2.push((_local3 + _local7[_local8]));
                        }
                        else
                        {
                            _local2.push((_local4 + _local7[_local8]));
                        };
                    };
                    _local8++;
                };
            }
            else
            {
                _local2.push((_local3 + _arg1));
            };
            var _local5:int = _local2.length;
            var _local6:int;
            while (_local6 < _local5)
            {
                trace(_local2[_local6]);
                _local6++;
            };
        }

        public function alert(_arg1:String):void
        {
            if (layout)
            {
                layout.createAlert(_arg1);
            };
            if (traceOutput)
            {
                trace((("!! " + _arg1) + " !!"));
            };
        }

        public function info(_arg1:String, _arg2:VisualDebugMode=null):void
        {
            if (_filter(_arg2))
            {
                return;
            };
            if (((layout) && (showInfos)))
            {
                layout.createInfo(_arg1);
            };
            if (traceOutput)
            {
                trace(_arg1);
            };
        }

        public function alertGifRequest(_arg1:String, _arg2:URLRequest, _arg3:GIFRequest):void
        {
            if (layout)
            {
                layout.createGIFRequestAlert(_arg1, _arg2, _arg3);
            };
            if (traceOutput)
            {
                trace(((">> " + _arg1) + " <<"));
            };
        }


    }
}

