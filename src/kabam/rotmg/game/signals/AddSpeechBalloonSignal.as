package kabam.rotmg.game.signals
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.game.model.AddSpeechBalloonVO;

    public class AddSpeechBalloonSignal extends Signal 
    {

        public function AddSpeechBalloonSignal()
        {
            super(AddSpeechBalloonVO);
        }

    }
}

