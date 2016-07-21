package kabam.rotmg.pets.controller
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.messaging.impl.EvolvePetInfo;

    public class EvolvePetSignal extends Signal 
    {

        public function EvolvePetSignal()
        {
            super(EvolvePetInfo);
        }

    }
}

