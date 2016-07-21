package kabam.rotmg.pets.controller
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.pets.data.IUpgradePetRequestVO;

    public class UpgradePetSignal extends Signal 
    {

        public function UpgradePetSignal()
        {
            super(IUpgradePetRequestVO);
        }

    }
}

