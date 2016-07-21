package com.hurlant.crypto.hash
{
    import flash.utils.ByteArray;

    public class HMAC implements IHMAC 
    {

        private var hash:IHash;
        private var bits:uint;

        public function HMAC(_arg1:IHash, _arg2:uint=0)
        {
            this.hash = _arg1;
            this.bits = _arg2;
        }

        public function getHashSize():uint
        {
            if (this.bits != 0)
            {
                return ((this.bits / 8));
            };
            return (this.hash.getHashSize());
        }

        public function compute(_arg1:ByteArray, _arg2:ByteArray):ByteArray
        {
            var _local3:ByteArray;
            if (_arg1.length > this.hash.getInputSize())
            {
                _local3 = this.hash.hash(_arg1);
            }
            else
            {
                _local3 = new ByteArray();
                _local3.writeBytes(_arg1);
            };
            while (_local3.length < this.hash.getInputSize())
            {
                _local3[_local3.length] = 0;
            };
            var _local4:ByteArray = new ByteArray();
            var _local5:ByteArray = new ByteArray();
            var _local6:uint;
            while (_local6 < _local3.length)
            {
                _local4[_local6] = (_local3[_local6] ^ 54);
                _local5[_local6] = (_local3[_local6] ^ 92);
                _local6++;
            };
            _local4.position = _local3.length;
            _local4.writeBytes(_arg2);
            var _local7:ByteArray = this.hash.hash(_local4);
            _local5.position = _local3.length;
            _local5.writeBytes(_local7);
            var _local8:ByteArray = this.hash.hash(_local5);
            if ((((this.bits > 0)) && ((this.bits < (8 * _local8.length)))))
            {
                _local8.length = (this.bits / 8);
            };
            return (_local8);
        }

        public function dispose():void
        {
            this.hash = null;
            this.bits = 0;
        }

        public function toString():String
        {
            return ((("hmac-" + (((this.bits > 0)) ? (this.bits + "-") : "")) + this.hash.toString()));
        }


    }
}

