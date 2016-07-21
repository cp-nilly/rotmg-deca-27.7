package kabam.rotmg.account.core.signals
{
    import org.osflash.signals.Signal;
    import com.company.assembleegameclient.util.offer.Offer;

    public class PurchaseGoldSignal extends Signal 
    {

        public function PurchaseGoldSignal()
        {
            super(Offer, String);
        }

    }
}

