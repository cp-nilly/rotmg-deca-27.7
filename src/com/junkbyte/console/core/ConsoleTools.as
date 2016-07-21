package com.junkbyte.console.core
{
    import com.junkbyte.console.Console;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.utils.ByteArray;
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;
    import com.junkbyte.console.Cc;

    public class ConsoleTools extends ConsoleCore 
    {

        public function ConsoleTools(_arg1:Console)
        {
            super(_arg1);
        }

        public function map(_arg1:DisplayObjectContainer, _arg2:uint=0, _arg3:String=null):void
        {
            var _local5:Boolean;
            var _local9:DisplayObject;
            var _local10:String;
            var _local11:DisplayObjectContainer;
            var _local12:int;
            var _local13:int;
            var _local14:DisplayObject;
            var _local15:uint;
            var _local16:String;
            if (!_arg1)
            {
                report("Not a DisplayObjectContainer.", 10, true, _arg3);
                return;
            };
            var _local4:int;
            var _local6:int;
            var _local7:DisplayObject;
            var _local8:Array = new Array();
            _local8.push(_arg1);
            while (_local6 < _local8.length)
            {
                _local9 = _local8[_local6];
                _local6++;
                if ((_local9 is DisplayObjectContainer))
                {
                    _local11 = (_local9 as DisplayObjectContainer);
                    _local12 = _local11.numChildren;
                    _local13 = 0;
                    while (_local13 < _local12)
                    {
                        _local14 = _local11.getChildAt(_local13);
                        _local8.splice((_local6 + _local13), 0, _local14);
                        _local13++;
                    };
                };
                if (_local7)
                {
                    if ((((_local7 is DisplayObjectContainer)) && ((_local7 as DisplayObjectContainer).contains(_local9))))
                    {
                        _local4++;
                    }
                    else
                    {
                        while (_local7)
                        {
                            _local7 = _local7.parent;
                            if ((_local7 is DisplayObjectContainer))
                            {
                                if (_local4 > 0)
                                {
                                    _local4--;
                                };
                                if ((_local7 as DisplayObjectContainer).contains(_local9))
                                {
                                    _local4++;
                                    break;
                                };
                            };
                        };
                    };
                };
                _local10 = "";
                _local13 = 0;
                while (_local13 < _local4)
                {
                    _local10 = (_local10 + (((_local13)==(_local4 - 1)) ? " ∟ " : " - "));
                    _local13++;
                };
                if ((((_arg2 <= 0)) || ((_local4 <= _arg2))))
                {
                    _local5 = false;
                    _local15 = console.refs.setLogRef(_local9);
                    _local16 = _local9.name;
                    if (_local15)
                    {
                        _local16 = (((("<a href='event:cl_" + _local15) + "'>") + _local16) + "</a>");
                    };
                    if ((_local9 is DisplayObjectContainer))
                    {
                        _local16 = (("<b>" + _local16) + "</b>");
                    }
                    else
                    {
                        _local16 = (("<i>" + _local16) + "</i>");
                    };
                    _local10 = (_local10 + ((_local16 + " ") + console.refs.makeRefTyped(_local9)));
                    report(_local10, (((_local9 is DisplayObjectContainer)) ? 5 : 2), true, _arg3);
                }
                else
                {
                    if (!_local5)
                    {
                        _local5 = true;
                        report((_local10 + "..."), 5, true, _arg3);
                    };
                };
                _local7 = _local9;
            };
            report((((((_arg1.name + ":") + console.refs.makeRefTyped(_arg1)) + " has ") + (_local8.length - 1)) + " children/sub-children."), 9, true, _arg3);
            if (config.commandLineAllowed)
            {
                report("Click on the child display's name to set scope.", -2, true, _arg3);
            };
        }

        public function explode(_arg1:Object, _arg2:int=3, _arg3:int=9):String
        {
            var _local6:XMLList;
            var _local7:String;
            var _local9:XML;
            var _local10:XML;
            var _local11:String;
            var _local4 = typeof(_arg1);
            if (_arg1 == null)
            {
                return ((("<p-2>" + _arg1) + "</p-2>"));
            };
            if ((_arg1 is String))
            {
                return ((('"' + LogReferences.EscHTML((_arg1 as String))) + '"'));
            };
            if (((((!((_local4 == "object"))) || ((_arg2 == 0)))) || ((_arg1 is ByteArray))))
            {
                return (console.refs.makeString(_arg1));
            };
            if (_arg3 < 0)
            {
                _arg3 = 0;
            };
            var _local5:XML = describeType(_arg1);
            var _local8:Array = [];
            _local6 = _local5["accessor"];
            for each (_local9 in _local6)
            {
                _local7 = _local9.@name;
                if (_local9.@access != "writeonly")
                {
                    try
                    {
                        _local8.push(this.stepExp(_arg1, _local7, _arg2, _arg3));
                    }
                    catch(e:Error)
                    {
                    };
                }
                else
                {
                    _local8.push(_local7);
                };
            };
            _local6 = _local5["variable"];
            for each (_local10 in _local6)
            {
                _local7 = _local10.@name;
                _local8.push(this.stepExp(_arg1, _local7, _arg2, _arg3));
            };
            try
            {
                for (_local11 in _arg1)
                {
                    _local8.push(this.stepExp(_arg1, _local11, _arg2, _arg3));
                };
            }
            catch(e:Error)
            {
            };
            return ((((((((((((("<p" + _arg3) + ">{") + LogReferences.ShortClassName(_arg1)) + "</p") + _arg3) + "> ") + _local8.join(", ")) + "<p") + _arg3) + ">}</p") + _arg3) + ">"));
        }

        private function stepExp(_arg1:*, _arg2:String, _arg3:int, _arg4:int):String
        {
            return (((_arg2 + ":") + this.explode(_arg1[_arg2], (_arg3 - 1), (_arg4 - 1))));
        }

        public function getStack(_arg1:int, _arg2:int):String
        {
            var _local3:Error = new Error();
            var _local4:String = ((_local3.hasOwnProperty("getStackTrace")) ? _local3.getStackTrace() : null);
            if (!_local4)
            {
                return ("");
            };
            var _local5 = "";
            var _local6:Array = _local4.split(/\n\sat\s/);
            var _local7:int = _local6.length;
            var _local8:RegExp = new RegExp(((("Function|" + getQualifiedClassName(Console)) + "|") + getQualifiedClassName(Cc)));
            var _local9:Boolean;
            var _local10:int = 2;
            while (_local10 < _local7)
            {
                if (((!(_local9)) && (!((_local6[_local10].search(_local8) == 0)))))
                {
                    _local9 = true;
                };
                if (_local9)
                {
                    _local5 = (_local5 + (((((("\n<p" + _arg2) + "> @ ") + _local6[_local10]) + "</p") + _arg2) + ">"));
                    if (_arg2 > 0)
                    {
                        _arg2--;
                    };
                    _arg1--;
                    if (_arg1 <= 0) break;
                };
                _local10++;
            };
            return (_local5);
        }


    }
}

