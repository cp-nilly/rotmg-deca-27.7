package kabam.rotmg.pets.view.dialogs
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.pets.data.PetVO;

    public class PetVOSignal extends Signal 
    {

        public function PetVOSignal()
        {
            super(PetVO);
        }

    }
}

