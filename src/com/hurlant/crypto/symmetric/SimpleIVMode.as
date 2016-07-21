package com.hurlant.crypto.symmetric
{
    import com.hurlant.util.Memory;
    import flash.utils.ByteArray;

    public class SimpleIVMode implements IMode, ICipher 
    {

        protected var mode:IVMode;
        protected var cipher:ICipher;

        public function SimpleIVMode(_arg1:IVMode)
        {
            this.mode = _arg1;
            this.cipher = (_arg1 as ICipher);
        }

        public function getBlockSize():uint
        {
            return (this.mode.getBlockSize());
        }

        public function dispose():void
        {
            this.mode.dispose();
            this.mode = null;
            this.cipher = null;
            Memory.gc();
        }

        public function encrypt(_arg1:ByteArray):void
        {
            this.cipher.encrypt(_arg1);
            var _local2:ByteArray = new ByteArray();
            _local2.writeBytes(this.mode.IV);
            _local2.writeBytes(_arg1);
            _arg1.position = 0;
            _arg1.writeBytes(_local2);
        }

        public function decrypt(_arg1:ByteArray):void
        {
            var _local2:ByteArray = new ByteArray();
            _local2.writeBytes(_arg1, 0, this.getBlockSize());
            this.mode.IV = _local2;
            _local2 = new ByteArray();
            _local2.writeBytes(_arg1, this.getBlockSize());
            this.cipher.decrypt(_local2);
            _arg1.length = 0;
            _arg1.writeBytes(_local2);
        }

        public function toString():String
        {
            return (("simple-" + this.cipher.toString()));
        }


    }
}

