package robotlegs.bender.extensions.eventCommandMap.impl
{
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.framework.impl.guardsApprove;
    import robotlegs.bender.framework.impl.applyHooks;
    import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;

    public class EventCommandFactory 
    {

        private var _injector:Injector;

        public function EventCommandFactory(_arg1:Injector)
        {
            this._injector = _arg1;
        }

        public function create(_arg1:ICommandMapping):Object
        {
            var _local2:Class;
            var _local3:Object;
            if (guardsApprove(_arg1.guards, this._injector))
            {
                _local2 = _arg1.commandClass;
                this._injector.map(_local2).asSingleton();
                _local3 = this._injector.getInstance(_local2);
                applyHooks(_arg1.hooks, this._injector);
                this._injector.unmap(_local2);
                return (_local3);
            };
            return (null);
        }


    }
}

