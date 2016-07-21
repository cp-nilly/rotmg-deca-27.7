package com.google.analytics.debug
{
    import flash.events.TextEvent;

    public class Alert extends Label 
    {

        public var autoClose:Boolean = true;
        public var actionOnNextLine:Boolean = true;
        private var _actions:Array;

        public function Alert(_arg1:String, _arg2:Array, _arg3:String="uiAlert", _arg4:uint=0, _arg5:Align=null, _arg6:Boolean=false, _arg7:Boolean=true)
        {
            if (_arg4 == 0)
            {
                _arg4 = Style.alertColor;
            };
            if (_arg5 == null)
            {
                _arg5 = Align.center;
            };
            super(_arg1, _arg3, _arg4, _arg5, _arg6);
            this.selectable = true;
            super.mouseChildren = true;
            this.buttonMode = true;
            this.mouseEnabled = true;
            this.useHandCursor = true;
            this.actionOnNextLine = _arg7;
            _actions = [];
            var _local8:int;
            while (_local8 < _arg2.length)
            {
                _arg2[_local8].container = this;
                _actions.push(_arg2[_local8]);
                _local8++;
            };
        }

        private function _defineActions():void
        {
            var _local3:AlertAction;
            var _local1 = "";
            if (actionOnNextLine)
            {
                _local1 = (_local1 + "\n");
            }
            else
            {
                _local1 = (_local1 + " |");
            };
            _local1 = (_local1 + " ");
            var _local2:Array = [];
            var _local4:int;
            while (_local4 < _actions.length)
            {
                _local3 = _actions[_local4];
                _local2.push((((('<a href="event:' + _local3.activator) + '">') + _local3.name) + "</a>"));
                _local4++;
            };
            _local1 = (_local1 + _local2.join(" | "));
            appendText(_local1, "uiAlertAction");
        }

        protected function isValidAction(_arg1:String):Boolean
        {
            var _local2:int;
            while (_local2 < _actions.length)
            {
                if (_arg1 == _actions[_local2].activator)
                {
                    return (true);
                };
                _local2++;
            };
            return (false);
        }

        override protected function layout():void
        {
            super.layout();
            _defineActions();
        }

        protected function getAction(_arg1:String):AlertAction
        {
            var _local2:int;
            while (_local2 < _actions.length)
            {
                if (_arg1 == _actions[_local2].activator)
                {
                    return (_actions[_local2]);
                };
                _local2++;
            };
            return (null);
        }

        protected function spaces(_arg1:int):String
        {
            var _local2 = "";
            var _local3 = "          ";
            var _local4:int;
            while (_local4 < (_arg1 + 1))
            {
                _local2 = (_local2 + _local3);
                _local4++;
            };
            return (_local2);
        }

        override public function onLink(_arg1:TextEvent):void
        {
            var _local2:AlertAction;
            if (isValidAction(_arg1.text))
            {
                _local2 = getAction(_arg1.text);
                if (_local2)
                {
                    _local2.execute();
                };
            };
            if (autoClose)
            {
                close();
            };
        }

        public function close():void
        {
            if (parent != null)
            {
                parent.removeChild(this);
            };
        }


    }
}

