package com.hurlant.crypto.symmetric
{
    import flash.utils.ByteArray;
    import com.hurlant.util.Memory;

    public class ECBMode implements IMode, ICipher 
    {

        private var key:ISymmetricKey;
        private var padding:IPad;

        public function ECBMode(_arg1:ISymmetricKey, _arg2:IPad=null)
        {
            this.key = _arg1;
            if (_arg2 == null)
            {
                _arg2 = new PKCS5(_arg1.getBlockSize());
            }
            else
            {
                _arg2.setBlockSize(_arg1.getBlockSize());
            };
            this.padding = _arg2;
        }

        public function getBlockSize():uint
        {
            return (this.key.getBlockSize());
        }

        public function encrypt(_arg1:ByteArray):void
        {
            this.padding.pad(_arg1);
            _arg1.position = 0;
            var _local2:uint = this.key.getBlockSize();
            var _local3:ByteArray = new ByteArray();
            var _local4:ByteArray = new ByteArray();
            var _local5:uint;
            while (_local5 < _arg1.length)
            {
                _local3.length = 0;
                _arg1.readBytes(_local3, 0, _local2);
                this.key.encrypt(_local3);
                _local4.writeBytes(_local3);
                _local5 = (_local5 + _local2);
            };
            _arg1.length = 0;
            _arg1.writeBytes(_local4);
        }

        public function decrypt(_arg1:ByteArray):void
        {
            _arg1.position = 0;
            var _local2:uint = this.key.getBlockSize();
            if ((_arg1.length % _local2) != 0)
            {
                throw (new Error(("ECB mode cipher length must be a multiple of blocksize " + _local2)));
            };
            var _local3:ByteArray = new ByteArray();
            var _local4:ByteArray = new ByteArray();
            var _local5:uint;
            while (_local5 < _arg1.length)
            {
                _local3.length = 0;
                _arg1.readBytes(_local3, 0, _local2);
                this.key.decrypt(_local3);
                _local4.writeBytes(_local3);
                _local5 = (_local5 + _local2);
            };
            this.padding.unpad(_local4);
            _arg1.length = 0;
            _arg1.writeBytes(_local4);
        }

        public function dispose():void
        {
            this.key.dispose();
            this.key = null;
            this.padding = null;
            Memory.gc();
        }

        public function toString():String
        {
            return ((this.key.toString() + "-ecb"));
        }


    }
}

