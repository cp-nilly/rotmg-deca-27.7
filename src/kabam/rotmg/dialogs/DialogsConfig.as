package kabam.rotmg.dialogs
{
    import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
    import kabam.lib.console.signals.RegisterConsoleActionSignal;
    import kabam.lib.console.vo.ConsoleAction;
    import kabam.rotmg.dialogs.control.ShowDialogBackgroundSignal;
    import kabam.rotmg.dialogs.control.OpenDialogSignal;
    import kabam.rotmg.dialogs.control.OpenDialogNoModalSignal;
    import kabam.rotmg.dialogs.control.CloseDialogsSignal;
    import kabam.rotmg.dialogs.control.PushDialogSignal;
    import kabam.rotmg.dialogs.control.PopDialogSignal;
    import kabam.rotmg.dialogs.view.DialogsView;
    import kabam.rotmg.dialogs.view.DialogsMediator;

    public class DialogsConfig implements IConfig 
    {

        [Inject]
        public var injector:IInjector;
        [Inject]
        public var mediatorMap:IMediatorMap;
        [Inject]
        public var register:RegisterConsoleActionSignal;


        public function configure():void
        {
            var _local1:ConsoleAction;
            this.injector.map(ShowDialogBackgroundSignal).asSingleton();
            this.injector.map(OpenDialogSignal).asSingleton();
            this.injector.map(OpenDialogNoModalSignal).asSingleton();
            this.injector.map(CloseDialogsSignal).asSingleton();
            this.injector.map(PushDialogSignal).asSingleton();
            this.injector.map(PopDialogSignal).asSingleton();
            this.mediatorMap.map(DialogsView).toMediator(DialogsMediator);
            _local1 = new ConsoleAction();
            _local1.name = "closeDialogs";
            _local1.description = "closes all open dialogs";
            this.register.dispatch(_local1, this.injector.getInstance(CloseDialogsSignal));
        }


    }
}

