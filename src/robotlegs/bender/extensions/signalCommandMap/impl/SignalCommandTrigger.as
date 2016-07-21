package robotlegs.bender.extensions.signalCommandMap.impl
{
    import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
    import __AS3__.vec.Vector;
    import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
    import org.osflash.signals.ISignal;
    import org.swiftsuspenders.Injector;
    import flash.utils.Dictionary;
    import flash.utils.describeType;
    import robotlegs.bender.framework.impl.guardsApprove;
    import robotlegs.bender.framework.impl.applyHooks;
    import __AS3__.vec.*;

    public class SignalCommandTrigger implements ICommandTrigger 
    {

        private const _mappings:Vector.<ICommandMapping> = new Vector.<ICommandMapping>();

        private var _signal:ISignal;
        private var _signalClass:Class;
        private var _once:Boolean;
        protected var _injector:Injector;
        protected var _signalMap:Dictionary;
        protected var _verifiedCommandClasses:Dictionary;

        public function SignalCommandTrigger(_arg1:Injector, _arg2:Class, _arg3:Boolean=false)
        {
            this._injector = _arg1;
            this._signalClass = _arg2;
            this._once = _arg3;
            this._signalMap = new Dictionary(false);
            this._verifiedCommandClasses = new Dictionary(false);
        }

        public function addMapping(_arg1:ICommandMapping):void
        {
            this.verifyCommandClass(_arg1);
            this._mappings.push(_arg1);
            if (this._mappings.length == 1)
            {
                this.addSignal(_arg1.commandClass);
            };
        }

        public function removeMapping(_arg1:ICommandMapping):void
        {
            var _local2:int = this._mappings.indexOf(_arg1);
            if (_local2 != -1)
            {
                this._mappings.splice(_local2, 1);
                if (this._mappings.length == 0)
                {
                    this.removeSignal(_arg1.commandClass);
                };
            };
        }

        protected function verifyCommandClass(mapping:ICommandMapping):void
        {
            if (this._verifiedCommandClasses[mapping.commandClass])
            {
                return;
            };
            if (describeType(mapping.commandClass).factory.method.(@name == "execute").length() == 0)
            {
                throw (new Error("Command Class must expose an execute method"));
            };
            this._verifiedCommandClasses[mapping.commandClass] = true;
        }

        protected function routeSignalToCommand(_arg1:ISignal, _arg2:Array, _arg3:Class, _arg4:Boolean):void
        {
            var _local6:ICommandMapping;
            var _local7:Boolean;
            var _local8:Object;
            var _local5:Vector.<ICommandMapping> = this._mappings.concat();
            for each (_local6 in _local5)
            {
                this.mapSignalValues(_arg1.valueClasses, _arg2);
                _local7 = guardsApprove(_local6.guards, this._injector);
                if (_local7)
                {
                    ((this._once) && (this.removeMapping(_local6)));
                    this._injector.map(_local6.commandClass).asSingleton();
                    _local8 = this._injector.getInstance(_local6.commandClass);
                    applyHooks(_local6.hooks, this._injector);
                    this._injector.unmap(_local6.commandClass);
                };
                this.unmapSignalValues(_arg1.valueClasses, _arg2);
                if (_local7)
                {
                    _local8.execute();
                };
            };
            if (this._once)
            {
                this.removeSignal(_arg3);
            };
        }

        protected function mapSignalValues(_arg1:Array, _arg2:Array):void
        {
            var _local3:uint;
            while (_local3 < _arg1.length)
            {
                this._injector.map(_arg1[_local3]).toValue(_arg2[_local3]);
                _local3++;
            };
        }

        protected function unmapSignalValues(_arg1:Array, _arg2:Array):void
        {
            var _local3:uint;
            while (_local3 < _arg1.length)
            {
                this._injector.unmap(_arg1[_local3]);
                _local3++;
            };
        }

        protected function hasSignalCommand(_arg1:ISignal, _arg2:Class):Boolean
        {
            var _local3:Dictionary = this._signalMap[_arg1];
            if (_local3 == null)
            {
                return (false);
            };
            var _local4:Function = _local3[_arg2];
            return (!((_local4 == null)));
        }

        private function addSignal(commandClass:Class):void
        {
            if (this.hasSignalCommand(this._signal, commandClass))
            {
                return;
            };
            this._signal = this._injector.getInstance(this._signalClass);
            this._injector.map(this._signalClass).toValue(this._signal);
            var signalCommandMap:Dictionary = (this._signalMap[this._signal] = ((this._signalMap[this._signal]) || (new Dictionary(false))));
            var callback:Function = function ():void
            {
                routeSignalToCommand(_signal, arguments, commandClass, _once);
            };
            signalCommandMap[commandClass] = callback;
            this._signal.add(callback);
        }

        private function removeSignal(_arg1:Class):void
        {
            var _local2:Dictionary = this._signalMap[this._signal];
            if (_local2 == null)
            {
                return;
            };
            var _local3:Function = _local2[_arg1];
            if (_local3 == null)
            {
                return;
            };
            this._signal.remove(_local3);
            delete _local2[_arg1];
        }


    }
}

