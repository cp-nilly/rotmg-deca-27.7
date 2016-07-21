package kabam.rotmg.ui.signals
{
    import org.osflash.signals.Signal;
    import com.company.assembleegameclient.game.GameSprite;

    public class HUDSetupStarted extends Signal 
    {

        public function HUDSetupStarted()
        {
            super(GameSprite);
        }

    }
}

