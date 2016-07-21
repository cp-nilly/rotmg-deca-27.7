package kabam.rotmg.legends.control
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.legends.model.Timespan;

    public class RequestFameListSignal extends Signal 
    {

        public function RequestFameListSignal()
        {
            super(Timespan);
        }

    }
}

