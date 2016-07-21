﻿package kabam.rotmg.messaging.impl.incoming.pets
{
    import kabam.rotmg.messaging.impl.incoming.IncomingMessage;
    import flash.utils.IDataInput;

    public class DeletePetMessage extends IncomingMessage 
    {

        public var petID:int;

        public function DeletePetMessage(_arg1:uint, _arg2:Function)
        {
            super(_arg1, _arg2);
        }

        override public function parseFromInput(_arg1:IDataInput):void
        {
            this.petID = _arg1.readInt();
        }


    }
}

