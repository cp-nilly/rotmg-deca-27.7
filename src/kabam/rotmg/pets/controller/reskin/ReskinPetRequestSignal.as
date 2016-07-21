package kabam.rotmg.pets.controller.reskin
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.pets.data.ReskinPetVO;

    public class ReskinPetRequestSignal extends Signal 
    {

        public function ReskinPetRequestSignal()
        {
            super(ReskinPetVO);
        }

    }
}

