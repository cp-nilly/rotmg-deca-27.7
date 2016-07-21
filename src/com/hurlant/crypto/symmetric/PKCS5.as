package com.hurlant.crypto.symmetric
{
    import flash.utils.ByteArray;

    public class PKCS5 implements IPad 
    {

        private var blockSize:uint;

        public function PKCS5(_arg1:uint=0)
        {
            this.blockSize = _arg1;
        }

        public function pad(_arg1:ByteArray):void
        {
            var _local2:uint = (this.blockSize - (_arg1.length % this.blockSize));
            var _local3:uint;
            while (_local3 < _local2)
            {
                _arg1[_arg1.length] = _local2;
                _local3++;
            };
        }

        public function unpad(_arg1:ByteArray):void
        {
            var _local4:uint;
            var _local2:uint = (_arg1.length % this.blockSize);
            if (_local2 != 0)
            {
                throw (new Error("PKCS#5::unpad: ByteArray.length isn't a multiple of the blockSize"));
            };
            _local2 = _arg1[(_arg1.length - 1)];
            var _local3:uint = _local2;
            while (_local3 > 0)
            {
                _local4 = _arg1[(_arg1.length - 1)];
                _arg1.length--;
                if (_local2 != _local4)
                {
                    throw (new Error((((("PKCS#5:unpad: Invalid padding value. expected [" + _local2) + "], found [") + _local4) + "]")));
                };
                _local3--;
            };
        }

        public function setBlockSize(_arg1:uint):void
        {
            this.blockSize = _arg1;
        }


    }
}

