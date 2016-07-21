package com.google.analytics.core
{
    import flash.net.SharedObject;
    import com.google.analytics.data.UTMB;
    import com.google.analytics.data.UTMC;
    import com.google.analytics.data.UTMA;
    import com.google.analytics.debug.DebugConfiguration;
    import com.google.analytics.data.UTMK;
    import com.google.analytics.v4.Configuration;
    import com.google.analytics.data.UTMV;
    import com.google.analytics.data.UTMX;
    import com.google.analytics.data.UTMZ;
    import flash.events.NetStatusEvent;
    import flash.net.SharedObjectFlushStatus;
    import com.google.analytics.debug.VisualDebugMode;

    public dynamic class Buffer 
    {

        private var _SO:SharedObject;
        private var _data:Object;
        private var _OBJ:Object;
        private var _utmb:UTMB;
        private var _utmc:UTMC;
        private var _utma:UTMA;
        private var _debug:DebugConfiguration;
        private var _utmk:UTMK;
        private var _config:Configuration;
        private var _utmv:UTMV;
        private var _utmx:UTMX;
        private var _utmz:UTMZ;
        private var _volatile:Boolean;

        public function Buffer(_arg1:Configuration, _arg2:DebugConfiguration, _arg3:Boolean=false, _arg4:Object=null)
        {
            var _local5:String;
            super();
            _config = _arg1;
            _debug = _arg2;
            _data = _arg4;
            _volatile = _arg3;
            if (_volatile)
            {
                _OBJ = new Object();
                if (_data)
                {
                    for (_local5 in _data)
                    {
                        _OBJ[_local5] = _data[_local5];
                    };
                };
            };
        }

        public function save():void
        {
            var flushStatus:String;
            if (!isVolatile())
            {
                flushStatus = null;
                try
                {
                    flushStatus = _SO.flush();
                }
                catch(e:Error)
                {
                    _debug.warning("Error...Could not write SharedObject to disk");
                };
                switch (flushStatus)
                {
                    case SharedObjectFlushStatus.PENDING:
                        _debug.info("Requesting permission to save object...");
                        _SO.addEventListener(NetStatusEvent.NET_STATUS, _onFlushStatus);
                        return;
                    case SharedObjectFlushStatus.FLUSHED:
                        _debug.info("Value flushed to disk.");
                        return;
                };
            };
        }

        public function get utmv():UTMV
        {
            if (!hasUTMV())
            {
                _createUMTV();
            };
            return (_utmv);
        }

        public function get utmx():UTMX
        {
            if (!hasUTMX())
            {
                _createUMTX();
            };
            return (_utmx);
        }

        public function get utmz():UTMZ
        {
            if (!hasUTMZ())
            {
                _createUMTZ();
            };
            return (_utmz);
        }

        public function hasUTMA():Boolean
        {
            if (_utma)
            {
                return (true);
            };
            return (false);
        }

        public function hasUTMB():Boolean
        {
            if (_utmb)
            {
                return (true);
            };
            return (false);
        }

        public function hasUTMC():Boolean
        {
            if (_utmc)
            {
                return (true);
            };
            return (false);
        }

        public function clearCookies():void
        {
            utma.reset();
            utmb.reset();
            utmc.reset();
            utmz.reset();
            utmv.reset();
            utmk.reset();
        }

        public function resetCurrentSession():void
        {
            _clearUTMB();
            _clearUTMC();
            save();
        }

        public function hasUTMK():Boolean
        {
            if (_utmk)
            {
                return (true);
            };
            return (false);
        }

        public function getLinkerUrl(_arg1:String="", _arg2:Boolean=false):String
        {
            var _local3:String = toLinkerParams();
            var _local4:String = _arg1;
            var _local5:Array = _arg1.split("#");
            if (_local3)
            {
                if (_arg2)
                {
                    if (1 >= _local5.length)
                    {
                        _local4 = (_local4 + ("#" + _local3));
                    }
                    else
                    {
                        _local4 = (_local4 + ("&" + _local3));
                    };
                }
                else
                {
                    if (1 >= _local5.length)
                    {
                        if (_arg1.indexOf("?") > -1)
                        {
                            _local4 = (_local4 + "&");
                        }
                        else
                        {
                            _local4 = (_local4 + "?");
                        };
                        _local4 = (_local4 + _local3);
                    }
                    else
                    {
                        _local4 = _local5[0];
                        if (_arg1.indexOf("?") > -1)
                        {
                            _local4 = (_local4 + "&");
                        }
                        else
                        {
                            _local4 = (_local4 + "?");
                        };
                        _local4 = (_local4 + ((_local3 + "#") + _local5[1]));
                    };
                };
            };
            return (_local4);
        }

        public function generateCookiesHash():Number
        {
            var _local1 = "";
            _local1 = (_local1 + utma.valueOf());
            _local1 = (_local1 + utmb.valueOf());
            _local1 = (_local1 + utmc.valueOf());
            _local1 = (_local1 + utmx.valueOf());
            _local1 = (_local1 + utmz.valueOf());
            _local1 = (_local1 + utmv.valueOf());
            return (Utils.generateHash(_local1));
        }

        private function _createUMTA():void
        {
            _utma = new UTMA();
            _utma.proxy = this;
        }

        private function _createUMTB():void
        {
            _utmb = new UTMB();
            _utmb.proxy = this;
        }

        private function _createUMTC():void
        {
            _utmc = new UTMC();
        }

        public function hasUTMV():Boolean
        {
            if (_utmv)
            {
                return (true);
            };
            return (false);
        }

        private function _createUMTK():void
        {
            _utmk = new UTMK();
            _utmk.proxy = this;
        }

        public function hasUTMX():Boolean
        {
            if (_utmx)
            {
                return (true);
            };
            return (false);
        }

        public function hasUTMZ():Boolean
        {
            if (_utmz)
            {
                return (true);
            };
            return (false);
        }

        private function _createUMTV():void
        {
            _utmv = new UTMV();
            _utmv.proxy = this;
        }

        private function _createUMTX():void
        {
            _utmx = new UTMX();
            _utmx.proxy = this;
        }

        private function _createUMTZ():void
        {
            _utmz = new UTMZ();
            _utmz.proxy = this;
        }

        public function updateUTMA(_arg1:Number):void
        {
            if (_debug.verbose)
            {
                _debug.info((("updateUTMA( " + _arg1) + " )"), VisualDebugMode.advanced);
            };
            if (!utma.isEmpty())
            {
                if (isNaN(utma.sessionCount))
                {
                    utma.sessionCount = 1;
                }
                else
                {
                    utma.sessionCount = (utma.sessionCount + 1);
                };
                utma.lastTime = utma.currentTime;
                utma.currentTime = _arg1;
            };
        }

        public function isGenuine():Boolean
        {
            if (!hasUTMK())
            {
                return (true);
            };
            return ((utmk.hash == generateCookiesHash()));
        }

        private function _onFlushStatus(_arg1:NetStatusEvent):void
        {
            _debug.info("User closed permission dialog...");
            switch (_arg1.info.code)
            {
                case "SharedObject.Flush.Success":
                    _debug.info("User granted permission -- value saved.");
                    break;
                case "SharedObject.Flush.Failed":
                    _debug.info("User denied permission -- value not saved.");
                    break;
            };
            _SO.removeEventListener(NetStatusEvent.NET_STATUS, _onFlushStatus);
        }

        public function toLinkerParams():String
        {
            var _local1 = "";
            _local1 = (_local1 + utma.toURLString());
            _local1 = (_local1 + ("&" + utmb.toURLString()));
            _local1 = (_local1 + ("&" + utmc.toURLString()));
            _local1 = (_local1 + ("&" + utmx.toURLString()));
            _local1 = (_local1 + ("&" + utmz.toURLString()));
            _local1 = (_local1 + ("&" + utmv.toURLString()));
            return ((_local1 + ("&__utmk=" + generateCookiesHash())));
        }

        private function _clearUTMA():void
        {
            _utma = null;
            if (!isVolatile())
            {
                _SO.data.utma = null;
                delete _SO.data.utma;
            };
        }

        private function _clearUTMC():void
        {
            _utmc = null;
        }

        private function _clearUTMB():void
        {
            _utmb = null;
            if (!isVolatile())
            {
                _SO.data.utmb = null;
                delete _SO.data.utmb;
            };
        }

        public function update(_arg1:String, _arg2:*):void
        {
            if (isVolatile())
            {
                _OBJ[_arg1] = _arg2;
            }
            else
            {
                _SO.data[_arg1] = _arg2;
            };
        }

        public function createSO():void
        {
            var saveSO:Boolean;
            UTMZ.defaultTimespan = _config.conversionTimeout;
            UTMB.defaultTimespan = _config.sessionTimeout;
            if (!_volatile)
            {
                try
                {
                    _SO = SharedObject.getLocal(_config.cookieName, _config.cookiePath);
                }
                catch(e:Error)
                {
                    if (_debug.active)
                    {
                        _debug.warning(((("Shared Object " + _config.cookieName) + " failed to be set\nreason: ") + e.message));
                    };
                };
                saveSO = false;
                if (_SO.data.utma)
                {
                    if (!hasUTMA())
                    {
                        _createUMTA();
                    };
                    _utma.fromSharedObject(_SO.data.utma);
                    if (_debug.verbose)
                    {
                        _debug.info(("found: " + _utma.toString(true)), VisualDebugMode.geek);
                    };
                    if (_utma.isExpired())
                    {
                        if (_debug.verbose)
                        {
                            _debug.warning("UTMA has expired", VisualDebugMode.advanced);
                        };
                        _clearUTMA();
                        saveSO = true;
                    };
                };
                if (_SO.data.utmb)
                {
                    if (!hasUTMB())
                    {
                        _createUMTB();
                    };
                    _utmb.fromSharedObject(_SO.data.utmb);
                    if (_debug.verbose)
                    {
                        _debug.info(("found: " + _utmb.toString(true)), VisualDebugMode.geek);
                    };
                    if (_utmb.isExpired())
                    {
                        if (_debug.verbose)
                        {
                            _debug.warning("UTMB has expired", VisualDebugMode.advanced);
                        };
                        _clearUTMB();
                        saveSO = true;
                    };
                };
                if (_SO.data.utmc)
                {
                    delete _SO.data.utmc;
                    saveSO = true;
                };
                if (_SO.data.utmk)
                {
                    if (!hasUTMK())
                    {
                        _createUMTK();
                    };
                    _utmk.fromSharedObject(_SO.data.utmk);
                    if (_debug.verbose)
                    {
                        _debug.info(("found: " + _utmk.toString()), VisualDebugMode.geek);
                    };
                };
                if (!hasUTMX())
                {
                    _createUMTX();
                };
                if (_SO.data.utmv)
                {
                    if (!hasUTMV())
                    {
                        _createUMTV();
                    };
                    _utmv.fromSharedObject(_SO.data.utmv);
                    if (_debug.verbose)
                    {
                        _debug.info(("found: " + _utmv.toString(true)), VisualDebugMode.geek);
                    };
                    if (_utmv.isExpired())
                    {
                        if (_debug.verbose)
                        {
                            _debug.warning("UTMV has expired", VisualDebugMode.advanced);
                        };
                        _clearUTMV();
                        saveSO = true;
                    };
                };
                if (_SO.data.utmz)
                {
                    if (!hasUTMZ())
                    {
                        _createUMTZ();
                    };
                    _utmz.fromSharedObject(_SO.data.utmz);
                    if (_debug.verbose)
                    {
                        _debug.info(("found: " + _utmz.toString(true)), VisualDebugMode.geek);
                    };
                    if (_utmz.isExpired())
                    {
                        if (_debug.verbose)
                        {
                            _debug.warning("UTMZ has expired", VisualDebugMode.advanced);
                        };
                        _clearUTMZ();
                        saveSO = true;
                    };
                };
                if (saveSO)
                {
                    save();
                };
            };
        }

        private function _clearUTMZ():void
        {
            _utmz = null;
            if (!isVolatile())
            {
                _SO.data.utmz = null;
                delete _SO.data.utmz;
            };
        }

        private function _clearUTMV():void
        {
            _utmv = null;
            if (!isVolatile())
            {
                _SO.data.utmv = null;
                delete _SO.data.utmv;
            };
        }

        public function isVolatile():Boolean
        {
            return (_volatile);
        }

        public function get utma():UTMA
        {
            if (!hasUTMA())
            {
                _createUMTA();
            };
            return (_utma);
        }

        public function get utmb():UTMB
        {
            if (!hasUTMB())
            {
                _createUMTB();
            };
            return (_utmb);
        }

        public function get utmc():UTMC
        {
            if (!hasUTMC())
            {
                _createUMTC();
            };
            return (_utmc);
        }

        public function get utmk():UTMK
        {
            if (!hasUTMK())
            {
                _createUMTK();
            };
            return (_utmk);
        }


    }
}

