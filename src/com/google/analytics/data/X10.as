package com.google.analytics.data
{
    public class X10 
    {

        private var _delimEnd:String = ")";
        private var _minimum:int;
        private var _delimSet:String = "*";
        private var _escapeChar:String = "'";
        private var _delimBegin:String = "(";
        private var _delimNumValue:String = "!";
        private var _key:String = "k";
        private var _set:Array;
        private var _hasData:int;
        private var _escapeCharMap:Object;
        private var _projectData:Object;
        private var _value:String = "v";

        public function X10()
        {
            _set = [_key, _value];
            super();
            _projectData = {};
            _escapeCharMap = {};
            _escapeCharMap[_escapeChar] = "'0";
            _escapeCharMap[_delimEnd] = "'1";
            _escapeCharMap[_delimSet] = "'2";
            _escapeCharMap[_delimNumValue] = "'3";
            _minimum = 1;
        }

        private function _setInternal(_arg1:Number, _arg2:String, _arg3:Number, _arg4:String):void
        {
            if (!hasProject(_arg1))
            {
                _projectData[_arg1] = {};
            };
            if (_projectData[_arg1][_arg2] == undefined)
            {
                _projectData[_arg1][_arg2] = [];
            };
            _projectData[_arg1][_arg2][_arg3] = _arg4;
            _hasData = (_hasData + 1);
        }

        private function _renderProject(_arg1:Object):String
        {
            var _local4:int;
            var _local5:Array;
            var _local2 = "";
            var _local3:Boolean;
            var _local6:int = _set.length;
            _local4 = 0;
            while (_local4 < _local6)
            {
                _local5 = _arg1[_set[_local4]];
                if (_local5)
                {
                    if (_local3)
                    {
                        _local2 = (_local2 + _set[_local4]);
                    };
                    _local2 = (_local2 + _renderDataType(_local5));
                    _local3 = false;
                }
                else
                {
                    _local3 = true;
                };
                _local4++;
            };
            return (_local2);
        }

        public function hasProject(_arg1:Number):Boolean
        {
            return (_projectData[_arg1]);
        }

        public function clearKey(_arg1:Number):void
        {
            _clearInternal(_arg1, _key);
        }

        private function _renderDataType(_arg1:Array):String
        {
            var _local3:String;
            var _local4:int;
            var _local2:Array = [];
            _local4 = 0;
            while (_local4 < _arg1.length)
            {
                if (_arg1[_local4] != undefined)
                {
                    _local3 = "";
                    if (((!((_local4 == _minimum))) && ((_arg1[(_local4 - 1)] == undefined))))
                    {
                        _local3 = (_local3 + _local4.toString());
                        _local3 = (_local3 + _delimNumValue);
                    };
                    _local3 = (_local3 + _escapeExtensibleValue(_arg1[_local4]));
                    _local2.push(_local3);
                };
                _local4++;
            };
            return (((_delimBegin + _local2.join(_delimSet)) + _delimEnd));
        }

        public function getKey(_arg1:Number, _arg2:Number):String
        {
            return ((_getInternal(_arg1, _key, _arg2) as String));
        }

        public function hasData():Boolean
        {
            return ((_hasData > 0));
        }

        public function renderMergedUrlString(_arg1:X10=null):String
        {
            var _local3:String;
            if (!_arg1)
            {
                return (renderUrlString());
            };
            var _local2:Array = [_arg1.renderUrlString()];
            for (_local3 in _projectData)
            {
                if (((hasProject(Number(_local3))) && (!(_arg1.hasProject(Number(_local3))))))
                {
                    _local2.push((_local3 + _renderProject(_projectData[_local3])));
                };
            };
            return (_local2.join(""));
        }

        public function setValue(_arg1:Number, _arg2:Number, _arg3:Number):Boolean
        {
            if (((((!((Math.round(_arg3) == _arg3))) || (isNaN(_arg3)))) || ((_arg3 == Infinity))))
            {
                return (false);
            };
            _setInternal(_arg1, _value, _arg2, _arg3.toString());
            return (true);
        }

        public function renderUrlString():String
        {
            var _local2:String;
            var _local1:Array = [];
            for (_local2 in _projectData)
            {
                if (hasProject(Number(_local2)))
                {
                    _local1.push((_local2 + _renderProject(_projectData[_local2])));
                };
            };
            return (_local1.join(""));
        }

        private function _getInternal(_arg1:Number, _arg2:String, _arg3:Number):Object
        {
            if (((hasProject(_arg1)) && (!((_projectData[_arg1][_arg2] == undefined)))))
            {
                return (_projectData[_arg1][_arg2][_arg3]);
            };
            return (undefined);
        }

        public function setKey(_arg1:Number, _arg2:Number, _arg3:String):Boolean
        {
            _setInternal(_arg1, _key, _arg2, _arg3);
            return (true);
        }

        public function clearValue(_arg1:Number):void
        {
            _clearInternal(_arg1, _value);
        }

        private function _clearInternal(_arg1:Number, _arg2:String):void
        {
            var _local3:Boolean;
            var _local4:int;
            var _local5:int;
            if (((hasProject(_arg1)) && (!((_projectData[_arg1][_arg2] == undefined)))))
            {
                _projectData[_arg1][_arg2] = undefined;
                _local3 = true;
                _local5 = _set.length;
                _local4 = 0;
                while (_local4 < _local5)
                {
                    if (_projectData[_arg1][_set[_local4]] != undefined)
                    {
                        _local3 = false;
                        break;
                    };
                    _local4++;
                };
                if (_local3)
                {
                    _projectData[_arg1] = undefined;
                    _hasData = (_hasData - 1);
                };
            };
        }

        public function getValue(_arg1:Number, _arg2:Number)
        {
            var _local3:* = _getInternal(_arg1, _value, _arg2);
            if (_local3 == null)
            {
                return (null);
            };
            return (Number(_local3));
        }

        private function _escapeExtensibleValue(_arg1:String):String
        {
            var _local3:int;
            var _local4:String;
            var _local5:String;
            var _local2 = "";
            _local3 = 0;
            while (_local3 < _arg1.length)
            {
                _local4 = _arg1.charAt(_local3);
                _local5 = _escapeCharMap[_local4];
                if (_local5)
                {
                    _local2 = (_local2 + _local5);
                }
                else
                {
                    _local2 = (_local2 + _local4);
                };
                _local3++;
            };
            return (_local2);
        }


    }
}

