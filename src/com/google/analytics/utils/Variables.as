package com.google.analytics.utils
{
    import flash.net.URLVariables;

    public dynamic class Variables 
    {

        public var post:Array;
        public var URIencode:Boolean;
        public var pre:Array;
        public var sort:Boolean = true;

        public function Variables(_arg1:String=null, _arg2:Array=null, _arg3:Array=null)
        {
            pre = [];
            post = [];
            super();
            if (_arg1)
            {
                decode(_arg1);
            };
            if (_arg2)
            {
                this.pre = _arg2;
            };
            if (_arg3)
            {
                this.post = _arg3;
            };
        }

        private function _join(_arg1:Variables):void
        {
            var _local2:String;
            if (!_arg1)
            {
                return;
            };
            for (_local2 in _arg1)
            {
                this[_local2] = _arg1[_local2];
            };
        }

        public function join(... _args):void
        {
            var _local2:int = _args.length;
            var _local3:int;
            while (_local3 < _local2)
            {
                if ((_args[_local3] is Variables))
                {
                    _join(_args[_local3]);
                };
                _local3++;
            };
        }

        public function toString():String
        {
            var _local2:String;
            var _local3:String;
            var _local4:String;
            var _local5:int;
            var _local6:int;
            var _local7:String;
            var _local8:String;
            var _local1:Array = [];
            for (_local3 in this)
            {
                _local2 = this[_local3];
                if (URIencode)
                {
                    _local2 = encodeURI(_local2);
                };
                _local1.push(((_local3 + "=") + _local2));
            };
            if (sort)
            {
                _local1.sort();
            };
            if (pre.length > 0)
            {
                pre.reverse();
                _local5 = 0;
                while (_local5 < pre.length)
                {
                    _local7 = pre[_local5];
                    _local6 = 0;
                    while (_local6 < _local1.length)
                    {
                        _local4 = _local1[_local6];
                        if (_local4.indexOf(_local7) == 0)
                        {
                            _local1.unshift(_local1.splice(_local6, 1)[0]);
                        };
                        _local6++;
                    };
                    _local5++;
                };
                pre.reverse();
            };
            if (post.length > 0)
            {
                _local5 = 0;
                while (_local5 < post.length)
                {
                    _local8 = post[_local5];
                    _local6 = 0;
                    while (_local6 < _local1.length)
                    {
                        _local4 = _local1[_local6];
                        if (_local4.indexOf(_local8) == 0)
                        {
                            _local1.push(_local1.splice(_local6, 1)[0]);
                        };
                        _local6++;
                    };
                    _local5++;
                };
            };
            return (_local1.join("&"));
        }

        public function decode(_arg1:String):void
        {
            var _local2:Array;
            var _local3:String;
            var _local4:String;
            var _local5:String;
            var _local6:Array;
            if (_arg1 == "")
            {
                return;
            };
            if (_arg1.charAt(0) == "?")
            {
                _arg1 = _arg1.substr(1, _arg1.length);
            };
            if (_arg1.indexOf("&") > -1)
            {
                _local2 = _arg1.split("&");
            }
            else
            {
                _local2 = [_arg1];
            };
            var _local7:int;
            while (_local7 < _local2.length)
            {
                _local3 = _local2[_local7];
                if (_local3.indexOf("=") > -1)
                {
                    _local6 = _local3.split("=");
                    _local4 = _local6[0];
                    _local5 = decodeURI(_local6[1]);
                    this[_local4] = _local5;
                };
                _local7++;
            };
        }

        public function toURLVariables():URLVariables
        {
            var _local2:String;
            var _local1:URLVariables = new URLVariables();
            for (_local2 in this)
            {
                _local1[_local2] = this[_local2];
            };
            return (_local1);
        }


    }
}

