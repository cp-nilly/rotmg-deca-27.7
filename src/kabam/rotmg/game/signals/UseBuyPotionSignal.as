package kabam.rotmg.game.signals
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.game.model.UseBuyPotionVO;

    public class UseBuyPotionSignal extends Signal 
    {

        public function UseBuyPotionSignal()
        {
            super(UseBuyPotionVO);
        }

    }
}

