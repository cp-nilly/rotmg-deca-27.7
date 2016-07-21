package com.hurlant.crypto.symmetric
{
    import flash.utils.ByteArray;

    public class CBCMode extends IVMode implements IMode 
    {

        public function CBCMode(_arg1:ISymmetricKey, _arg2:IPad=null)
        {
            super(_arg1, _arg2);
        }

        public function encrypt(_arg1:ByteArray):void
        {
            var _local4:uint;
            padding.pad(_arg1);
            var _local2:ByteArray = getIV4e();
            var _local3:uint;
            while (_local3 < _arg1.length)
            {
                _local4 = 0;
                while (_local4 < blockSize)
                {
                    _arg1[(_local3 + _local4)] = (_arg1[(_local3 + _local4)] ^ _local2[_local4]);
                    _local4++;
                };
                key.encrypt(_arg1, _local3);
                _local2.position = 0;
                _local2.writeBytes(_arg1, _local3, blockSize);
                _local3 = (_local3 + blockSize);
            };
        }

        public function decrypt(_arg1:ByteArray):void
        {
            var _local5:uint;
            var _local2:ByteArray = getIV4d();
            var _local3:ByteArray = new ByteArray();
            var _local4:uint;
            while (_local4 < _arg1.length)
            {
                _local3.position = 0;
                _local3.writeBytes(_arg1, _local4, blockSize);
                key.decrypt(_arg1, _local4);
                _local5 = 0;
                while (_local5 < blockSize)
                {
                    _arg1[(_local4 + _local5)] = (_arg1[(_local4 + _local5)] ^ _local2[_local5]);
                    _local5++;
                };
                _local2.position = 0;
                _local2.writeBytes(_local3, 0, blockSize);
                _local4 = (_local4 + blockSize);
            };
            padding.unpad(_arg1);
        }

        public function toString():String
        {
            return ((key.toString() + "-cbc"));
        }


    }
}

