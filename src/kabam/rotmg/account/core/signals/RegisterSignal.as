package kabam.rotmg.account.core.signals
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.account.web.model.AccountData;

    public class RegisterSignal extends Signal 
    {

        public function RegisterSignal()
        {
            super(AccountData);
        }

    }
}

