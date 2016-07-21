package com.hurlant.util.der
{
    import com.hurlant.math.BigInteger;
    import flash.utils.ByteArray;

    public class Integer extends BigInteger implements IAsn1Type 
    {

        private var type:uint;
        private var len:uint;

        public function Integer(_arg1:uint, _arg2:uint, _arg3:ByteArray)
        {
            this.type = _arg1;
            this.len = _arg2;
            super(_arg3);
        }

        public function getLength():uint
        {
            return (this.len);
        }

        public function getType():uint
        {
            return (this.type);
        }

        override public function toString(_arg1:Number=0):String
        {
            return ((((((((DER.indent + "Integer[") + this.type) + "][") + this.len) + "][") + super.toString(16)) + "]"));
        }

        public function toDER():ByteArray
        {
            return (null);
        }


    }
}

