package com.hurlant.crypto.symmetric
{
    import flash.utils.ByteArray;

    public class CTRMode extends IVMode implements IMode 
    {

        public function CTRMode(_arg1:ISymmetricKey, _arg2:IPad=null)
        {
            super(_arg1, _arg2);
        }

        public function encrypt(_arg1:ByteArray):void
        {
            padding.pad(_arg1);
            var _local2:ByteArray = getIV4e();
            this.core(_arg1, _local2);
        }

        public function decrypt(_arg1:ByteArray):void
        {
            var _local2:ByteArray = getIV4d();
            this.core(_arg1, _local2);
            padding.unpad(_arg1);
        }

        private function core(_arg1:ByteArray, _arg2:ByteArray):void
        {
            var _local6:uint;
            var _local3:ByteArray = new ByteArray();
            var _local4:ByteArray = new ByteArray();
            _local3.writeBytes(_arg2);
            var _local5:uint;
            while (_local5 < _arg1.length)
            {
                _local4.position = 0;
                _local4.writeBytes(_local3);
                key.encrypt(_local4);
                _local6 = 0;
                while (_local6 < blockSize)
                {
                    _arg1[(_local5 + _local6)] = (_arg1[(_local5 + _local6)] ^ _local4[_local6]);
                    _local6++;
                };
                _local6 = (blockSize - 1);
                while (_local6 >= 0)
                {
                    var _local7 = _local3;
                    var _local8 = _local6;
                    var _local9 = (_local7[_local8] + 1);
                    _local7[_local8] = _local9;
                    if (_local3[_local6] != 0) break;
                    _local6--;
                };
                _local5 = (_local5 + blockSize);
            };
        }

        public function toString():String
        {
            return ((key.toString() + "-ctr"));
        }


    }
}

