package kabam.rotmg.death.control
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.messaging.impl.incoming.Death;

    public class HandleDeathSignal extends Signal 
    {

        public function HandleDeathSignal()
        {
            super(Death);
        }

    }
}

