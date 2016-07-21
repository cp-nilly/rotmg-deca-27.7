package kabam.rotmg.questrewards.controller
{
    import org.osflash.signals.Signal;
    import kabam.rotmg.messaging.impl.incoming.QuestFetchResponse;

    public class QuestFetchCompleteSignal extends Signal 
    {

        public function QuestFetchCompleteSignal()
        {
            super(QuestFetchResponse);
        }

    }
}

