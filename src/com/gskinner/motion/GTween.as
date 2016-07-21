package com.gskinner.motion
{
    import flash.events.EventDispatcher;
    import flash.display.Shape;
    import flash.utils.Dictionary;
    import flash.events.Event;
    import flash.utils.getTimer;
    import flash.events.IEventDispatcher;

    public class GTween extends EventDispatcher 
    {

        public static var version:Number = 2.01;
        public static var defaultDispatchEvents:Boolean = false;
        public static var defaultEase:Function = linearEase;
        public static var pauseAll:Boolean = false;
        public static var timeScaleAll:Number = 1;
        protected static var hasStarPlugins:Boolean = false;
        protected static var plugins:Object = {};
        protected static var shape:Shape;
        protected static var time:Number;
        protected static var tickList:Dictionary = new Dictionary(true);
        protected static var gcLockList:Dictionary = new Dictionary(false);

        protected var _delay:Number = 0;
        protected var _values:Object;
        protected var _paused:Boolean = true;
        protected var _position:Number;
        protected var _inited:Boolean;
        protected var _initValues:Object;
        protected var _rangeValues:Object;
        protected var _proxy:TargetProxy;
        public var autoPlay:Boolean = true;
        public var data;
        public var duration:Number;
        public var ease:Function;
        public var nextTween:GTween;
        public var pluginData:Object;
        public var reflect:Boolean;
        public var repeatCount:int = 1;
        public var target:Object;
        public var useFrames:Boolean;
        public var timeScale:Number = 1;
        public var positionOld:Number;
        public var ratio:Number;
        public var ratioOld:Number;
        public var calculatedPosition:Number;
        public var calculatedPositionOld:Number;
        public var suppressEvents:Boolean;
        public var dispatchEvents:Boolean;
        public var onComplete:Function;
        public var onChange:Function;
        public var onInit:Function;

        {
            staticInit();
        }

        public function GTween(_arg1:Object=null, _arg2:Number=1, _arg3:Object=null, _arg4:Object=null, _arg5:Object=null)
        {
            var _local6:Boolean;
            super();
            this.ease = defaultEase;
            this.dispatchEvents = defaultDispatchEvents;
            this.target = _arg1;
            this.duration = _arg2;
            this.pluginData = this.copy(_arg5, {});
            if (_arg4)
            {
                _local6 = _arg4.swapValues;
                delete _arg4.swapValues;
            };
            this.copy(_arg4, this);
            this.resetValues(_arg3);
            if (_local6)
            {
                this.swapValues();
            };
            if ((((((this.duration == 0)) && ((this.delay == 0)))) && (this.autoPlay)))
            {
                this.position = 0;
            };
        }

        public static function installPlugin(_arg1:Object, _arg2:Array, _arg3:Boolean=false):void
        {
            var _local5:String;
            var _local4:uint;
            while (_local4 < _arg2.length)
            {
                _local5 = _arg2[_local4];
                if (_local5 == "*")
                {
                    hasStarPlugins = true;
                };
                if (plugins[_local5] == null)
                {
                    plugins[_local5] = [_arg1];
                }
                else
                {
                    if (_arg3)
                    {
                        plugins[_local5].unshift(_arg1);
                    }
                    else
                    {
                        plugins[_local5].push(_arg1);
                    };
                };
                _local4++;
            };
        }

        public static function linearEase(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number
        {
            return (_arg1);
        }

        protected static function staticInit():void
        {
            (shape = new Shape()).addEventListener(Event.ENTER_FRAME, staticTick);
            time = (getTimer() / 1000);
        }

        protected static function staticTick(_arg1:Event):void
        {
            var _local4:Object;
            var _local5:GTween;
            var _local2:Number = time;
            time = (getTimer() / 1000);
            if (pauseAll)
            {
                return;
            };
            var _local3:Number = ((time - _local2) * timeScaleAll);
            for (_local4 in tickList)
            {
                _local5 = (_local4 as GTween);
                _local5.position = (_local5._position + (((_local5.useFrames) ? timeScaleAll : _local3) * _local5.timeScale));
            };
        }


        public function get paused():Boolean
        {
            return (this._paused);
        }

        public function set paused(_arg1:Boolean):void
        {
            if (_arg1 == this._paused)
            {
                return;
            };
            this._paused = _arg1;
            if (this._paused)
            {
                delete tickList[this];
                if ((this.target is IEventDispatcher))
                {
                    this.target.removeEventListener("_", this.invalidate);
                };
                delete gcLockList[this];
            }
            else
            {
                if (((isNaN(this._position)) || (((!((this.repeatCount == 0))) && ((this._position >= (this.repeatCount * this.duration)))))))
                {
                    this._inited = false;
                    this.calculatedPosition = (this.calculatedPositionOld = (this.ratio = (this.ratioOld = (this.positionOld = 0))));
                    this._position = -(this.delay);
                };
                tickList[this] = true;
                if ((this.target is IEventDispatcher))
                {
                    this.target.addEventListener("_", this.invalidate);
                }
                else
                {
                    gcLockList[this] = true;
                };
            };
        }

        public function get position():Number
        {
            return (this._position);
        }

        public function set position(_arg1:Number):void
        {
            var _local4:String;
            var _local5:Number;
            var _local6:Number;
            var _local7:Number;
            var _local8:Array;
            var _local9:uint;
            var _local10:uint;
            this.positionOld = this._position;
            this.ratioOld = this.ratio;
            this.calculatedPositionOld = this.calculatedPosition;
            var _local2:Number = (this.repeatCount * this.duration);
            var _local3:Boolean = (((_arg1 >= _local2)) && ((this.repeatCount > 0)));
            if (_local3)
            {
                if (this.calculatedPositionOld == _local2)
                {
                    return;
                };
                this._position = _local2;
                this.calculatedPosition = ((((this.reflect) && (!((this.repeatCount & 1))))) ? 0 : this.duration);
            }
            else
            {
                this._position = _arg1;
                this.calculatedPosition = (((this._position < 0)) ? 0 : (this._position % this.duration));
                if (((this.reflect) && (((this._position / this.duration) & 1))))
                {
                    this.calculatedPosition = (this.duration - this.calculatedPosition);
                };
            };
            this.ratio = (((((this.duration == 0)) && ((this._position >= 0)))) ? 1 : this.ease((this.calculatedPosition / this.duration), 0, 1, 1));
            if (((((this.target) && ((((this._position >= 0)) || ((this.positionOld >= 0)))))) && (!((this.calculatedPosition == this.calculatedPositionOld)))))
            {
                if (!this._inited)
                {
                    this.init();
                };
                for (_local4 in this._values)
                {
                    _local5 = this._initValues[_local4];
                    _local6 = this._rangeValues[_local4];
                    _local7 = (_local5 + (_local6 * this.ratio));
                    _local8 = plugins[_local4];
                    if (_local8)
                    {
                        _local9 = _local8.length;
                        _local10 = 0;
                        while (_local10 < _local9)
                        {
                            _local7 = _local8[_local10].tween(this, _local4, _local7, _local5, _local6, this.ratio, _local3);
                            _local10++;
                        };
                        if (!isNaN(_local7))
                        {
                            this.target[_local4] = _local7;
                        };
                    }
                    else
                    {
                        this.target[_local4] = _local7;
                    };
                };
            };
            if (hasStarPlugins)
            {
                _local8 = plugins["*"];
                _local9 = _local8.length;
                _local10 = 0;
                while (_local10 < _local9)
                {
                    _local8[_local10].tween(this, "*", NaN, NaN, NaN, this.ratio, _local3);
                    _local10++;
                };
            };
            if (!this.suppressEvents)
            {
                if (this.dispatchEvents)
                {
                    this.dispatchEvt("change");
                };
                if (this.onChange != null)
                {
                    this.onChange(this);
                };
            };
            if (_local3)
            {
                this.paused = true;
                if (this.nextTween)
                {
                    this.nextTween.paused = false;
                };
                if (!this.suppressEvents)
                {
                    if (this.dispatchEvents)
                    {
                        this.dispatchEvt("complete");
                    };
                    if (this.onComplete != null)
                    {
                        this.onComplete(this);
                    };
                };
            };
        }

        public function get delay():Number
        {
            return (this._delay);
        }

        public function set delay(_arg1:Number):void
        {
            if (this._position <= 0)
            {
                this._position = -(_arg1);
            };
            this._delay = _arg1;
        }

        public function get proxy():TargetProxy
        {
            if (this._proxy == null)
            {
                this._proxy = new TargetProxy(this);
            };
            return (this._proxy);
        }

        public function setValue(_arg1:String, _arg2:Number):void
        {
            this._values[_arg1] = _arg2;
            this.invalidate();
        }

        public function getValue(_arg1:String):Number
        {
            return (this._values[_arg1]);
        }

        public function deleteValue(_arg1:String):Boolean
        {
            delete this._rangeValues[_arg1];
            delete this._initValues[_arg1];
            return (delete this._values[_arg1]);
        }

        public function setValues(_arg1:Object):void
        {
            this.copy(_arg1, this._values, true);
            this.invalidate();
        }

        public function resetValues(_arg1:Object=null):void
        {
            this._values = {};
            this.setValues(_arg1);
        }

        public function getValues():Object
        {
            return (this.copy(this._values, {}));
        }

        public function getInitValue(_arg1:String):Number
        {
            return (this._initValues[_arg1]);
        }

        public function swapValues():void
        {
            var _local2:String;
            var _local3:Number;
            if (!this._inited)
            {
                this.init();
            };
            var _local1:Object = this._values;
            this._values = this._initValues;
            this._initValues = _local1;
            for (_local2 in this._rangeValues)
            {
                this._rangeValues[_local2] = (this._rangeValues[_local2] * -1);
            };
            if (this._position < 0)
            {
                _local3 = this.positionOld;
                this.position = 0;
                this._position = this.positionOld;
                this.positionOld = _local3;
            }
            else
            {
                this.position = this._position;
            };
        }

        public function init():void
        {
            var _local1:String;
            var _local2:Array;
            var _local3:uint;
            var _local4:Number;
            var _local5:uint;
            this._inited = true;
            this._initValues = {};
            this._rangeValues = {};
            for (_local1 in this._values)
            {
                if (plugins[_local1])
                {
                    _local2 = plugins[_local1];
                    _local3 = _local2.length;
                    _local4 = (((_local1 in this.target)) ? this.target[_local1] : NaN);
                    _local5 = 0;
                    while (_local5 < _local3)
                    {
                        _local4 = _local2[_local5].init(this, _local1, _local4);
                        _local5++;
                    };
                    if (!isNaN(_local4))
                    {
                        this._rangeValues[_local1] = (this._values[_local1] - (this._initValues[_local1] = _local4));
                    };
                }
                else
                {
                    this._rangeValues[_local1] = (this._values[_local1] - (this._initValues[_local1] = this.target[_local1]));
                };
            };
            if (hasStarPlugins)
            {
                _local2 = plugins["*"];
                _local3 = _local2.length;
                _local5 = 0;
                while (_local5 < _local3)
                {
                    _local2[_local5].init(this, "*", NaN);
                    _local5++;
                };
            };
            if (!this.suppressEvents)
            {
                if (this.dispatchEvents)
                {
                    this.dispatchEvt("init");
                };
                if (this.onInit != null)
                {
                    this.onInit(this);
                };
            };
        }

        public function beginning():void
        {
            this.position = 0;
            this.paused = true;
        }

        public function end():void
        {
            this.position = (((this.repeatCount)>0) ? (this.repeatCount * this.duration) : this.duration);
        }

        protected function invalidate():void
        {
            this._inited = false;
            if (this._position > 0)
            {
                this._position = 0;
            };
            if (this.autoPlay)
            {
                this.paused = false;
            };
        }

        protected function copy(_arg1:Object, _arg2:Object, _arg3:Boolean=false):Object
        {
            var _local4:String;
            for (_local4 in _arg1)
            {
                if (((_arg3) && ((_arg1[_local4] == null))))
                {
                    delete _arg2[_local4];
                }
                else
                {
                    _arg2[_local4] = _arg1[_local4];
                };
            };
            return (_arg2);
        }

        protected function dispatchEvt(_arg1:String):void
        {
            if (hasEventListener(_arg1))
            {
                dispatchEvent(new Event(_arg1));
            };
        }


    }
}

import flash.utils.Proxy;
import com.gskinner.motion.GTween;
import flash.utils.flash_proxy;

use namespace flash.utils.flash_proxy;

dynamic class TargetProxy extends Proxy 
{

    /*private*/ var tween:GTween;

    public function TargetProxy(_arg1:GTween):void
    {
        this.tween = _arg1;
    }

    override flash_proxy function callProperty(_arg1:*, ... _args)
    {
        return (this.tween.target[_arg1].apply(null, _args));
    }

    override flash_proxy function getProperty(_arg1:*)
    {
        var _local2:Number = this.tween.getValue(_arg1);
        return (((isNaN(_local2)) ? this.tween.target[_arg1] : _local2));
    }

    override flash_proxy function setProperty(_arg1:*, _arg2:*):void
    {
        if ((((((_arg2 is Boolean)) || ((_arg2 is String)))) || (isNaN(_arg2))))
        {
            this.tween.target[_arg1] = _arg2;
        }
        else
        {
            this.tween.setValue(String(_arg1), Number(_arg2));
        };
    }

    override flash_proxy function deleteProperty(_arg1:*):Boolean
    {
        this.tween.deleteValue(_arg1);
        return (true);
    }


}

