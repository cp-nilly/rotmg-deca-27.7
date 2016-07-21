package kabam.rotmg.friends.controller
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.friends.model.FriendRequestVO;

    public class FriendActionSignal extends Signal 
    {

        public function FriendActionSignal()
        {
            super(FriendRequestVO);
        }

    }
}

