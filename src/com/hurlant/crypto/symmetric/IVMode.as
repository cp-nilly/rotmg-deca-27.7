package com.hurlant.crypto.symmetric
{
    import com.hurlant.crypto.prng.Random;
    import flash.utils.ByteArray;
    import com.hurlant.util.Memory;

    public class IVMode 
    {

        protected var key:ISymmetricKey;
        protected var padding:IPad;
        protected var prng:Random;
        protected var iv:ByteArray;
        protected var lastIV:ByteArray;
        protected var blockSize:uint;

        public function IVMode(_arg1:ISymmetricKey, _arg2:IPad=null)
        {
            this.key = _arg1;
            this.blockSize = _arg1.getBlockSize();
            if (_arg2 == null)
            {
                _arg2 = new PKCS5(this.blockSize);
            }
            else
            {
                _arg2.setBlockSize(this.blockSize);
            };
            this.padding = _arg2;
            this.prng = new Random();
            this.iv = null;
            this.lastIV = new ByteArray();
        }

        public function getBlockSize():uint
        {
            return (this.key.getBlockSize());
        }

        public function dispose():void
        {
            var _local1:uint;
            if (this.iv != null)
            {
                _local1 = 0;
                while (_local1 < this.iv.length)
                {
                    this.iv[_local1] = this.prng.nextByte();
                    _local1++;
                };
                this.iv.length = 0;
                this.iv = null;
            };
            if (this.lastIV != null)
            {
                _local1 = 0;
                while (_local1 < this.iv.length)
                {
                    this.lastIV[_local1] = this.prng.nextByte();
                    _local1++;
                };
                this.lastIV.length = 0;
                this.lastIV = null;
            };
            this.key.dispose();
            this.key = null;
            this.padding = null;
            this.prng.dispose();
            this.prng = null;
            Memory.gc();
        }

        public function set IV(_arg1:ByteArray):void
        {
            this.iv = _arg1;
            this.lastIV.length = 0;
            this.lastIV.writeBytes(this.iv);
        }

        public function get IV():ByteArray
        {
            return (this.lastIV);
        }

        protected function getIV4e():ByteArray
        {
            var _local1:ByteArray = new ByteArray();
            if (this.iv)
            {
                _local1.writeBytes(this.iv);
            }
            else
            {
                this.prng.nextBytes(_local1, this.blockSize);
            };
            this.lastIV.length = 0;
            this.lastIV.writeBytes(_local1);
            return (_local1);
        }

        protected function getIV4d():ByteArray
        {
            var _local1:ByteArray = new ByteArray();
            if (this.iv)
            {
                _local1.writeBytes(this.iv);
            }
            else
            {
                throw (new Error("an IV must be set before calling decrypt()"));
            };
            return (_local1);
        }


    }
}

