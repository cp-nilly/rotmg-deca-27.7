package kabam.rotmg.questrewards
{
    import kabam.rotmg.questrewards.controller.QuestFetchCompleteSignal;
    import kabam.rotmg.questrewards.controller.QuestRedeemCompleteSignal;
    import kabam.rotmg.questrewards.view.QuestRewardsContainer;
    import kabam.rotmg.questrewards.view.QuestRewardsMediator;
    import kabam.rotmg.questrewards.view.QuestRewardsPanel;
    import kabam.rotmg.questrewards.view.QuestRewardsPanelMediator;

    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
    import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
    import robotlegs.bender.framework.api.IConfig;
    import robotlegs.bender.framework.api.IInjector;

    public class QuestRewardsConfig implements IConfig
    {
        [Inject]
        public var injector:IInjector;
        [Inject]
        public var mediatorMap:IMediatorMap;
        [Inject]
        public var commandMap:ISignalCommandMap;

        public function configure():void
        {
            this.mediatorMap.map(QuestRewardsPanel).toMediator(QuestRewardsPanelMediator);
            this.mediatorMap.map(QuestRewardsContainer).toMediator(QuestRewardsMediator);
            this.injector.map(QuestFetchCompleteSignal).asSingleton();
            this.injector.map(QuestRedeemCompleteSignal).asSingleton();
        }
    }
}

