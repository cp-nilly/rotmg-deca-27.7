package kabam.rotmg.account.core.signals
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.account.web.model.AccountData;

    public class RegisterAccountSignal extends Signal 
    {

        public function RegisterAccountSignal()
        {
            super(AccountData);
        }

    }
}

