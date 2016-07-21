package kabam.rotmg.account.core.commands
{
    import kabam.rotmg.account.core.model.JSInitializedModel;
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.account.core.model.MoneyConfig;
    import kabam.rotmg.dialogs.control.OpenDialogSignal;
    import robotlegs.bender.framework.api.ILogger;
    import kabam.rotmg.build.api.BuildData;
    import kabam.rotmg.application.api.ApplicationSetup;
    import kabam.rotmg.core.model.PlayerModel;
    import kabam.rotmg.promotions.model.BeginnersPackageModel;
    import com.company.assembleegameclient.ui.dialogs.ErrorDialog;
    import flash.net.URLVariables;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.navigateToURL;
    import flash.external.ExternalInterface;
    import kabam.rotmg.build.api.BuildEnvironment;

    public class ExternalOpenMoneyWindowCommand 
    {

        private const TESTING_ERROR_MESSAGE:String = "You cannot purchase gold on the testing server";
        private const REGISTRATION_ERROR_MESSAGE:String = "You must be registered to buy gold";

        [Inject]
        public var moneyWindowModel:JSInitializedModel;
        [Inject]
        public var account:Account;
        [Inject]
        public var moneyConfig:MoneyConfig;
        [Inject]
        public var openDialog:OpenDialogSignal;
        [Inject]
        public var logger:ILogger;
        [Inject]
        public var buildData:BuildData;
        [Inject]
        public var openDialogSignal:OpenDialogSignal;
        [Inject]
        public var applicationSetup:ApplicationSetup;
        [Inject]
        public var playerModel:PlayerModel;
        [Inject]
        public var beginnersPackageModel:BeginnersPackageModel;


        public function execute():void
        {
            if (((this.isGoldPurchaseEnabled()) && (this.account.isRegistered())))
            {
                this.handleValidMoneyWindowRequest();
            }
            else
            {
                this.handleInvalidMoneyWindowRequest();
            };
        }

        private function handleInvalidMoneyWindowRequest():void
        {
            if (!this.isGoldPurchaseEnabled())
            {
                this.openDialogSignal.dispatch(new ErrorDialog(this.TESTING_ERROR_MESSAGE));
            }
            else
            {
                if (!this.account.isRegistered())
                {
                    this.openDialogSignal.dispatch(new ErrorDialog(this.REGISTRATION_ERROR_MESSAGE));
                };
            };
        }

        private function handleValidMoneyWindowRequest():void
        {
            try
            {
                this.openMoneyWindowFromBrowser();
            }
            catch(e:Error)
            {
                openMoneyWindowFromStandalonePlayer();
            };
        }

        private function openMoneyWindowFromStandalonePlayer():void
        {
            var _local1:String = this.applicationSetup.getAppEngineUrl(true);
            var _local2:URLVariables = new URLVariables();
            var _local3:URLRequest = new URLRequest();
            _local2.naid = this.account.getMoneyUserId();
            _local2.signedRequest = this.account.getMoneyAccessToken();
            if (this.beginnersPackageModel.isBeginnerAvailable())
            {
                _local2.createdat = this.beginnersPackageModel.getUserCreatedAt();
            }
            else
            {
                _local2.createdat = 0;
            };
            _local3.url = (_local1 + "/credits/kabamadd");
            _local3.method = URLRequestMethod.POST;
            _local3.data = _local2;
            navigateToURL(_local3, "_blank");
            this.logger.debug("Opening window from standalone player");
        }

        private function openMoneyWindowFromBrowser():void
        {
            this.initializeMoneyWindow();
            this.logger.debug("Attempting External Payments");
            ExternalInterface.call("rotmg.KabamPayment.displayPaymentWall");
        }

        private function initializeMoneyWindow():void
        {
            var _local1:Number;
            if (!this.moneyWindowModel.isInitialized)
            {
                if (this.beginnersPackageModel.isBeginnerAvailable())
                {
                    _local1 = this.beginnersPackageModel.getUserCreatedAt();
                }
                else
                {
                    _local1 = 0;
                };
                ExternalInterface.call(this.moneyConfig.jsInitializeFunction(), this.account.getMoneyUserId(), this.account.getMoneyAccessToken(), _local1);
                this.moneyWindowModel.isInitialized = true;
            };
        }

        private function isGoldPurchaseEnabled():Boolean
        {
            return (((!((this.buildData.getEnvironment() == BuildEnvironment.TESTING))) || (this.playerModel.isAdmin())));
        }


    }
}

