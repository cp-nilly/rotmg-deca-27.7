package kabam.rotmg.promotions.signals
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.account.core.PaymentData;

    public class MakeBeginnersPackagePaymentSignal extends Signal 
    {

        public function MakeBeginnersPackagePaymentSignal()
        {
            super(PaymentData);
        }

    }
}

