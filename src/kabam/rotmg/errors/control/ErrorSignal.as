package kabam.rotmg.errors.control
{
    import org.osflash.signals.Signal;
    import flash.events.ErrorEvent;

    public class ErrorSignal extends Signal 
    {

        public function ErrorSignal()
        {
            super(ErrorEvent);
        }

    }
}

