package robotlegs.bender.extensions.logging
{
    import robotlegs.bender.framework.api.IExtension;
    import robotlegs.bender.framework.impl.UID;
    import robotlegs.bender.extensions.logging.impl.TraceLogTarget;
    import robotlegs.bender.framework.api.IContext;

    public class TraceLoggingExtension implements IExtension 
    {

        private const _uid:String = UID.create(TraceLoggingExtension);


        public function extend(_arg1:IContext):void
        {
            _arg1.addLogTarget(new TraceLogTarget(_arg1));
        }

        public function toString():String
        {
            return (this._uid);
        }


    }
}

