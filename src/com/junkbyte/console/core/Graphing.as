package com.junkbyte.console.core
{
    import com.junkbyte.console.vos.GraphGroup;
    import flash.utils.ByteArray;
    import com.junkbyte.console.Console;
    import com.junkbyte.console.vos.GraphInterest;
    import flash.geom.Rectangle;
    import flash.utils.getTimer;
    import flash.system.System;

    public class Graphing extends ConsoleCore 
    {

        private var _groups:Array;
        private var _map:Object;
        private var _fpsGroup:GraphGroup;
        private var _memGroup:GraphGroup;
        private var _hadGraph:Boolean;
        private var _previousTime:Number = -1;

        public function Graphing(m:Console)
        {
            this._groups = [];
            this._map = {};
            super(m);
            remoter.registerCallback("fps", function (_arg1:ByteArray):void
            {
                fpsMonitor = _arg1.readBoolean();
            });
            remoter.registerCallback("mem", function (_arg1:ByteArray):void
            {
                memoryMonitor = _arg1.readBoolean();
            });
            remoter.registerCallback("removeGroup", function (_arg1:ByteArray):void
            {
                removeGroup(_arg1.readUTF());
            });
            remoter.registerCallback("graph", this.handleRemoteGraph, true);
        }

        public function add(n:String, obj:Object, prop:String, col:Number=-1, key:String=null, rect:Rectangle=null, inverse:Boolean=false):void
        {
            var newGroup:Boolean;
            var i:GraphInterest;
            if (obj == null)
            {
                report((((("ERROR: Graph [" + n) + "] received a null object to graph property [") + prop) + "]."), 10);
                return;
            };
            var group:GraphGroup = this._map[n];
            if (!group)
            {
                newGroup = true;
                group = new GraphGroup(n);
            };
            var interests:Array = group.interests;
            if (((isNaN(col)) || ((col < 0))))
            {
                if (interests.length <= 5)
                {
                    col = config.style[("priority" + (10 - (interests.length * 2)))];
                }
                else
                {
                    col = (Math.random() * 0xFFFFFF);
                };
            };
            if (key == null)
            {
                key = prop;
            };
            for each (i in interests)
            {
                if (i.key == key)
                {
                    report((((("Graph with key [" + key) + "] already exists in [") + n) + "]"), 10);
                    return;
                };
            };
            if (rect)
            {
                group.rect = rect;
            };
            if (inverse)
            {
                group.inv = inverse;
            };
            var interest:GraphInterest = new GraphInterest(key, col);
            var v:Number = NaN;
            try
            {
                v = interest.setObject(obj, prop);
            }
            catch(e:Error)
            {
                report(((((("Error with graph value for [" + key) + "] in [") + n) + "]. ") + e), 10);
                return;
            };
            if (isNaN(v))
            {
                report((((("Graph value for key [" + key) + "] in [") + n) + "] is not a number (NaN)."), 10);
            }
            else
            {
                group.interests.push(interest);
                if (newGroup)
                {
                    this._map[n] = group;
                    this._groups.push(group);
                };
            };
        }

        public function fixRange(_arg1:String, _arg2:Number=NaN, _arg3:Number=NaN):void
        {
            var _local4:GraphGroup = this._map[_arg1];
            if (!_local4)
            {
                return;
            };
            _local4.low = _arg2;
            _local4.hi = _arg3;
            _local4.fixed = !(((isNaN(_arg2)) || (isNaN(_arg3))));
        }

        public function remove(_arg1:String, _arg2:Object=null, _arg3:String=null):void
        {
            var _local4:Array;
            var _local5:int;
            var _local6:GraphInterest;
            if ((((_arg2 == null)) && ((_arg3 == null))))
            {
                this.removeGroup(_arg1);
            }
            else
            {
                if (this._map[_arg1])
                {
                    _local4 = this._map[_arg1].interests;
                    _local5 = (_local4.length - 1);
                    while (_local5 >= 0)
                    {
                        _local6 = _local4[_local5];
                        if ((((((_arg2 == null)) || ((_local6.obj == _arg2)))) && ((((_arg3 == null)) || ((_local6.prop == _arg3))))))
                        {
                            _local4.splice(_local5, 1);
                        };
                        _local5--;
                    };
                    if (_local4.length == 0)
                    {
                        this.removeGroup(_arg1);
                    };
                };
            };
        }

        private function removeGroup(_arg1:String):void
        {
            var _local2:ByteArray;
            var _local3:GraphGroup;
            var _local4:int;
            if (remoter.remoting == Remoting.RECIEVER)
            {
                _local2 = new ByteArray();
                _local2.writeUTF(_arg1);
                remoter.send("removeGroup", _local2);
            }
            else
            {
                _local3 = this._map[_arg1];
                _local4 = this._groups.indexOf(_local3);
                if (_local4 >= 0)
                {
                    this._groups.splice(_local4, 1);
                };
                delete this._map[_arg1];
            };
        }

        public function get fpsMonitor():Boolean
        {
            if (remoter.remoting == Remoting.RECIEVER)
            {
                return (console.panels.fpsMonitor);
            };
            return (!((this._fpsGroup == null)));
        }

        public function set fpsMonitor(_arg1:Boolean):void
        {
            var _local2:ByteArray;
            var _local3:int;
            if (remoter.remoting == Remoting.RECIEVER)
            {
                _local2 = new ByteArray();
                _local2.writeBoolean(_arg1);
                remoter.send("fps", _local2);
            }
            else
            {
                if (_arg1 != this.fpsMonitor)
                {
                    if (_arg1)
                    {
                        this._fpsGroup = this.addSpecialGroup(GraphGroup.FPS);
                        this._fpsGroup.low = 0;
                        this._fpsGroup.fixed = true;
                        this._fpsGroup.averaging = 30;
                    }
                    else
                    {
                        this._previousTime = -1;
                        _local3 = this._groups.indexOf(this._fpsGroup);
                        if (_local3 >= 0)
                        {
                            this._groups.splice(_local3, 1);
                        };
                        this._fpsGroup = null;
                    };
                    console.panels.mainPanel.updateMenu();
                };
            };
        }

        public function get memoryMonitor():Boolean
        {
            if (remoter.remoting == Remoting.RECIEVER)
            {
                return (console.panels.memoryMonitor);
            };
            return (!((this._memGroup == null)));
        }

        public function set memoryMonitor(_arg1:Boolean):void
        {
            var _local2:ByteArray;
            var _local3:int;
            if (remoter.remoting == Remoting.RECIEVER)
            {
                _local2 = new ByteArray();
                _local2.writeBoolean(_arg1);
                remoter.send("mem", _local2);
            }
            else
            {
                if (_arg1 != this.memoryMonitor)
                {
                    if (_arg1)
                    {
                        this._memGroup = this.addSpecialGroup(GraphGroup.MEM);
                        this._memGroup.freq = 20;
                    }
                    else
                    {
                        _local3 = this._groups.indexOf(this._memGroup);
                        if (_local3 >= 0)
                        {
                            this._groups.splice(_local3, 1);
                        };
                        this._memGroup = null;
                    };
                    console.panels.mainPanel.updateMenu();
                };
            };
        }

        private function addSpecialGroup(_arg1:int):GraphGroup
        {
            var _local2:GraphGroup = new GraphGroup("special");
            _local2.type = _arg1;
            this._groups.push(_local2);
            var _local3:GraphInterest = new GraphInterest("special");
            if (_arg1 == GraphGroup.FPS)
            {
                _local3.col = 16724787;
            }
            else
            {
                _local3.col = 5267711;
            };
            _local2.interests.push(_local3);
            return (_local2);
        }

        public function update(_arg1:Number=0):Array
        {
            var _local2:GraphInterest;
            var _local3:Number;
            var _local4:GraphGroup;
            var _local5:Boolean;
            var _local6:uint;
            var _local7:uint;
            var _local8:Array;
            var _local9:int;
            var _local10:Number;
            var _local11:uint;
            var _local12:ByteArray;
            var _local13:uint;
            for each (_local4 in this._groups)
            {
                _local5 = true;
                if (_local4.freq > 1)
                {
                    _local4.idle++;
                    if (_local4.idle < _local4.freq)
                    {
                        _local5 = false;
                    }
                    else
                    {
                        _local4.idle = 0;
                    };
                };
                if (_local5)
                {
                    _local6 = _local4.type;
                    _local7 = _local4.averaging;
                    _local8 = _local4.interests;
                    if (_local6 == GraphGroup.FPS)
                    {
                        _local4.hi = _arg1;
                        _local2 = _local8[0];
                        _local9 = getTimer();
                        if (this._previousTime >= 0)
                        {
                            _local10 = (_local9 - this._previousTime);
                            _local3 = (1000 / _local10);
                            _local2.setValue(_local3, _local7);
                        };
                        this._previousTime = _local9;
                    }
                    else
                    {
                        if (_local6 == GraphGroup.MEM)
                        {
                            _local2 = _local8[0];
                            _local3 = (Math.round((System.totalMemory / 10485.76)) / 100);
                            _local4.updateMinMax(_local3);
                            _local2.setValue(_local3, _local7);
                        }
                        else
                        {
                            this.updateExternalGraphGroup(_local4);
                        };
                    };
                };
            };
            if (((remoter.canSend) && (((this._hadGraph) || (this._groups.length)))))
            {
                _local11 = this._groups.length;
                _local12 = new ByteArray();
                _local13 = 0;
                while (_local13 < _local11)
                {
                    GraphGroup(this._groups[_local13]).toBytes(_local12);
                    _local13++;
                };
                remoter.send("graph", _local12);
                this._hadGraph = (this._groups.length > 0);
            };
            return (this._groups);
        }

        private function updateExternalGraphGroup(group:GraphGroup):void
        {
            var i:GraphInterest;
            var v:Number;
            for each (i in group.interests)
            {
                try
                {
                    v = i.getCurrentValue();
                    i.setValue(v, group.averaging);
                }
                catch(e:Error)
                {
                    report(((((("Error with graph value for key [" + i.key) + "] in [") + group.name) + "]. ") + e), 10);
                    remove(group.name, i.obj, i.prop);
                };
                group.updateMinMax(v);
            };
        }

        private function handleRemoteGraph(_arg1:ByteArray=null):void
        {
            var _local2:Array;
            if (((_arg1) && (_arg1.length)))
            {
                _arg1.position = 0;
                _local2 = new Array();
                while (_arg1.bytesAvailable)
                {
                    _local2.push(GraphGroup.FromBytes(_arg1));
                };
                console.panels.updateGraphs(_local2);
            }
            else
            {
                console.panels.updateGraphs(new Array());
            };
        }


    }
}

