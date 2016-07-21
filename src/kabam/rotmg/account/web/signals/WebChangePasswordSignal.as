package kabam.rotmg.account.web.signals
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.account.web.model.ChangePasswordData;

    public class WebChangePasswordSignal extends Signal 
    {

        public function WebChangePasswordSignal()
        {
            super(ChangePasswordData);
        }

    }
}

