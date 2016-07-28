package kabam.rotmg.maploading.signals
{
    import kabam.rotmg.maploading.view.MapLoadingView;

    import org.osflash.signals.Signal;

    public class ShowLoadingViewSignal extends Signal
    {
        public function ShowLoadingViewSignal()
        {
            super(MapLoadingView);
        }
    }
}

