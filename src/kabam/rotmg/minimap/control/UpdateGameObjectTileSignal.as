package kabam.rotmg.minimap.control
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.ui.model.UpdateGameObjectTileVO;

    public class UpdateGameObjectTileSignal extends Signal 
    {

        public function UpdateGameObjectTileSignal()
        {
            super(UpdateGameObjectTileVO);
        }

    }
}

