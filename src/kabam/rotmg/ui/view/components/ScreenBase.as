package kabam.rotmg.ui.view.components
{
    import flash.display.Sprite;
    import com.company.assembleegameclient.ui.SoundIcon;

    public class ScreenBase extends Sprite 
    {

        public function ScreenBase()
        {
            addChild(new MapBackground());
            addChild(new DarkLayer());
            addChild(new SoundIcon());
        }

    }
}

