package kabam.rotmg.account.transfer.signals
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.account.transfer.model.TransferAccountData;

    public class CheckKabamAccountSignal extends Signal 
    {

        public function CheckKabamAccountSignal()
        {
            super(TransferAccountData);
        }

    }
}

