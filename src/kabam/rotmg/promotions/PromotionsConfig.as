package kabam.rotmg.promotions
{
    import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
    import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
    import kabam.rotmg.promotions.model.BeginnersPackageModel;
    import kabam.rotmg.packages.control.BeginnersPackageAvailableSignal;
    import kabam.rotmg.promotions.view.BeginnersPackageButton;
    import kabam.rotmg.promotions.view.BeginnersPackageButtonMediator;
    import kabam.rotmg.promotions.view.BeginnersPackageOfferDialog;
    import kabam.rotmg.promotions.view.BeginnersPackageOfferDialogMediator;
    import kabam.rotmg.promotions.view.WebChoosePaymentTypeDialog;
    import kabam.rotmg.promotions.view.WebChoosePaymentTypeDialogMediator;
    import kabam.rotmg.promotions.signals.ShowBeginnersPackageSignal;
    import kabam.rotmg.promotions.commands.ShowBeginnersPackageCommand;
    import kabam.rotmg.promotions.signals.BuyBeginnersPackageSignal;
    import kabam.rotmg.promotions.commands.BuyBeginnersPackageCommand;
    import kabam.rotmg.promotions.signals.MakeBeginnersPackagePaymentSignal;
    import kabam.rotmg.promotions.commands.MakeBeginnersPackagePaymentCommand;
    import kabam.rotmg.promotions.service.GetDaysRemainingTask;

    public class PromotionsConfig implements IConfig 
    {

        [Inject]
        public var injector:IInjector;
        [Inject]
        public var mediatorMap:IMediatorMap;
        [Inject]
        public var commandMap:ISignalCommandMap;


        public function configure():void
        {
            this.injector.map(GetDaysRemainingTask).asSingleton();
            this.injector.map(BeginnersPackageModel).asSingleton();
            this.injector.map(BeginnersPackageAvailableSignal).asSingleton();
            this.mediatorMap.map(BeginnersPackageButton).toMediator(BeginnersPackageButtonMediator);
            this.mediatorMap.map(BeginnersPackageOfferDialog).toMediator(BeginnersPackageOfferDialogMediator);
            this.mediatorMap.map(WebChoosePaymentTypeDialog).toMediator(WebChoosePaymentTypeDialogMediator);
            this.commandMap.map(ShowBeginnersPackageSignal).toCommand(ShowBeginnersPackageCommand);
            this.commandMap.map(BuyBeginnersPackageSignal).toCommand(BuyBeginnersPackageCommand);
            this.commandMap.map(MakeBeginnersPackagePaymentSignal).toCommand(MakeBeginnersPackagePaymentCommand);
        }


    }
}

