package kabam.lib.console.signals
{
    import org.osflash.signals.Signal;
    import kabam.lib.console.vo.ConsoleAction;

    public final class RegisterConsoleActionSignal extends Signal 
    {

        public function RegisterConsoleActionSignal()
        {
            super(ConsoleAction, Signal);
        }

    }
}

