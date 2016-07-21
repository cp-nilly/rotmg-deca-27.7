package com.hurlant.crypto.symmetric
{
    import flash.utils.ByteArray;

    public class CFB8Mode extends IVMode implements IMode 
    {

        public function CFB8Mode(_arg1:ISymmetricKey, _arg2:IPad=null)
        {
            super(_arg1, null);
        }

        public function encrypt(_arg1:ByteArray):void
        {
            var _local5:uint;
            var _local2:ByteArray = getIV4e();
            var _local3:ByteArray = new ByteArray();
            var _local4:uint;
            while (_local4 < _arg1.length)
            {
                _local3.position = 0;
                _local3.writeBytes(_local2);
                key.encrypt(_local2);
                _arg1[_local4] = (_arg1[_local4] ^ _local2[0]);
                _local5 = 0;
                while (_local5 < (blockSize - 1))
                {
                    _local2[_local5] = _local3[(_local5 + 1)];
                    _local5++;
                };
                _local2[(blockSize - 1)] = _arg1[_local4];
                _local4++;
            };
        }

        public function decrypt(_arg1:ByteArray):void
        {
            var _local5:uint;
            var _local6:uint;
            var _local2:ByteArray = getIV4d();
            var _local3:ByteArray = new ByteArray();
            var _local4:uint;
            while (_local4 < _arg1.length)
            {
                _local5 = _arg1[_local4];
                _local3.position = 0;
                _local3.writeBytes(_local2);
                key.encrypt(_local2);
                _arg1[_local4] = (_arg1[_local4] ^ _local2[0]);
                _local6 = 0;
                while (_local6 < (blockSize - 1))
                {
                    _local2[_local6] = _local3[(_local6 + 1)];
                    _local6++;
                };
                _local2[(blockSize - 1)] = _local5;
                _local4++;
            };
        }

        public function toString():String
        {
            return ((key.toString() + "-cfb8"));
        }


    }
}

