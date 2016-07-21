package kabam.rotmg.messaging.impl.incoming
{
    import kabam.lib.net.impl.Message;
    import flash.utils.IDataInput;

    public class NewAbilityMessage extends Message 
    {

        public var type:int;

        public function NewAbilityMessage(_arg1:uint, _arg2:Function=null)
        {
            super(_arg1, _arg2);
        }

        override public function parseFromInput(_arg1:IDataInput):void
        {
            this.type = _arg1.readInt();
        }


    }
}

