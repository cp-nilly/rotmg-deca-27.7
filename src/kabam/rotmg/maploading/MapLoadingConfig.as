package kabam.rotmg.maploading
{
    import kabam.rotmg.maploading.commands.CharacterAnimationFactory;
    import kabam.rotmg.maploading.commands.ShowLoadingViewCommand;
    import kabam.rotmg.maploading.signals.ChangeMapSignal;
    import kabam.rotmg.maploading.signals.HideMapLoadingSignal;
    import kabam.rotmg.maploading.signals.HideMapLoadingSignalNoFade;
    import kabam.rotmg.maploading.signals.MapLoadedSignal;
    import kabam.rotmg.maploading.signals.ShowLoadingViewSignal;
    import kabam.rotmg.maploading.view.MapLoadingMediator;
    import kabam.rotmg.maploading.view.MapLoadingView;

    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
    import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
    import robotlegs.bender.framework.api.IConfig;
    import robotlegs.bender.framework.api.IInjector;

    public class MapLoadingConfig implements IConfig
    {
        [Inject]
        public var injector:IInjector;
        [Inject]
        public var commandMap:ISignalCommandMap;
        [Inject]
        public var mediatorMap:IMediatorMap;

        public function configure():void
        {
            this.injector.map(HideMapLoadingSignal).asSingleton();
            this.injector.map(ChangeMapSignal).asSingleton();
            this.injector.map(MapLoadedSignal).asSingleton();
            this.injector.map(HideMapLoadingSignalNoFade).asSingleton();
            this.injector.map(CharacterAnimationFactory).asSingleton();
            this.commandMap.map(ShowLoadingViewSignal).toCommand(ShowLoadingViewCommand);
            this.mediatorMap.map(MapLoadingView).toMediator(MapLoadingMediator);
        }
    }
}

