package com.junkbyte.console.core
{
    import com.junkbyte.console.vos.WeakObject;
    import flash.utils.Dictionary;
    import flash.utils.ByteArray;
    import com.junkbyte.console.Console;
    import flash.utils.getQualifiedClassName;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.utils.describeType;
    import flash.utils.getDefinitionByName;

    public class LogReferences extends ConsoleCore 
    {

        public static const INSPECTING_CHANNEL:String = "⌂";

        private var _refMap:WeakObject;
        private var _refRev:Dictionary;
        private var _refIndex:uint = 1;
        private var _dofull:Boolean;
        private var _current;
        private var _history:Array;
        private var _hisIndex:uint;
        private var _prevBank:Array;
        private var _currentBank:Array;
        private var _lastWithdraw:uint;

        public function LogReferences(console:Console)
        {
            this._refMap = new WeakObject();
            this._refRev = new Dictionary(true);
            this._prevBank = new Array();
            this._currentBank = new Array();
            super(console);
            remoter.registerCallback("ref", function (_arg1:ByteArray):void
            {
                handleString(_arg1.readUTF());
            });
            remoter.registerCallback("focus", this.handleFocused);
        }

        public static function EscHTML(_arg1:String):String
        {
            return (_arg1.replace(/</g, "&lt;").replace(/\>/g, "&gt;").replace(/\x00/g, ""));
        }

        public static function ShortClassName(_arg1:Object, _arg2:Boolean=true):String
        {
            var _local3:String = getQualifiedClassName(_arg1);
            var _local4:int = _local3.indexOf("::");
            var _local5:String = (((_arg1 is Class)) ? "*" : "");
            _local3 = ((_local5 + _local3.substring((((_local4 >= 0)) ? (_local4 + 2) : 0))) + _local5);
            if (_arg2)
            {
                return (EscHTML(_local3));
            };
            return (_local3);
        }


        public function update(_arg1:uint):void
        {
            if (((this._currentBank.length) || (this._prevBank.length)))
            {
                if (_arg1 > (this._lastWithdraw + (config.objectHardReferenceTimer * 1000)))
                {
                    this._prevBank = this._currentBank;
                    this._currentBank = new Array();
                    this._lastWithdraw = _arg1;
                };
            };
        }

        public function setLogRef(_arg1:*):uint
        {
            var _local3:int;
            if (!config.useObjectLinking)
            {
                return (0);
            };
            var _local2:uint = this._refRev[_arg1];
            if (!_local2)
            {
                _local2 = this._refIndex;
                this._refMap[_local2] = _arg1;
                this._refRev[_arg1] = _local2;
                if (config.objectHardReferenceTimer)
                {
                    this._currentBank.push(_arg1);
                };
                this._refIndex++;
                _local3 = (_local2 - 50);
                while (_local3 >= 0)
                {
                    if (this._refMap[_local3] === null)
                    {
                        delete this._refMap[_local3];
                    };
                    _local3 = (_local3 - 50);
                };
            };
            return (_local2);
        }

        public function getRefId(_arg1:*):uint
        {
            return (this._refRev[_arg1]);
        }

        public function getRefById(_arg1:uint)
        {
            return (this._refMap[_arg1]);
        }

        public function makeString(o:*, prop:*=null, html:Boolean=false, maxlen:int=-1):String
        {
            var txt:String;
            var v:* = undefined;
            var err:Error;
            var stackstr:String;
            var str:String;
            var len:int;
            var hasmaxlen:Boolean;
            var i:int;
            var strpart:String;
            var add:String;
            try
            {
                v = ((prop) ? o[prop] : o);
            }
            catch(err:Error)
            {
                return ((("<p0><i>" + err.toString()) + "</i></p0>"));
            };
            if ((v is Error))
            {
                err = (v as Error);
                stackstr = ((err.hasOwnProperty("getStackTrace")) ? err.getStackTrace() : err.toString());
                if (stackstr)
                {
                    return (stackstr);
                };
                return (err.toString());
            };
            if ((((v is XML)) || ((v is XMLList))))
            {
                return (this.shortenString(EscHTML(v.toXMLString()), maxlen, o, prop));
            };
            if ((v is QName))
            {
                return (String(v));
            };
            if ((((v is Array)) || ((getQualifiedClassName(v).indexOf("__AS3__.vec::Vector.") == 0))))
            {
                str = "[";
                len = v.length;
                hasmaxlen = (maxlen >= 0);
                i = 0;
                while (i < len)
                {
                    strpart = this.makeString(v[i], null, false, maxlen);
                    str = (str + (((i) ? ", " : "") + strpart));
                    maxlen = (maxlen - strpart.length);
                    if (((((hasmaxlen) && ((maxlen <= 0)))) && ((i < (len - 1)))))
                    {
                        str = (str + (", " + this.genLinkString(o, prop, "...")));
                        break;
                    };
                    i = (i + 1);
                };
                return ((str + "]"));
            };
            if (((((config.useObjectLinking) && (v))) && ((typeof(v) == "object"))))
            {
                add = "";
                if ((v is ByteArray))
                {
                    add = (((" position:" + v.position) + " length:") + v.length);
                }
                else
                {
                    if ((((((((((v is Date)) || ((v is Rectangle)))) || ((v is Point)))) || ((v is Matrix)))) || ((v is Event))))
                    {
                        add = (" " + String(v));
                    }
                    else
                    {
                        if ((((v is DisplayObject)) && (v.name)))
                        {
                            add = (" " + v.name);
                        };
                    };
                };
                txt = ((("{" + this.genLinkString(o, prop, ShortClassName(v))) + EscHTML(add)) + "}");
            }
            else
            {
                if ((v is ByteArray))
                {
                    txt = (((("[ByteArray position:" + ByteArray(v).position) + " length:") + ByteArray(v).length) + "]");
                }
                else
                {
                    txt = String(v);
                };
                if (!html)
                {
                    return (this.shortenString(EscHTML(txt), maxlen, o, prop));
                };
            };
            return (txt);
        }

        public function makeRefTyped(_arg1:*):String
        {
            if (((((_arg1) && ((typeof(_arg1) == "object")))) && (!((_arg1 is QName)))))
            {
                return ((("{" + this.genLinkString(_arg1, null, ShortClassName(_arg1))) + "}"));
            };
            return (ShortClassName(_arg1));
        }

        private function genLinkString(_arg1:*, _arg2:*, _arg3:String):String
        {
            if (((_arg2) && (!((_arg2 is String)))))
            {
                _arg1 = _arg1[_arg2];
                _arg2 = null;
            };
            var _local4:uint = this.setLogRef(_arg1);
            if (_local4)
            {
                return (((((("<menu><a href='event:ref_" + _local4) + ((_arg2) ? ("_" + _arg2) : "")) + "'>") + _arg3) + "</a></menu>"));
            };
            return (_arg3);
        }

        private function shortenString(_arg1:String, _arg2:int, _arg3:*, _arg4:*=null):String
        {
            if ((((_arg2 >= 0)) && ((_arg1.length > _arg2))))
            {
                _arg1 = _arg1.substring(0, _arg2);
                return ((_arg1 + this.genLinkString(_arg3, _arg4, " ...")));
            };
            return (_arg1);
        }

        private function historyInc(_arg1:int):void
        {
            this._hisIndex = (this._hisIndex + _arg1);
            var _local2:* = this._history[this._hisIndex];
            if (_local2)
            {
                this.focus(_local2, this._dofull);
            };
        }

        public function handleRefEvent(_arg1:String):void
        {
            var _local2:ByteArray;
            if (remoter.remoting == Remoting.RECIEVER)
            {
                _local2 = new ByteArray();
                _local2.writeUTF(_arg1);
                remoter.send("ref", _local2);
            }
            else
            {
                this.handleString(_arg1);
            };
        }

        private function handleString(_arg1:String):void
        {
            var _local2:int;
            var _local3:uint;
            var _local4:String;
            var _local5:int;
            var _local6:Object;
            if (_arg1 == "refexit")
            {
                this.exitFocus();
                console.setViewingChannels();
            }
            else
            {
                if (_arg1 == "refprev")
                {
                    this.historyInc(-2);
                }
                else
                {
                    if (_arg1 == "reffwd")
                    {
                        this.historyInc(0);
                    }
                    else
                    {
                        if (_arg1 == "refi")
                        {
                            this.focus(this._current, !(this._dofull));
                        }
                        else
                        {
                            _local2 = (_arg1.indexOf("_") + 1);
                            if (_local2 > 0)
                            {
                                _local4 = "";
                                _local5 = _arg1.indexOf("_", _local2);
                                if (_local5 > 0)
                                {
                                    _local3 = uint(_arg1.substring(_local2, _local5));
                                    _local4 = _arg1.substring((_local5 + 1));
                                }
                                else
                                {
                                    _local3 = uint(_arg1.substring(_local2));
                                };
                                _local6 = this.getRefById(_local3);
                                if (_local4)
                                {
                                    _local6 = _local6[_local4];
                                };
                                if (_local6)
                                {
                                    if (_arg1.indexOf("refe_") == 0)
                                    {
                                        console.explodech(console.panels.mainPanel.reportChannel, _local6);
                                    }
                                    else
                                    {
                                        this.focus(_local6, this._dofull);
                                    };
                                    return;
                                };
                            };
                            report("Reference no longer exist (garbage collected).", -2);
                        };
                    };
                };
            };
        }

        public function focus(_arg1:*, _arg2:Boolean=false):void
        {
            remoter.send("focus");
            console.clear(LogReferences.INSPECTING_CHANNEL);
            console.setViewingChannels(LogReferences.INSPECTING_CHANNEL);
            if (!this._history)
            {
                this._history = new Array();
            };
            if (this._current != _arg1)
            {
                this._current = _arg1;
                if (this._history.length <= this._hisIndex)
                {
                    this._history.push(_arg1);
                }
                else
                {
                    this._history[this._hisIndex] = _arg1;
                };
                this._hisIndex++;
            };
            this._dofull = _arg2;
            this.inspect(_arg1, this._dofull);
        }

        private function handleFocused():void
        {
            console.clear(LogReferences.INSPECTING_CHANNEL);
            console.setViewingChannels(LogReferences.INSPECTING_CHANNEL);
        }

        public function exitFocus():void
        {
            var _local1:ByteArray;
            this._current = null;
            this._dofull = false;
            this._history = null;
            this._hisIndex = 0;
            if (remoter.remoting == Remoting.SENDER)
            {
                _local1 = new ByteArray();
                _local1.writeUTF("refexit");
                remoter.send("ref", _local1);
            };
            console.clear(LogReferences.INSPECTING_CHANNEL);
        }

        public function inspect(obj:*, viewAll:Boolean=true, ch:String=null):void
        {
            var menuStr:String;
            var nodes:XMLList;
            var constantX:XML;
            var hasstuff:Boolean;
            var isstatic:Boolean;
            var methodX:XML;
            var accessorX:XML;
            var variableX:XML;
            var extendX:XML;
            var implementX:XML;
            var metadataX:XML;
            var mn:XMLList;
            var en:String;
            var et:String;
            var disp:DisplayObject;
            var theParent:DisplayObjectContainer;
            var pr:DisplayObjectContainer;
            var indstr:String;
            var cont:DisplayObjectContainer;
            var clen:int;
            var ci:int;
            var child:DisplayObject;
            var params:Array;
            var mparamsList:XMLList;
            var paraX:XML;
            var access:String;
            var X:* = undefined;
            if (!obj)
            {
                report(obj, -2, true, ch);
                return;
            };
            var refIndex:uint = this.setLogRef(obj);
            var showInherit:String = "";
            if (!viewAll)
            {
                showInherit = " [<a href='event:refi'>show inherited</a>]";
            };
            if (this._history)
            {
                menuStr = "<b>[<a href='event:refexit'>exit</a>]";
                if (this._hisIndex > 1)
                {
                    menuStr = (menuStr + " [<a href='event:refprev'>previous</a>]");
                };
                if (((this._history) && ((this._hisIndex < this._history.length))))
                {
                    menuStr = (menuStr + " [<a href='event:reffwd'>forward</a>]");
                };
                menuStr = (menuStr + (("</b> || [<a href='event:ref_" + refIndex) + "'>refresh</a>]"));
                menuStr = (menuStr + (("</b> [<a href='event:refe_" + refIndex) + "'>explode</a>]"));
                if (config.commandLineAllowed)
                {
                    menuStr = (menuStr + ((" [<a href='event:cl_" + refIndex) + "'>scope</a>]"));
                };
                if (viewAll)
                {
                    menuStr = (menuStr + " [<a href='event:refi'>hide inherited</a>]");
                }
                else
                {
                    menuStr = (menuStr + showInherit);
                };
                report(menuStr, -1, true, ch);
                report("", 1, true, ch);
            };
            var V:XML = describeType(obj);
            var cls:Object = (((obj is Class)) ? obj : obj.constructor);
            var clsV:XML = describeType(cls);
            var self:String = V.@name;
            var isClass:Boolean = (obj is Class);
            var st:String = ((isClass) ? "*" : "");
            var str:String = (((("<b>{" + st) + this.genLinkString(obj, null, EscHTML(self))) + st) + "}</b>");
            var props:Array = [];
            if (V.@isStatic == "true")
            {
                props.push("<b>static</b>");
            };
            if (V.@isDynamic == "true")
            {
                props.push("dynamic");
            };
            if (V.@isFinal == "true")
            {
                props.push("final");
            };
            if (props.length > 0)
            {
                str = (str + ((" <p-1>" + props.join(" | ")) + "</p-1>"));
            };
            report(str, -2, true, ch);
            nodes = V.extendsClass;
            if (nodes.length())
            {
                props = [];
                for each (extendX in nodes)
                {
                    st = extendX.@type.toString();
                    props.push((((st.indexOf("*") < 0)) ? this.makeValue(getDefinitionByName(st)) : EscHTML(st)));
                    if (!viewAll) break;
                };
                report(("<p10>Extends:</p10> " + props.join(" &gt; ")), 1, true, ch);
            };
            nodes = V.implementsInterface;
            if (nodes.length())
            {
                props = [];
                for each (implementX in nodes)
                {
                    props.push(this.makeValue(getDefinitionByName(implementX.@type.toString())));
                };
                report(("<p10>Implements:</p10> " + props.join(", ")), 1, true, ch);
            };
            report("", 1, true, ch);
            props = [];
            nodes = V.metadata.(@name == "Event");
            if (nodes.length())
            {
                for each (metadataX in nodes)
                {
                    mn = metadataX.arg;
                    en = mn.(@key == "name").@value;
                    et = mn.(@key == "type").@value;
                    if (refIndex)
                    {
                        props.push((((((((((("<a href='event:cl_" + refIndex) + "_dispatchEvent(new ") + et) + '("') + en) + "\"))'>") + en) + "</a><p0>(") + et) + ")</p0>"));
                    }
                    else
                    {
                        props.push((((en + "<p0>(") + et) + ")</p0>"));
                    };
                };
                report(("<p10>Events:</p10> " + props.join("<p-1>; </p-1>")), 1, true, ch);
                report("", 1, true, ch);
            };
            if ((obj is DisplayObject))
            {
                disp = (obj as DisplayObject);
                theParent = disp.parent;
                if (theParent)
                {
                    props = new Array(("@" + theParent.getChildIndex(disp)));
                    while (theParent)
                    {
                        pr = theParent;
                        theParent = theParent.parent;
                        indstr = ((theParent) ? ("@" + theParent.getChildIndex(pr)) : "");
                        props.push((((("<b>" + pr.name) + "</b>") + indstr) + this.makeValue(pr)));
                    };
                    report((("<p10>Parents:</p10> " + props.join("<p-1> -> </p-1>")) + "<br/>"), 1, true, ch);
                };
            };
            if ((obj is DisplayObjectContainer))
            {
                props = [];
                cont = (obj as DisplayObjectContainer);
                clen = cont.numChildren;
                ci = 0;
                while (ci < clen)
                {
                    child = cont.getChildAt(ci);
                    props.push((((("<b>" + child.name) + "</b>@") + ci) + this.makeValue(child)));
                    ci = (ci + 1);
                };
                if (clen)
                {
                    report((("<p10>Children:</p10> " + props.join("<p-1>; </p-1>")) + "<br/>"), 1, true, ch);
                };
            };
            props = [];
            nodes = clsV..constant;
            for each (constantX in nodes)
            {
                report(((((((" const <p3>" + constantX.@name) + "</p3>:") + constantX.@type) + " = ") + this.makeValue(cls, constantX.@name.toString())) + "</p0>"), 1, true, ch);
            };
            if (nodes.length())
            {
                report("", 1, true, ch);
            };
            var inherit:uint;
            props = [];
            nodes = clsV..method;
            for each (methodX in nodes)
            {
                if (((viewAll) || ((self == methodX.@declaredBy))))
                {
                    hasstuff = true;
                    isstatic = !((methodX.parent().name() == "factory"));
                    str = ((" " + ((isstatic) ? "static " : "")) + "function ");
                    params = [];
                    mparamsList = methodX.parameter;
                    for each (paraX in mparamsList)
                    {
                        params.push((((paraX.@optional == "true")) ? (("<i>" + paraX.@type) + "</i>") : paraX.@type));
                    };
                    if (((refIndex) && (((isstatic) || (!(isClass))))))
                    {
                        str = (str + (((((("<a href='event:cl_" + refIndex) + "_") + methodX.@name) + "()'><p3>") + methodX.@name) + "</p3></a>"));
                    }
                    else
                    {
                        str = (str + (("<p3>" + methodX.@name) + "</p3>"));
                    };
                    str = (str + ((("(" + params.join(", ")) + "):") + methodX.@returnType));
                    report(str, 1, true, ch);
                }
                else
                {
                    inherit++;
                };
            };
            if (inherit)
            {
                report(((("   \t + " + inherit) + " inherited methods.") + showInherit), 1, true, ch);
            }
            else
            {
                if (hasstuff)
                {
                    report("", 1, true, ch);
                };
            };
            hasstuff = false;
            inherit = 0;
            props = [];
            nodes = clsV..accessor;
            for each (accessorX in nodes)
            {
                if (((viewAll) || ((self == accessorX.@declaredBy))))
                {
                    hasstuff = true;
                    isstatic = !((accessorX.parent().name() == "factory"));
                    str = " ";
                    if (isstatic)
                    {
                        str = (str + "static ");
                    };
                    access = accessorX.@access;
                    if (access == "readonly")
                    {
                        str = (str + "get");
                    }
                    else
                    {
                        if (access == "writeonly")
                        {
                            str = (str + "set");
                        }
                        else
                        {
                            str = (str + "assign");
                        };
                    };
                    if (((refIndex) && (((isstatic) || (!(isClass))))))
                    {
                        str = (str + (((((((" <a href='event:cl_" + refIndex) + "_") + accessorX.@name) + "'><p3>") + accessorX.@name) + "</p3></a>:") + accessorX.@type));
                    }
                    else
                    {
                        str = (str + (((" <p3>" + accessorX.@name) + "</p3>:") + accessorX.@type));
                    };
                    if (((!((access == "writeonly"))) && (((isstatic) || (!(isClass))))))
                    {
                        str = (str + (" = " + this.makeValue(((isstatic) ? cls : obj), accessorX.@name.toString())));
                    };
                    report(str, 1, true, ch);
                }
                else
                {
                    inherit++;
                };
            };
            if (inherit)
            {
                report(((("   \t + " + inherit) + " inherited accessors.") + showInherit), 1, true, ch);
            }
            else
            {
                if (hasstuff)
                {
                    report("", 1, true, ch);
                };
            };
            nodes = clsV..variable;
            for each (variableX in nodes)
            {
                isstatic = !((variableX.parent().name() == "factory"));
                str = ((isstatic) ? " static" : "");
                if (refIndex)
                {
                    str = (str + ((((((" var <p3><a href='event:cl_" + refIndex) + "_") + variableX.@name) + " = '>") + variableX.@name) + "</a>"));
                }
                else
                {
                    str = (str + (" var <p3>" + variableX.@name));
                };
                str = (str + ((("</p3>:" + variableX.@type) + " = ") + this.makeValue(((isstatic) ? cls : obj), variableX.@name.toString())));
                report(str, 1, true, ch);
            };
            try
            {
                props = [];
                for (X in obj)
                {
                    if ((X is String))
                    {
                        if (refIndex)
                        {
                            str = (((((("<a href='event:cl_" + refIndex) + "_") + X) + " = '>") + X) + "</a>");
                        }
                        else
                        {
                            str = X;
                        };
                        report((((" dynamic var <p3>" + str) + "</p3> = ") + this.makeValue(obj, X)), 1, true, ch);
                    }
                    else
                    {
                        report((((" dictionary <p3>" + this.makeValue(X)) + "</p3> = ") + this.makeValue(obj, X)), 1, true, ch);
                    };
                };
            }
            catch(e:Error)
            {
                report(("Could not get dynamic values. " + e.message), 9, false, ch);
            };
            if ((obj is String))
            {
                report("", 1, true, ch);
                report("String", 10, true, ch);
                report(EscHTML(obj), 1, true, ch);
            }
            else
            {
                if ((((obj is XML)) || ((obj is XMLList))))
                {
                    report("", 1, true, ch);
                    report("XMLString", 10, true, ch);
                    report(EscHTML(obj.toXMLString()), 1, true, ch);
                };
            };
            if (menuStr)
            {
                report("", 1, true, ch);
                report(menuStr, -1, true, ch);
            };
        }

        public function getPossibleCalls(_arg1:*):Array
        {
            var _local5:XML;
            var _local6:XML;
            var _local7:XML;
            var _local8:Array;
            var _local9:XMLList;
            var _local10:XML;
            var _local2:Array = new Array();
            var _local3:XML = describeType(_arg1);
            var _local4:XMLList = _local3.method;
            for each (_local5 in _local4)
            {
                _local8 = [];
                _local9 = _local5.parameter;
                for each (_local10 in _local9)
                {
                    _local8.push((((_local10.@optional == "true")) ? (("<i>" + _local10.@type) + "</i>") : _local10.@type));
                };
                _local2.push([(_local5.@name + "("), ((_local8.join(", ") + " ):") + _local5.@returnType)]);
            };
            _local4 = _local3.accessor;
            for each (_local6 in _local4)
            {
                _local2.push([String(_local6.@name), String(_local6.@type)]);
            };
            _local4 = _local3.variable;
            for each (_local7 in _local4)
            {
                _local2.push([String(_local7.@name), String(_local7.@type)]);
            };
            return (_local2);
        }

        private function makeValue(_arg1:*, _arg2:*=null):String
        {
            return (this.makeString(_arg1, _arg2, false, ((config.useObjectLinking) ? 100 : -1)));
        }


    }
}

