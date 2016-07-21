package robotlegs.bender.framework.impl
{
    import robotlegs.bender.framework.api.IMessageDispatcher;
    import flash.utils.Dictionary;

    public final class MessageDispatcher implements IMessageDispatcher 
    {

        private const _handlers:Dictionary = new Dictionary();


        public function addMessageHandler(_arg1:Object, _arg2:Function):void
        {
            var _local3:Array = this._handlers[_arg1];
            if (_local3)
            {
                if (_local3.indexOf(_arg2) == -1)
                {
                    _local3.push(_arg2);
                };
            }
            else
            {
                this._handlers[_arg1] = [_arg2];
            };
        }

        public function hasMessageHandler(_arg1:Object):Boolean
        {
            return (this._handlers[_arg1]);
        }

        public function removeMessageHandler(_arg1:Object, _arg2:Function):void
        {
            var _local3:Array;
            _local3 = this._handlers[_arg1];
            var _local4:int = ((_local3) ? _local3.indexOf(_arg2) : -1);
            if (_local4 != -1)
            {
                _local3.splice(_local4, 1);
                if (_local3.length == 0)
                {
                    delete this._handlers[_arg1];
                };
            };
        }

        public function dispatchMessage(_arg1:Object, _arg2:Function=null, _arg3:Boolean=false):void
        {
            var _local4:Array = this._handlers[_arg1];
            if (_local4)
            {
                _local4 = _local4.concat();
                ((_arg3) || (_local4.reverse()));
                new MessageRunner(_arg1, _local4, _arg2).run();
            }
            else
            {
                ((_arg2) && (safelyCallBack(_arg2)));
            };
        }


    }
}

import robotlegs.bender.framework.impl.safelyCallBack;

class MessageRunner 
{

    /*private*/ var _message:Object;
    /*private*/ var _handlers:Array;
    /*private*/ var _callback:Function;

    public function MessageRunner(_arg1:Object, _arg2:Array, _arg3:Function)
    {
        this._message = _arg1;
        this._handlers = _arg2;
        this._callback = _arg3;
    }

    public function run():void
    {
        this.next();
    }

    /*private*/ function next():void
    {
        var handler:Function;
        var handled:Boolean;
        while ((handler = this._handlers.pop()))
        {
            if (handler.length == 0)
            {
                (handler());
            }
            else
            {
                if (handler.length == 1)
                {
                    (handler(this._message));
                }
                else
                {
                    if (handler.length == 2)
                    {
                        (handler(this._message, function (_arg1:Object=null, _arg2:Object=null):void
                        {
                            if (handled)
                            {
                                return;
                            };
                            handled = true;
                            if (((_arg1) || ((_handlers.length == 0))))
                            {
                                ((_callback) && (safelyCallBack(_callback, _arg1, _message)));
                            }
                            else
                            {
                                next();
                            };
                        }));
                        return;
                    };
                    throw (new Error("Bad handler signature"));
                };
            };
        };
        ((this._callback) && (safelyCallBack(this._callback, null, this._message)));
    }


}

