package kabam.rotmg.messaging.impl.incoming.arena
{
    import kabam.rotmg.messaging.impl.incoming.IncomingMessage;
    import flash.utils.IDataInput;

    public class ArenaDeath extends IncomingMessage 
    {

        public var cost:int;

        public function ArenaDeath(_arg1:uint, _arg2:Function)
        {
            super(_arg1, _arg2);
        }

        override public function parseFromInput(_arg1:IDataInput):void
        {
            this.cost = _arg1.readInt();
        }

        override public function toString():String
        {
            return (formatToString("ARENADEATH", "cost"));
        }


    }
}

