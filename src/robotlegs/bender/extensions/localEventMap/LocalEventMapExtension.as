package robotlegs.bender.extensions.localEventMap
{
    import robotlegs.bender.framework.api.IExtension;
    import robotlegs.bender.framework.impl.UID;
    import robotlegs.bender.extensions.localEventMap.api.IEventMap;
    import robotlegs.bender.extensions.localEventMap.impl.EventMap;
    import robotlegs.bender.framework.api.IContext;

    public class LocalEventMapExtension implements IExtension 
    {

        private const _uid:String = UID.create(LocalEventMapExtension);


        public function extend(_arg1:IContext):void
        {
            _arg1.injector.map(IEventMap).toType(EventMap);
        }

        public function toString():String
        {
            return (this._uid);
        }


    }
}

