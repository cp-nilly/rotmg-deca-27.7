package kabam.rotmg.death.control
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.messaging.impl.incoming.Death;

    public class HandleNormalDeathSignal extends Signal 
    {

        public function HandleNormalDeathSignal()
        {
            super(Death);
        }

    }
}

