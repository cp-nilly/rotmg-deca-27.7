package com.hurlant.crypto.prng
{
    import flash.utils.ByteArray;
    import flash.text.Font;
    import flash.system.System;
    import flash.system.Capabilities;
    import flash.utils.getTimer;
    import com.hurlant.util.Memory;

    public class Random 
    {

        private var state:IPRNG;
        private var ready:Boolean = false;
        private var pool:ByteArray;
        private var psize:int;
        private var pptr:int;
        private var seeded:Boolean = false;

        public function Random(_arg1:Class=null)
        {
            var _local2:uint;
            super();
            if (_arg1 == null)
            {
                _arg1 = ARC4;
            };
            this.state = (new (_arg1)() as IPRNG);
            this.psize = this.state.getPoolSize();
            this.pool = new ByteArray();
            this.pptr = 0;
            while (this.pptr < this.psize)
            {
                _local2 = (65536 * Math.random());
                var _local3 = this.pptr++;
                this.pool[_local3] = (_local2 >>> 8);
                var _local4 = this.pptr++;
                this.pool[_local4] = (_local2 & 0xFF);
            };
            this.pptr = 0;
            this.seed();
        }

        public function seed(_arg1:int=0):void
        {
            if (_arg1 == 0)
            {
                _arg1 = new Date().getTime();
            };
            var _local2 = this.pptr++;
            this.pool[_local2] = (this.pool[_local2] ^ (_arg1 & 0xFF));
            var _local3 = this.pptr++;
            this.pool[_local3] = (this.pool[_local3] ^ ((_arg1 >> 8) & 0xFF));
            var _local4 = this.pptr++;
            this.pool[_local4] = (this.pool[_local4] ^ ((_arg1 >> 16) & 0xFF));
            var _local5 = this.pptr++;
            this.pool[_local5] = (this.pool[_local5] ^ ((_arg1 >> 24) & 0xFF));
            this.pptr = (this.pptr % this.psize);
            this.seeded = true;
        }

        public function autoSeed():void
        {
            var _local3:Font;
            var _local1:ByteArray = new ByteArray();
            _local1.writeUnsignedInt(System.totalMemory);
            _local1.writeUTF(Capabilities.serverString);
            _local1.writeUnsignedInt(getTimer());
            _local1.writeUnsignedInt(new Date().getTime());
            var _local2:Array = Font.enumerateFonts(true);
            for each (_local3 in _local2)
            {
                _local1.writeUTF(_local3.fontName);
                _local1.writeUTF(_local3.fontStyle);
                _local1.writeUTF(_local3.fontType);
            };
            _local1.position = 0;
            while (_local1.bytesAvailable >= 4)
            {
                this.seed(_local1.readUnsignedInt());
            };
        }

        public function nextBytes(_arg1:ByteArray, _arg2:int):void
        {
            while (_arg2--)
            {
                _arg1.writeByte(this.nextByte());
            };
        }

        public function nextByte():int
        {
            if (!this.ready)
            {
                if (!this.seeded)
                {
                    this.autoSeed();
                };
                this.state.init(this.pool);
                this.pool.length = 0;
                this.pptr = 0;
                this.ready = true;
            };
            return (this.state.next());
        }

        public function dispose():void
        {
            var _local1:uint;
            while (_local1 < this.pool.length)
            {
                this.pool[_local1] = (Math.random() * 0x0100);
                _local1++;
            };
            this.pool.length = 0;
            this.pool = null;
            this.state.dispose();
            this.state = null;
            this.psize = 0;
            this.pptr = 0;
            Memory.gc();
        }

        public function toString():String
        {
            return (("random-" + this.state.toString()));
        }


    }
}

