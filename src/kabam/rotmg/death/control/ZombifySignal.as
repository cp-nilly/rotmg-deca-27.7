package kabam.rotmg.death.control
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.messaging.impl.incoming.Death;

    public class ZombifySignal extends Signal 
    {

        public function ZombifySignal()
        {
            super(Death);
        }

    }
}

