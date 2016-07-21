package kabam.rotmg.account.web.services
{
    import kabam.lib.tasks.BaseTask;
    import kabam.rotmg.account.core.services.PurchaseGoldTask;
    import kabam.rotmg.account.core.Account;
    import com.company.assembleegameclient.util.offer.Offer;
    import kabam.rotmg.account.core.model.OfferModel;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.util.offer.Offers;
    import com.company.assembleegameclient.util.PaymentMethod;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;

    public class WebPurchaseGoldTask extends BaseTask implements PurchaseGoldTask 
    {

        [Inject]
        public var account:Account;
        [Inject]
        public var offer:Offer;
        [Inject]
        public var offersModel:OfferModel;
        [Inject]
        public var paymentMethod:String;


        override protected function startTask():void
        {
            Parameters.data_.paymentMethod = this.paymentMethod;
            Parameters.save();
            var _local1:Offers = this.offersModel.offers;
            var _local2:PaymentMethod = PaymentMethod.getPaymentMethodByLabel(this.paymentMethod);
            var _local3:String = _local2.getURL(_local1.tok, _local1.exp, this.offer);
            navigateToURL(new URLRequest(_local3), "_blank");
            completeTask(true);
        }


    }
}

