package com.junkbyte.console.core
{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.utils.getDefinitionByName;
    import com.junkbyte.console.vos.WeakObject;

    public class Executer extends EventDispatcher 
    {

        public static const RETURNED:String = "returned";
        public static const CLASSES:String = "ExeValue|((com.junkbyte.console.core::)?Executer)";
        private static const VALKEY:String = "#";

        private var _values:Array;
        private var _running:Boolean;
        private var _scope;
        private var _returned;
        private var _saved:Object;
        private var _reserved:Array;
        public var autoScope:Boolean;


        public static function Exec(_arg1:Object, _arg2:String, _arg3:Object=null)
        {
            var _local4:Executer = new (Executer)();
            _local4.setStored(_arg3);
            return (_local4.exec(_arg1, _arg2));
        }


        public function get returned()
        {
            return (this._returned);
        }

        public function get scope()
        {
            return (this._scope);
        }

        public function setStored(_arg1:Object):void
        {
            this._saved = _arg1;
        }

        public function setReserved(_arg1:Array):void
        {
            this._reserved = _arg1;
        }

        public function exec(s:*, str:String)
        {
            if (this._running)
            {
                throw (new Error("CommandExec.exec() is already runnnig. Does not support loop backs."));
            };
            this._running = true;
            this._scope = s;
            this._values = [];
            if (!this._saved)
            {
                this._saved = new Object();
            };
            if (!this._reserved)
            {
                this._reserved = new Array();
            };
            try
            {
                this._exec(str);
            }
            catch(e:Error)
            {
                reset();
                throw (e);
            };
            this.reset();
            return (this._returned);
        }

        private function reset():void
        {
            this._saved = null;
            this._reserved = null;
            this._values = null;
            this._running = false;
        }

        private function _exec(_arg1:String):void
        {
            var _local5:String;
            var _local6:String;
            var _local7:String;
            var _local8:int;
            var _local9:int;
            var _local10:String;
            var _local11:*;
            var _local2:RegExp = /''|""|('(.*?)[^\\]')|("(.*?)[^\\]")/;
            var _local3:Object = _local2.exec(_arg1);
            while (_local3 != null)
            {
                _local6 = _local3[0];
                _local7 = _local6.charAt(0);
                _local8 = _local6.indexOf(_local7);
                _local9 = _local6.lastIndexOf(_local7);
                _local10 = _local6.substring((_local8 + 1), _local9).replace(/\\(.)/g, "$1");
                _arg1 = this.tempValue(_arg1, new ExeValue(_local10), (_local3.index + _local8), ((_local3.index + _local9) + 1));
                _local3 = _local2.exec(_arg1);
            };
            if (_arg1.search(new RegExp("'|\"")) >= 0)
            {
                throw (new Error("Bad syntax extra quotation marks"));
            };
            var _local4:Array = _arg1.split(/\s*;\s*/);
            for each (_local5 in _local4)
            {
                if (_local5.length)
                {
                    _local11 = this._saved[RETURNED];
                    if (((_local11) && ((_local5 == "/"))))
                    {
                        this._scope = _local11;
                        dispatchEvent(new Event(Event.COMPLETE));
                    }
                    else
                    {
                        this.execNest(_local5);
                    };
                };
            };
        }

        private function execNest(_arg1:String)
        {
            var _local3:int;
            var _local4:int;
            var _local5:int;
            var _local6:String;
            var _local7:Boolean;
            var _local8:int;
            var _local9:String;
            var _local10:Array;
            var _local11:String;
            var _local12:ExeValue;
            var _local13:String;
            _arg1 = this.ignoreWhite(_arg1);
            var _local2:int = _arg1.lastIndexOf("(");
            while (_local2 >= 0)
            {
                _local3 = _arg1.indexOf(")", _local2);
                if (_arg1.substring((_local2 + 1), _local3).search(/\w/) >= 0)
                {
                    _local4 = _local2;
                    _local5 = (_local2 + 1);
                    while ((((_local4 >= 0)) && ((_local4 < _local5))))
                    {
                        _local4 = _arg1.indexOf("(", ++_local4);
                        _local5 = _arg1.indexOf(")", (_local5 + 1));
                    };
                    _local6 = _arg1.substring((_local2 + 1), _local5);
                    _local7 = false;
                    _local8 = (_local2 - 1);
                    while (true)
                    {
                        _local9 = _arg1.charAt(_local8);
                        if (((_local9.match(/[^\s]/)) || ((_local8 <= 0))))
                        {
                            if (_local9.match(/\w/))
                            {
                                _local7 = true;
                            };
                            break;
                        };
                        _local8--;
                    };
                    if (_local7)
                    {
                        _local10 = _local6.split(",");
                        _arg1 = this.tempValue(_arg1, new ExeValue(_local10), (_local2 + 1), _local5);
                        for (_local11 in _local10)
                        {
                            _local10[_local11] = this.execOperations(this.ignoreWhite(_local10[_local11])).value;
                        };
                    }
                    else
                    {
                        _local12 = new ExeValue(_local12);
                        _arg1 = this.tempValue(_arg1, _local12, _local2, (_local5 + 1));
                        _local12.setValue(this.execOperations(this.ignoreWhite(_local6)).value);
                    };
                };
                _local2 = _arg1.lastIndexOf("(", (_local2 - 1));
            };
            this._returned = this.execOperations(_arg1).value;
            if (((this._returned) && (this.autoScope)))
            {
                _local13 = typeof(this._returned);
                if ((((_local13 == "object")) || ((_local13 == "xml"))))
                {
                    this._scope = this._returned;
                };
            };
            dispatchEvent(new Event(Event.COMPLETE));
            return (this._returned);
        }

        private function tempValue(_arg1:String, _arg2:*, _arg3:int, _arg4:int):String
        {
            _arg1 = (((_arg1.substring(0, _arg3) + VALKEY) + this._values.length) + _arg1.substring(_arg4));
            this._values.push(_arg2);
            return (_arg1);
        }

        private function execOperations(_arg1:String):ExeValue
        {
            var _local7:String;
            var _local8:*;
            var _local11:int;
            var _local12:int;
            var _local13:String;
            var _local14:ExeValue;
            var _local15:ExeValue;
            var _local2:RegExp = /\s*(((\|\||\&\&|[+|\-|*|\/|\%|\||\&|\^]|\=\=?|\!\=|\>\>?\>?|\<\<?)\=?)|=|\~|\sis\s|typeof|delete\s)\s*/g;
            var _local3:Object = _local2.exec(_arg1);
            var _local4:Array = [];
            if (_local3 == null)
            {
                _local4.push(_arg1);
            }
            else
            {
                _local11 = 0;
                while (_local3 != null)
                {
                    _local12 = _local3.index;
                    _local13 = _local3[0];
                    _local3 = _local2.exec(_arg1);
                    if (_local3 == null)
                    {
                        _local4.push(_arg1.substring(_local11, _local12));
                        _local4.push(this.ignoreWhite(_local13));
                        _local4.push(_arg1.substring((_local12 + _local13.length)));
                    }
                    else
                    {
                        _local4.push(_arg1.substring(_local11, _local12));
                        _local4.push(this.ignoreWhite(_local13));
                        _local11 = (_local12 + _local13.length);
                    };
                };
            };
            var _local5:int = _local4.length;
            var _local6:int;
            while (_local6 < _local5)
            {
                _local4[_local6] = this.execSimple(_local4[_local6]);
                _local6 = (_local6 + 2);
            };
            var _local9:RegExp = /((\|\||\&\&|[+|\-|*|\/|\%|\||\&|\^]|\>\>\>?|\<\<)\=)|=/;
            _local6 = 1;
            while (_local6 < _local5)
            {
                _local7 = _local4[_local6];
                if (_local7.replace(_local9, "") != "")
                {
                    _local8 = this.operate(_local4[(_local6 - 1)], _local7, _local4[(_local6 + 1)]);
                    _local14 = ExeValue(_local4[(_local6 - 1)]);
                    _local14.setValue(_local8);
                    _local4.splice(_local6, 2);
                    _local6 = (_local6 - 2);
                    _local5 = (_local5 - 2);
                };
                _local6 = (_local6 + 2);
            };
            _local4.reverse();
            var _local10:ExeValue = _local4[0];
            _local6 = 1;
            while (_local6 < _local5)
            {
                _local7 = _local4[_local6];
                if (_local7.replace(_local9, "") == "")
                {
                    _local10 = _local4[(_local6 - 1)];
                    _local15 = _local4[(_local6 + 1)];
                    if (_local7.length > 1)
                    {
                        _local7 = _local7.substring(0, (_local7.length - 1));
                    };
                    _local8 = this.operate(_local15, _local7, _local10);
                    _local15.setValue(_local8);
                };
                _local6 = (_local6 + 2);
            };
            return (_local10);
        }

        private function execSimple(str:String):ExeValue
        {
            var firstparts:Array;
            var newstr:String;
            var defclose:int;
            var newobj:* = undefined;
            var classstr:String;
            var def:* = undefined;
            var havemore:Boolean;
            var index:int;
            var isFun:Boolean;
            var basestr:String;
            var newv:ExeValue;
            var newbase:* = undefined;
            var closeindex:int;
            var paramstr:String;
            var params:Array;
            var nss:Array;
            var ns:Namespace;
            var nsv:* = undefined;
            var v:ExeValue = new ExeValue(this._scope);
            if (str.indexOf("new ") == 0)
            {
                newstr = str;
                defclose = str.indexOf(")");
                if (defclose >= 0)
                {
                    newstr = str.substring(0, (defclose + 1));
                };
                newobj = this.makeNew(newstr.substring(4));
                str = this.tempValue(str, new ExeValue(newobj), 0, newstr.length);
            };
            var reg:RegExp = /\.|\(/g;
            var result:Object = reg.exec(str);
            if ((((result == null)) || (!(isNaN(Number(str))))))
            {
                return (this.execValue(str, this._scope));
            };
            firstparts = String(str.split("(")[0]).split(".");
            if (firstparts.length > 0)
            {
                while (firstparts.length)
                {
                    classstr = firstparts.join(".");
                    try
                    {
                        def = getDefinitionByName(this.ignoreWhite(classstr));
                        havemore = (str.length > classstr.length);
                        str = this.tempValue(str, new ExeValue(def), 0, classstr.length);
                        if (havemore)
                        {
                            reg.lastIndex = 0;
                            result = reg.exec(str);
                        }
                        else
                        {
                            return (this.execValue(str));
                        };
                        break;
                    }
                    catch(e:Error)
                    {
                        firstparts.pop();
                    };
                };
            };
            var previndex:int;
            while (result != null)
            {
                index = result.index;
                isFun = (str.charAt(index) == "(");
                basestr = this.ignoreWhite(str.substring(previndex, index));
                newv = (((previndex == 0)) ? this.execValue(basestr, v.value) : new ExeValue(v.value, basestr));
                if (isFun)
                {
                    newbase = newv.value;
                    closeindex = str.indexOf(")", index);
                    paramstr = str.substring((index + 1), closeindex);
                    paramstr = this.ignoreWhite(paramstr);
                    params = [];
                    if (paramstr)
                    {
                        params = this.execValue(paramstr).value;
                    };
                    if (!(newbase is Function))
                    {
                        try
                        {
                            nss = [AS3];
                            for each (ns in nss)
                            {
                                nsv = v.obj.ns::[basestr];
                                if ((nsv is Function))
                                {
                                    newbase = nsv;
                                    break;
                                };
                            };
                        }
                        catch(e:Error)
                        {
                        };
                        if (!(newbase is Function))
                        {
                            throw (new Error((basestr + " is not a function.")));
                        };
                    };
                    v.obj = (newbase as Function).apply(v.value, params);
                    v.prop = null;
                    index = (closeindex + 1);
                }
                else
                {
                    v = newv;
                };
                previndex = (index + 1);
                reg.lastIndex = (index + 1);
                result = reg.exec(str);
                if (result == null)
                {
                    if ((index + 1) < str.length)
                    {
                        reg.lastIndex = str.length;
                        result = {"index":str.length};
                    };
                };
            };
            return (v);
        }

        private function execValue(str:String, base:*=null):ExeValue
        {
            var v:ExeValue;
            var vv:ExeValue;
            var key:String;
            v = new ExeValue();
            if (str == "true")
            {
                v.obj = true;
            }
            else
            {
                if (str == "false")
                {
                    v.obj = false;
                }
                else
                {
                    if (str == "this")
                    {
                        v.obj = this._scope;
                    }
                    else
                    {
                        if (str == "null")
                        {
                            v.obj = null;
                        }
                        else
                        {
                            if (!isNaN(Number(str)))
                            {
                                v.obj = Number(str);
                            }
                            else
                            {
                                if (str.indexOf(VALKEY) == 0)
                                {
                                    vv = this._values[str.substring(VALKEY.length)];
                                    v.obj = vv.value;
                                }
                                else
                                {
                                    if (str.charAt(0) == "$")
                                    {
                                        key = str.substring(1);
                                        if (this._reserved.indexOf(key) < 0)
                                        {
                                            v.obj = this._saved;
                                            v.prop = key;
                                        }
                                        else
                                        {
                                            if ((this._saved is WeakObject))
                                            {
                                                v.obj = WeakObject(this._saved).get(key);
                                            }
                                            else
                                            {
                                                v.obj = this._saved[key];
                                            };
                                        };
                                    }
                                    else
                                    {
                                        try
                                        {
                                            v.obj = getDefinitionByName(str);
                                        }
                                        catch(e:Error)
                                        {
                                            v.obj = base;
                                            v.prop = str;
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            return (v);
        }

        private function operate(_arg1:ExeValue, _arg2:String, _arg3:ExeValue)
        {
            switch (_arg2)
            {
                case "=":
                    return (_arg3.value);
                case "+":
                    return ((_arg1.value + _arg3.value));
                case "-":
                    return ((_arg1.value - _arg3.value));
                case "*":
                    return ((_arg1.value * _arg3.value));
                case "/":
                    return ((_arg1.value / _arg3.value));
                case "%":
                    return ((_arg1.value % _arg3.value));
                case "^":
                    return ((_arg1.value ^ _arg3.value));
                case "&":
                    return ((_arg1.value & _arg3.value));
                case ">>":
                    return ((_arg1.value >> _arg3.value));
                case ">>>":
                    return ((_arg1.value >>> _arg3.value));
                case "<<":
                    return ((_arg1.value << _arg3.value));
                case "~":
                    return (~(_arg3.value));
                case "|":
                    return ((_arg1.value | _arg3.value));
                case "!":
                    return (!(_arg3.value));
                case ">":
                    return ((_arg1.value > _arg3.value));
                case ">=":
                    return ((_arg1.value >= _arg3.value));
                case "<":
                    return ((_arg1.value < _arg3.value));
                case "<=":
                    return ((_arg1.value <= _arg3.value));
                case "||":
                    return (((_arg1.value) || (_arg3.value)));
                case "&&":
                    return (((_arg1.value) && (_arg3.value)));
                case "is":
                    return ((_arg1.value is _arg3.value));
                case "typeof":
                    return (typeof(_arg3.value));
                case "delete":
                    return (delete _arg3.obj[_arg3.prop]);
                case "==":
                    return ((_arg1.value == _arg3.value));
                case "===":
                    return ((_arg1.value === _arg3.value));
                case "!=":
                    return (!((_arg1.value == _arg3.value)));
                case "!==":
                    return (!((_arg1.value === _arg3.value)));
            };
        }

        private function makeNew(_arg1:String)
        {
            var _local5:int;
            var _local6:String;
            var _local7:Array;
            var _local8:int;
            var _local2:int = _arg1.indexOf("(");
            var _local3:String = (((_local2 > 0)) ? _arg1.substring(0, _local2) : _arg1);
            _local3 = this.ignoreWhite(_local3);
            var _local4:* = this.execValue(_local3).value;
            if (_local2 > 0)
            {
                _local5 = _arg1.indexOf(")", _local2);
                _local6 = _arg1.substring((_local2 + 1), _local5);
                _local6 = this.ignoreWhite(_local6);
                _local7 = [];
                if (_local6)
                {
                    _local7 = this.execValue(_local6).value;
                };
                _local8 = _local7.length;
                if (_local8 == 0)
                {
                    return (new (_local4)());
                };
                if (_local8 == 1)
                {
                    return (new (_local4)(_local7[0]));
                };
                if (_local8 == 2)
                {
                    return (new (_local4)(_local7[0], _local7[1]));
                };
                if (_local8 == 3)
                {
                    return (new (_local4)(_local7[0], _local7[1], _local7[2]));
                };
                if (_local8 == 4)
                {
                    return (new (_local4)(_local7[0], _local7[1], _local7[2], _local7[3]));
                };
                if (_local8 == 5)
                {
                    return (new (_local4)(_local7[0], _local7[1], _local7[2], _local7[3], _local7[4]));
                };
                if (_local8 == 6)
                {
                    return (new (_local4)(_local7[0], _local7[1], _local7[2], _local7[3], _local7[4], _local7[5]));
                };
                if (_local8 == 7)
                {
                    return (new (_local4)(_local7[0], _local7[1], _local7[2], _local7[3], _local7[4], _local7[5], _local7[6]));
                };
                if (_local8 == 8)
                {
                    return (new (_local4)(_local7[0], _local7[1], _local7[2], _local7[3], _local7[4], _local7[5], _local7[6], _local7[7]));
                };
                if (_local8 == 9)
                {
                    return (new (_local4)(_local7[0], _local7[1], _local7[2], _local7[3], _local7[4], _local7[5], _local7[6], _local7[7], _local7[8]));
                };
                if (_local8 == 10)
                {
                    return (new (_local4)(_local7[0], _local7[1], _local7[2], _local7[3], _local7[4], _local7[5], _local7[6], _local7[7], _local7[8], _local7[9]));
                };
                throw (new Error("CommandLine can't create new class instances with more than 10 arguments."));
            };
            return (null);
        }

        private function ignoreWhite(_arg1:String):String
        {
            _arg1 = _arg1.replace(/\s*(.*)/, "$1");
            var _local2:int = (_arg1.length - 1);
            while (_local2 > 0)
            {
                if (_arg1.charAt(_local2).match(/\s/))
                {
                    _arg1 = _arg1.substring(0, _local2);
                }
                else
                {
                    break;
                };
                _local2--;
            };
            return (_arg1);
        }


    }
}

class ExeValue 
{

    public var obj;
    public var prop:String;

    public function ExeValue(_arg1:Object=null, _arg2:String=null):void
    {
        this.obj = _arg1;
        this.prop = _arg2;
    }

    public function get value()
    {
        return (((this.prop) ? this.obj[this.prop] : this.obj));
    }

    public function setValue(_arg1:*):void
    {
        if (this.prop)
        {
            this.obj[this.prop] = _arg1;
        }
        else
        {
            this.obj = _arg1;
        };
    }


}

