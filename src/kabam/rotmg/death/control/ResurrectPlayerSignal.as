package kabam.rotmg.death.control
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.messaging.impl.incoming.Death;

    public class ResurrectPlayerSignal extends Signal 
    {

        public function ResurrectPlayerSignal()
        {
            super(Death);
        }

    }
}

