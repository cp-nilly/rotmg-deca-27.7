package kabam.rotmg.fame.control
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.fame.model.FameVO;

    public class ShowFameViewSignal extends Signal 
    {

        public function ShowFameViewSignal()
        {
            super(FameVO);
        }

    }
}

