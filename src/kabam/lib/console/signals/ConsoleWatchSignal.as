package kabam.lib.console.signals
{
    import org.osflash.signals.Signal;
    import kabam.lib.console.model.Watch;

    public class ConsoleWatchSignal extends Signal 
    {

        public function ConsoleWatchSignal()
        {
            super(Watch);
        }

    }
}

