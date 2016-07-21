package kabam.rotmg.ui.signals
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.ui.model.Key;

    public class ShowKeySignal extends Signal 
    {

        public static var instance:ShowKeySignal;

        public function ShowKeySignal()
        {
            super(Key);
            instance = this;
        }

    }
}

