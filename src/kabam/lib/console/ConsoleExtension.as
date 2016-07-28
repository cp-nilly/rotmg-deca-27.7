package kabam.lib.console
{
    import kabam.lib.resizing.ResizeExtension;

    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.extensions.signalCommandMap.SignalCommandMapExtension;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.IExtension;

    public class ConsoleExtension implements IExtension
    {
        [Inject]
        public var contextView:ContextView;

        public function extend(_arg1:IContext):void
        {
            _arg1.install(SignalCommandMapExtension).install(ResizeExtension).configure(ConsoleConfig);
        }
    }
}

