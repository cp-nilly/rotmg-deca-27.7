package kabam.rotmg.game.signals
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.game.model.GameInitData;

    public class PlayGameSignal extends Signal 
    {

        public function PlayGameSignal()
        {
            super(GameInitData);
        }

    }
}

