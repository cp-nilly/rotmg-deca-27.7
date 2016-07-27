package kabam.rotmg.maploading.signals
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.maploading.view.MapLoadingView;

    public class ShowLoadingViewSignal extends Signal 
    {
        public function ShowLoadingViewSignal()
        {
            super(MapLoadingView);
        }
        
        
    }
}

