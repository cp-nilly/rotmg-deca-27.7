package robotlegs.bender.extensions.logging
{
    import robotlegs.bender.framework.api.IExtension;
    import robotlegs.bender.framework.impl.UID;
    import robotlegs.bender.framework.api.ILogger;
    import robotlegs.bender.extensions.logging.integration.LoggerProvider;
    import robotlegs.bender.framework.api.IContext;

    public class LoggingExtension implements IExtension 
    {

        private const _uid:String = UID.create(LoggingExtension);


        public function extend(_arg1:IContext):void
        {
            _arg1.injector.map(ILogger).toProvider(new LoggerProvider(_arg1));
        }

        public function toString():String
        {
            return (this._uid);
        }


    }
}

