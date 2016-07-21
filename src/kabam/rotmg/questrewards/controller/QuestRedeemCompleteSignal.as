package kabam.rotmg.questrewards.controller
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.messaging.impl.incoming.QuestRedeemResponse;

    public class QuestRedeemCompleteSignal extends Signal 
    {

        public function QuestRedeemCompleteSignal()
        {
            super(QuestRedeemResponse);
        }

    }
}

