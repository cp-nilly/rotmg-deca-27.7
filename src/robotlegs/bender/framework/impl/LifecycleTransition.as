package robotlegs.bender.framework.impl
{
    import __AS3__.vec.Vector;
    import robotlegs.bender.framework.api.LifecycleEvent;
    import __AS3__.vec.*;

    public class LifecycleTransition 
    {

        private const _fromStates:Vector.<String> = new Vector.<String>();
        private const _dispatcher:MessageDispatcher = new MessageDispatcher();
        private const _callbacks:Array = [];

        private var _name:String;
        private var _lifecycle:Lifecycle;
        private var _transitionState:String;
        private var _finalState:String;
        private var _preTransitionEvent:String;
        private var _transitionEvent:String;
        private var _postTransitionEvent:String;
        private var _reverse:Boolean;

        public function LifecycleTransition(_arg1:String, _arg2:Lifecycle)
        {
            this._name = _arg1;
            this._lifecycle = _arg2;
        }

        public function fromStates(... _args):LifecycleTransition
        {
            var _local2:String;
            for each (_local2 in _args)
            {
                this._fromStates.push(_local2);
            };
            return (this);
        }

        public function toStates(_arg1:String, _arg2:String):LifecycleTransition
        {
            this._transitionState = _arg1;
            this._finalState = _arg2;
            return (this);
        }

        public function withEvents(_arg1:String, _arg2:String, _arg3:String):LifecycleTransition
        {
            this._preTransitionEvent = _arg1;
            this._transitionEvent = _arg2;
            this._postTransitionEvent = _arg3;
            ((this._reverse) && (this._lifecycle.addReversedEventTypes(_arg1, _arg2, _arg3)));
            return (this);
        }

        public function inReverse():LifecycleTransition
        {
            this._reverse = true;
            this._lifecycle.addReversedEventTypes(this._preTransitionEvent, this._transitionEvent, this._postTransitionEvent);
            return (this);
        }

        public function addBeforeHandler(_arg1:Function):LifecycleTransition
        {
            this._dispatcher.addMessageHandler(this._name, _arg1);
            return (this);
        }

        public function enter(callback:Function=null):void
        {
            var initialState:String;
            if (this._lifecycle.state == this._finalState)
            {
                ((callback) && (safelyCallBack(callback, null, this._name)));
                return;
            };
            if (this._lifecycle.state == this._transitionState)
            {
                ((callback) && (this._callbacks.push(callback)));
                return;
            };
            if (this.invalidTransition())
            {
                this.reportError("Invalid transition", [callback]);
                return;
            };
            initialState = this._lifecycle.state;
            ((callback) && (this._callbacks.push(callback)));
            this.setState(this._transitionState);
            this._dispatcher.dispatchMessage(this._name, function (_arg1:Object):void
            {
                var _local3:Function;
                if (_arg1)
                {
                    setState(initialState);
                    reportError(_arg1, _callbacks);
                    return;
                };
                dispatch(_preTransitionEvent);
                dispatch(_transitionEvent);
                setState(_finalState);
                var _local2:Array = _callbacks.concat();
                _callbacks.length = 0;
                for each (_local3 in _local2)
                {
                    safelyCallBack(_local3, null, _name);
                };
                dispatch(_postTransitionEvent);
            }, this._reverse);
        }

        private function invalidTransition():Boolean
        {
            return ((((this._fromStates.length > 0)) && ((this._fromStates.indexOf(this._lifecycle.state) == -1))));
        }

        private function setState(_arg1:String):void
        {
            ((_arg1) && (this._lifecycle.setCurrentState(_arg1)));
        }

        private function dispatch(_arg1:String):void
        {
            if (((_arg1) && (this._lifecycle.hasEventListener(_arg1))))
            {
                this._lifecycle.dispatchEvent(new LifecycleEvent(_arg1));
            };
        }

        private function reportError(_arg1:Object, _arg2:Array=null):void
        {
            var _local4:LifecycleEvent;
            var _local5:Function;
            var _local3:Error = (((_arg1 is Error)) ? (_arg1 as Error) : new Error(_arg1));
            if (this._lifecycle.hasEventListener(LifecycleEvent.ERROR))
            {
                _local4 = new LifecycleEvent(LifecycleEvent.ERROR);
                _local4.error = _local3;
                this._lifecycle.dispatchEvent(_local4);
                if (_arg2)
                {
                    for each (_local5 in _arg2)
                    {
                        ((_local5) && (safelyCallBack(_local5, _local3, this._name)));
                    };
                    _arg2.length = 0;
                };
            }
            else
            {
                throw (_local3);
            };
        }


    }
}

