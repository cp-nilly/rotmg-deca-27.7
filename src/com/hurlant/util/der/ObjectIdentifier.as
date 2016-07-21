package com.hurlant.util.der
{
    import flash.net.registerClassAlias;
    import flash.utils.ByteArray;

    public class ObjectIdentifier implements IAsn1Type 
    {

        private var type:uint;
        private var len:uint;
        private var oid:Array;

        {
            registerClassAlias("com.hurlant.util.der.ObjectIdentifier", ObjectIdentifier);
        }

        public function ObjectIdentifier(_arg1:uint=0, _arg2:uint=0, _arg3:*=null)
        {
            this.type = _arg1;
            this.len = _arg2;
            if ((_arg3 is ByteArray))
            {
                this.parse((_arg3 as ByteArray));
            }
            else
            {
                if ((_arg3 is String))
                {
                    this.generate((_arg3 as String));
                }
                else
                {
                    throw (new Error("Invalid call to new ObjectIdentifier"));
                };
            };
        }

        private function generate(_arg1:String):void
        {
            this.oid = _arg1.split(".");
        }

        private function parse(_arg1:ByteArray):void
        {
            var _local5:Boolean;
            var _local2:uint = _arg1.readUnsignedByte();
            var _local3:Array = [];
            _local3.push(uint((_local2 / 40)));
            _local3.push(uint((_local2 % 40)));
            var _local4:uint;
            while (_arg1.bytesAvailable > 0)
            {
                _local2 = _arg1.readUnsignedByte();
                _local5 = ((_local2 & 128) == 0);
                _local2 = (_local2 & 127);
                _local4 = ((_local4 * 128) + _local2);
                if (_local5)
                {
                    _local3.push(_local4);
                    _local4 = 0;
                };
            };
            this.oid = _local3;
        }

        public function getLength():uint
        {
            return (this.len);
        }

        public function getType():uint
        {
            return (this.type);
        }

        public function toDER():ByteArray
        {
            var _local4:int;
            var _local1:Array = [];
            _local1[0] = ((this.oid[0] * 40) + this.oid[1]);
            var _local2:int = 2;
            while (_local2 < this.oid.length)
            {
                _local4 = parseInt(this.oid[_local2]);
                if (_local4 < 128)
                {
                    _local1.push(_local4);
                }
                else
                {
                    if (_local4 < (128 * 128))
                    {
                        _local1.push(((_local4 >> 7) | 128));
                        _local1.push((_local4 & 127));
                    }
                    else
                    {
                        if (_local4 < ((128 * 128) * 128))
                        {
                            _local1.push(((_local4 >> 14) | 128));
                            _local1.push((((_local4 >> 7) & 127) | 128));
                            _local1.push((_local4 & 127));
                        }
                        else
                        {
                            if (_local4 < (((128 * 128) * 128) * 128))
                            {
                                _local1.push(((_local4 >> 21) | 128));
                                _local1.push((((_local4 >> 14) & 127) | 128));
                                _local1.push((((_local4 >> 7) & 127) | 128));
                                _local1.push((_local4 & 127));
                            }
                            else
                            {
                                throw (new Error("OID element bigger than we thought. :("));
                            };
                        };
                    };
                };
                _local2++;
            };
            this.len = _local1.length;
            if (this.type == 0)
            {
                this.type = 6;
            };
            _local1.unshift(this.len);
            _local1.unshift(this.type);
            var _local3:ByteArray = new ByteArray();
            _local2 = 0;
            while (_local2 < _local1.length)
            {
                _local3[_local2] = _local1[_local2];
                _local2++;
            };
            return (_local3);
        }

        public function toString():String
        {
            return ((DER.indent + this.oid.join(".")));
        }

        public function dump():String
        {
            return ((((((("OID[" + this.type) + "][") + this.len) + "][") + this.toString()) + "]"));
        }


    }
}

