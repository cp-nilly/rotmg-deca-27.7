﻿package kabam.rotmg.messaging.impl
{
    import kabam.rotmg.messaging.impl.outgoing.OutgoingMessage;
    import kabam.rotmg.messaging.impl.data.SlotObjectData;
    import flash.utils.IDataOutput;

    public class ReskinPet extends OutgoingMessage 
    {

        public var petInstanceId:int;
        public var pickedNewPetType:int;
        public var item:SlotObjectData;

        public function ReskinPet(_arg1:uint, _arg2:Function)
        {
            this.item = new SlotObjectData();
            super(_arg1, _arg2);
        }

        override public function writeToOutput(_arg1:IDataOutput):void
        {
            _arg1.writeInt(this.petInstanceId);
            _arg1.writeInt(this.pickedNewPetType);
            this.item.writeToOutput(_arg1);
        }

        override public function toString():String
        {
            return (formatToString("ENTER_ARENA", "petInstanceId", "pickedNewPetType"));
        }


    }
}

