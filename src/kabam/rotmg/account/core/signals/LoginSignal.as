package kabam.rotmg.account.core.signals
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.account.web.model.AccountData;

    public class LoginSignal extends Signal 
    {

        public function LoginSignal()
        {
            super(AccountData);
        }

    }
}

