package com.junkbyte.console.core
{
    import flash.utils.Dictionary;
    import com.junkbyte.console.Console;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getTimer;
    import flash.system.System;

    public class MemoryMonitor extends ConsoleCore 
    {

        private var _namesList:Object;
        private var _objectsList:Dictionary;
        private var _count:uint;

        public function MemoryMonitor(_arg1:Console)
        {
            super(_arg1);
            this._namesList = new Object();
            this._objectsList = new Dictionary(true);
            console.remoter.registerCallback("gc", this.gc);
        }

        public function watch(_arg1:Object, _arg2:String):String
        {
            var _local3:String = getQualifiedClassName(_arg1);
            if (!_arg2)
            {
                _arg2 = ((_local3 + "@") + getTimer());
            };
            if (this._objectsList[_arg1])
            {
                if (this._namesList[this._objectsList[_arg1]])
                {
                    this.unwatch(this._objectsList[_arg1]);
                };
            };
            if (this._namesList[_arg2])
            {
                if (this._objectsList[_arg1] == _arg2)
                {
                    this._count--;
                }
                else
                {
                    _arg2 = ((((_arg2 + "@") + getTimer()) + "_") + Math.floor((Math.random() * 100)));
                };
            };
            this._namesList[_arg2] = true;
            this._count++;
            this._objectsList[_arg1] = _arg2;
            return (_arg2);
        }

        public function unwatch(_arg1:String):void
        {
            var _local2:Object;
            for (_local2 in this._objectsList)
            {
                if (this._objectsList[_local2] == _arg1)
                {
                    delete this._objectsList[_local2];
                };
            };
            if (this._namesList[_arg1])
            {
                delete this._namesList[_arg1];
                this._count--;
            };
        }

        public function update():void
        {
            var _local3:Object;
            var _local4:String;
            if (this._count == 0)
            {
                return;
            };
            var _local1:Array = new Array();
            var _local2:Object = new Object();
            for (_local3 in this._objectsList)
            {
                _local2[this._objectsList[_local3]] = true;
            };
            for (_local4 in this._namesList)
            {
                if (!_local2[_local4])
                {
                    _local1.push(_local4);
                    delete this._namesList[_local4];
                    this._count--;
                };
            };
            if (_local1.length)
            {
                report(((("<b>GARBAGE COLLECTED " + _local1.length) + " item(s): </b>") + _local1.join(", ")), -2);
            };
        }

        public function get count():uint
        {
            return (this._count);
        }

        public function gc():void
        {
            var ok:Boolean;
            var str:String;
            if (remoter.remoting == Remoting.RECIEVER)
            {
                try
                {
                    remoter.send("gc");
                }
                catch(e:Error)
                {
                    report(e, 10);
                };
            }
            else
            {
                try
                {
                    if (System["gc"] != null)
                    {
                        var _local2 = System;
                        (_local2["gc"]());
                        ok = true;
                    };
                }
                catch(e:Error)
                {
                };
                str = ("Manual garbage collection " + ((ok) ? "successful." : "FAILED. You need debugger version of flash player."));
                report(str, ((ok) ? -1 : 10));
            };
        }


    }
}

