package com.hurlant.crypto.prng
{
    import com.hurlant.crypto.symmetric.IStreamCipher;
    import flash.utils.ByteArray;
    import com.hurlant.util.Memory;

    public class ARC4 implements IPRNG, IStreamCipher 
    {

        private const psize:uint = 0x0100;

        private var i:int = 0;
        private var j:int = 0;
        private var S:ByteArray;

        public function ARC4(_arg1:ByteArray=null)
        {
            this.S = new ByteArray();
            if (_arg1)
            {
                this.init(_arg1);
            };
        }

        public function getPoolSize():uint
        {
            return (this.psize);
        }

        public function init(_arg1:ByteArray):void
        {
            var _local2:int;
            var _local3:int;
            var _local4:int;
            _local2 = 0;
            while (_local2 < 0x0100)
            {
                this.S[_local2] = _local2;
                _local2++;
            };
            _local3 = 0;
            _local2 = 0;
            while (_local2 < 0x0100)
            {
                _local3 = (((_local3 + this.S[_local2]) + _arg1[(_local2 % _arg1.length)]) & 0xFF);
                _local4 = this.S[_local2];
                this.S[_local2] = this.S[_local3];
                this.S[_local3] = _local4;
                _local2++;
            };
            this.i = 0;
            this.j = 0;
        }

        public function next():uint
        {
            var _local1:int;
            this.i = ((this.i + 1) & 0xFF);
            this.j = ((this.j + this.S[this.i]) & 0xFF);
            _local1 = this.S[this.i];
            this.S[this.i] = this.S[this.j];
            this.S[this.j] = _local1;
            return (this.S[((_local1 + this.S[this.i]) & 0xFF)]);
        }

        public function getBlockSize():uint
        {
            return (1);
        }

        public function encrypt(_arg1:ByteArray):void
        {
            var _local2:uint;
            while (_local2 < _arg1.length)
            {
                var _local3 = _local2++;
                _arg1[_local3] = (_arg1[_local3] ^ this.next());
            };
        }

        public function decrypt(_arg1:ByteArray):void
        {
            this.encrypt(_arg1);
        }

        public function dispose():void
        {
            var _local1:uint;
            if (this.S != null)
            {
                _local1 = 0;
                while (_local1 < this.S.length)
                {
                    this.S[_local1] = (Math.random() * 0x0100);
                    _local1++;
                };
                this.S.length = 0;
                this.S = null;
            };
            this.i = 0;
            this.j = 0;
            Memory.gc();
        }

        public function toString():String
        {
            return ("rc4");
        }


    }
}

