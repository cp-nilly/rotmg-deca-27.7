package com.hurlant.math
{
    import flash.utils.ByteArray;
    import com.hurlant.util.Hex;
    import com.hurlant.crypto.prng.Random;
    import com.hurlant.util.Memory;

	use namespace bi_internal;
	
    public class BigInteger 
    {

        public static const DB:int = 30;
        public static const DV:int = (1 << DB);
        public static const DM:int = (DV - 1);
        public static const BI_FP:int = 52;
        public static const FV:Number = Math.pow(2, BI_FP);
        public static const F1:int = (BI_FP - DB);//22
        public static const F2:int = ((2 * DB) - BI_FP);//8
        public static const ZERO:BigInteger = nbv(0);
        public static const ONE:BigInteger = nbv(1);
        public static const lowprimes:Array = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 0x0101, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509];
        public static const lplim:int = ((1 << 26) / lowprimes[(lowprimes.length - 1)]);

        public var t:int;
        bi_internal var s:int;
        bi_internal var a:Array;

        public function BigInteger(_arg1:*=null, _arg2:int=0, _arg3:Boolean=false)
        {
            var _local4:ByteArray;
            var _local5:int;
            super();
            this.a = new Array();
            if ((_arg1 is String))
            {
                if (((_arg2) && (!((_arg2 == 16)))))
                {
                    throw (new Error("BigInteger construction with radix!=16 is not supported."));
                };
                _arg1 = Hex.toArray(_arg1);
                _arg2 = 0;
            };
            if ((_arg1 is ByteArray))
            {
                _local4 = (_arg1 as ByteArray);
                _local5 = ((_arg2) || ((_local4.length - _local4.position)));
                this.fromArray(_local4, _local5, _arg3);
            };
        }

        public static function nbv(_arg1:int):BigInteger
        {
            var _local2:BigInteger = new (BigInteger)();
            _local2.fromInt(_arg1);
            return (_local2);
        }


        public function dispose():void
        {
            var _local1:Random = new Random();
            var _local2:uint;
            while (_local2 < this.a.length)
            {
                this.a[_local2] = _local1.nextByte();
                delete this.a[_local2];
                _local2++;
            };
            this.a = null;
            this.t = 0;
            this.s = 0;
            Memory.gc();
        }

        public function toString(_arg1:Number=16):String
        {
            var _local2:int;
            if (this.s < 0)
            {
                return (("-" + this.negate().toString(_arg1)));
            };
            switch (_arg1)
            {
                case 2:
                    _local2 = 1;
                    break;
                case 4:
                    _local2 = 2;
                    break;
                case 8:
                    _local2 = 3;
                    break;
                case 16:
                    _local2 = 4;
                    break;
                case 32:
                    _local2 = 5;
                    break;
            };
            var _local3:int = ((1 << _local2) - 1);
            var _local4:int;
            var _local5:Boolean;
            var _local6 = "";
            var _local7:int = this.t;
            var _local8:int = (DB - ((_local7 * DB) % _local2));
            if (_local7-- > 0)
            {
                if ((((_local8 < DB)) && (((_local4 = (this.a[_local7] >> _local8)) > 0))))
                {
                    _local5 = true;
                    _local6 = _local4.toString(36);
                };
                while (_local7 >= 0)
                {
                    if (_local8 < _local2)
                    {
                        _local4 = ((this.a[_local7] & ((1 << _local8) - 1)) << (_local2 - _local8));
                        var _temp1 = _local4;
                        _local8 = (_local8 + (DB - _local2));
                        _local4 = (_temp1 | (this.a[--_local7] >> _local8));
                    }
                    else
                    {
                        _local8 = (_local8 - _local2);
                        _local4 = ((this.a[_local7] >> _local8) & _local3);
                        if (_local8 <= 0)
                        {
                            _local8 = (_local8 + DB);
                            _local7--;
                        };
                    };
                    if (_local4 > 0)
                    {
                        _local5 = true;
                    };
                    if (_local5)
                    {
                        _local6 = (_local6 + _local4.toString(36));
                    };
                };
            };
            return (((_local5) ? _local6 : "0"));
        }

        public function toArray(_arg1:ByteArray):uint
        {
            var _local2:int = 8;
            var _local3:int = ((1 << 8) - 1);
            var _local4:int;
            var _local5:int = this.t;
            var _local6:int = (DB - ((_local5 * DB) % _local2));
            var _local7:Boolean;
            var _local8:int;
            if (_local5-- > 0)
            {
                if ((((_local6 < DB)) && (((_local4 = (this.a[_local5] >> _local6)) > 0))))
                {
                    _local7 = true;
                    _arg1.writeByte(_local4);
                    _local8++;
                };
                while (_local5 >= 0)
                {
                    if (_local6 < _local2)
                    {
                        _local4 = ((this.a[_local5] & ((1 << _local6) - 1)) << (_local2 - _local6));
                        var _temp1 = _local4;
                        _local6 = (_local6 + (DB - _local2));
                        _local4 = (_temp1 | (this.a[--_local5] >> _local6));
                    }
                    else
                    {
                        _local6 = (_local6 - _local2);
                        _local4 = ((this.a[_local5] >> _local6) & _local3);
                        if (_local6 <= 0)
                        {
                            _local6 = (_local6 + DB);
                            _local5--;
                        };
                    };
                    if (_local4 > 0)
                    {
                        _local7 = true;
                    };
                    if (_local7)
                    {
                        _arg1.writeByte(_local4);
                        _local8++;
                    };
                };
            };
            return (_local8);
        }

        public function valueOf():Number
        {
            if (this.s == -1)
            {
                return (-(this.negate().valueOf()));
            };
            var _local1:Number = 1;
            var _local2:Number = 0;
            var _local3:uint;
            while (_local3 < this.t)
            {
                _local2 = (_local2 + (this.a[_local3] * _local1));
                _local1 = (_local1 * DV);
                _local3++;
            };
            return (_local2);
        }

        public function negate():BigInteger
        {
            var _local1:BigInteger = this.nbi();
            ZERO.subTo(this, _local1);
            return (_local1);
        }

        public function abs():BigInteger
        {
            return ((((this.s)<0) ? this.negate() : this));
        }

        public function compareTo(_arg1:BigInteger):int
        {
            var _local2:int = (this.s - _arg1.s);
            if (_local2 != 0)
            {
                return (_local2);
            };
            var _local3:int = this.t;
            _local2 = (_local3 - _arg1.t);
            if (_local2 != 0)
            {
                return (_local2);
            };
            while (--_local3 >= 0)
            {
                _local2 = (this.a[_local3] - _arg1.a[_local3]);
                if (_local2 != 0)
                {
                    return (_local2);
                };
            };
            return (0);
        }

        bi_internal function nbits(_arg1:int):int
        {
            var _local3:int;
            var _local2:int = 1;
            _local3 = (_arg1 >>> 16);
            if (_local3 != 0)
            {
                _arg1 = _local3;
                _local2 = (_local2 + 16);
            };
            _local3 = (_arg1 >> 8);
            if (_local3 != 0)
            {
                _arg1 = _local3;
                _local2 = (_local2 + 8);
            };
            _local3 = (_arg1 >> 4);
            if (_local3 != 0)
            {
                _arg1 = _local3;
                _local2 = (_local2 + 4);
            };
            _local3 = (_arg1 >> 2);
            if (_local3 != 0)
            {
                _arg1 = _local3;
                _local2 = (_local2 + 2);
            };
            _local3 = (_arg1 >> 1);
            if (_local3 != 0)
            {
                _arg1 = _local3;
                _local2 = (_local2 + 1);
            };
            return (_local2);
        }

        public function bitLength():int
        {
            if (this.t <= 0)
            {
                return (0);
            };
            return (((DB * (this.t - 1)) + this.nbits((this.a[(this.t - 1)] ^ (this.s & DM)))));
        }

        public function mod(_arg1:BigInteger):BigInteger
        {
            var _local2:BigInteger = this.nbi();
            this.abs().divRemTo(_arg1, null, _local2);
            if ((((this.s < 0)) && ((_local2.compareTo(ZERO) > 0))))
            {
                _arg1.subTo(_local2, _local2);
            };
            return (_local2);
        }

        public function modPowInt(_arg1:int, _arg2:BigInteger):BigInteger
        {
            var _local3:IReduction;
            if ((((_arg1 < 0x0100)) || (_arg2.isEven())))
            {
                _local3 = new ClassicReduction(_arg2);
            }
            else
            {
                _local3 = new MontgomeryReduction(_arg2);
            };
            return (this.exp(_arg1, _local3));
        }

        bi_internal function copyTo(_arg1:BigInteger):void
        {
            var _local2:int = (this.t - 1);
            while (_local2 >= 0)
            {
                _arg1.a[_local2] = this.a[_local2];
                _local2--;
            };
            _arg1.t = this.t;
            _arg1.s = this.s;
        }

        bi_internal function fromInt(_arg1:int):void
        {
            this.t = 1;
            this.s = (((_arg1)<0) ? -1 : 0);
            if (_arg1 > 0)
            {
                this.a[0] = _arg1;
            }
            else
            {
                if (_arg1 < -1)
                {
                    this.a[0] = (_arg1 + DV);
                }
                else
                {
                    this.t = 0;
                };
            };
        }

        bi_internal function fromArray(_arg1:ByteArray, _arg2:int, _arg3:Boolean=false):void
        {
            var _local8:int;
            var _local4:int = _arg1.position;
            var _local5:int = (_local4 + _arg2);
            var _local6:int;
            var _local7:int = 8;
            this.t = 0;
            this.s = 0;
            while (--_local5 >= _local4)
            {
                _local8 = (((_local5 < _arg1.length)) ? _arg1[_local5] : 0);
                if (_local6 == 0)
                {
                    var _local9 = this.t++;
                    this.a[_local9] = _local8;
                }
                else
                {
                    if ((_local6 + _local7) > DB)
                    {
                        this.a[(this.t - 1)] = (this.a[(this.t - 1)] | ((_local8 & ((1 << (DB - _local6)) - 1)) << _local6));
                        _local9 = this.t++;
                        this.a[_local9] = (_local8 >> (DB - _local6));
                    }
                    else
                    {
                        this.a[(this.t - 1)] = (this.a[(this.t - 1)] | (_local8 << _local6));
                    };
                };
                _local6 = (_local6 + _local7);
                if (_local6 >= DB)
                {
                    _local6 = (_local6 - DB);
                };
            };
            if (((!(_arg3)) && (((_arg1[0] & 128) == 128))))
            {
                this.s = -1;
                if (_local6 > 0)
                {
                    this.a[(this.t - 1)] = (this.a[(this.t - 1)] | (((1 << (DB - _local6)) - 1) << _local6));
                };
            };
            this.clamp();
            _arg1.position = Math.min((_local4 + _arg2), _arg1.length);
        }

        bi_internal function clamp():void
        {
            var _local1 = (this.s & DM);
            while ((((this.t > 0)) && ((this.a[(this.t - 1)] == _local1))))
            {
                this.t--;
            };
        }

        bi_internal function dlShiftTo(_arg1:int, _arg2:BigInteger):void
        {
            var _local3:int;
            _local3 = (this.t - 1);
            while (_local3 >= 0)
            {
                _arg2.a[(_local3 + _arg1)] = this.a[_local3];
                _local3--;
            };
            _local3 = (_arg1 - 1);
            while (_local3 >= 0)
            {
                _arg2.a[_local3] = 0;
                _local3--;
            };
            _arg2.t = (this.t + _arg1);
            _arg2.s = this.s;
        }

        bi_internal function drShiftTo(_arg1:int, _arg2:BigInteger):void
        {
            var _local3:int;
            _local3 = _arg1;
            while (_local3 < this.t)
            {
                _arg2.a[(_local3 - _arg1)] = this.a[_local3];
                _local3++;
            };
            _arg2.t = Math.max((this.t - _arg1), 0);
            _arg2.s = this.s;
        }

        bi_internal function lShiftTo(_arg1:int, _arg2:BigInteger):void
        {
            var _local8:int;
            var _local3:int = (_arg1 % DB);
            var _local4:int = (DB - _local3);
            var _local5:int = ((1 << _local4) - 1);
            var _local6:int = (_arg1 / DB);
            var _local7 = ((this.s << _local3) & DM);
            _local8 = (this.t - 1);
            while (_local8 >= 0)
            {
                _arg2.a[((_local8 + _local6) + 1)] = ((this.a[_local8] >> _local4) | _local7);
                _local7 = ((this.a[_local8] & _local5) << _local3);
                _local8--;
            };
            _local8 = (_local6 - 1);
            while (_local8 >= 0)
            {
                _arg2.a[_local8] = 0;
                _local8--;
            };
            _arg2.a[_local6] = _local7;
            _arg2.t = ((this.t + _local6) + 1);
            _arg2.s = this.s;
            _arg2.clamp();
        }

        bi_internal function rShiftTo(_arg1:int, _arg2:BigInteger):void
        {
            var _local7:int;
            _arg2.s = this.s;
            var _local3:int = (_arg1 / DB);
            if (_local3 >= this.t)
            {
                _arg2.t = 0;
                return;
            };
            var _local4:int = (_arg1 % DB);
            var _local5:int = (DB - _local4);
            var _local6:int = ((1 << _local4) - 1);
            _arg2.a[0] = (this.a[_local3] >> _local4);
            _local7 = (_local3 + 1);
            while (_local7 < this.t)
            {
                _arg2.a[((_local7 - _local3) - 1)] = (_arg2.a[((_local7 - _local3) - 1)] | ((this.a[_local7] & _local6) << _local5));
                _arg2.a[(_local7 - _local3)] = (this.a[_local7] >> _local4);
                _local7++;
            };
            if (_local4 > 0)
            {
                _arg2.a[((this.t - _local3) - 1)] = (_arg2.a[((this.t - _local3) - 1)] | ((this.s & _local6) << _local5));
            };
            _arg2.t = (this.t - _local3);
            _arg2.clamp();
        }

        bi_internal function subTo(_arg1:BigInteger, _arg2:BigInteger):void
        {
            var _local3:int;
            var _local4:int;
            var _local5:int = Math.min(_arg1.t, this.t);
            while (_local3 < _local5)
            {
                _local4 = (_local4 + (this.a[_local3] - _arg1.a[_local3]));
                var _local6 = _local3++;
                _arg2.a[_local6] = (_local4 & DM);
                _local4 = (_local4 >> DB);
            };
            if (_arg1.t < this.t)
            {
                _local4 = (_local4 - _arg1.s);
                while (_local3 < this.t)
                {
                    _local4 = (_local4 + this.a[_local3]);
                    _local6 = _local3++;
                    _arg2.a[_local6] = (_local4 & DM);
                    _local4 = (_local4 >> DB);
                };
                _local4 = (_local4 + this.s);
            }
            else
            {
                _local4 = (_local4 + this.s);
                while (_local3 < _arg1.t)
                {
                    _local4 = (_local4 - _arg1.a[_local3]);
                    _local6 = _local3++;
                    _arg2.a[_local6] = (_local4 & DM);
                    _local4 = (_local4 >> DB);
                };
                _local4 = (_local4 - _arg1.s);
            };
            _arg2.s = (((_local4)<0) ? -1 : 0);
            if (_local4 < -1)
            {
                _local6 = _local3++;
                _arg2.a[_local6] = (DV + _local4);
            }
            else
            {
                if (_local4 > 0)
                {
                    _local6 = _local3++;
                    _arg2.a[_local6] = _local4;
                };
            };
            _arg2.t = _local3;
            _arg2.clamp();
        }

        bi_internal function am(_arg1:int, _arg2:int, _arg3:BigInteger, _arg4:int, _arg5:int, _arg6:int):int
        {
            var _local9:int;
            var _local10:int;
            var _local11:int;
            var _local7 = (_arg2 & 32767);
            var _local8 = (_arg2 >> 15);
            while (--_arg6 >= 0)
            {
                _local9 = (this.a[_arg1] & 32767);
                _local10 = (this.a[_arg1++] >> 15);
                _local11 = ((_local8 * _local9) + (_local10 * _local7));
                _local9 = ((((_local7 * _local9) + ((_local11 & 32767) << 15)) + _arg3.a[_arg4]) + (_arg5 & 1073741823));
                _arg5 = ((((_local9 >>> 30) + (_local11 >>> 15)) + (_local8 * _local10)) + (_arg5 >>> 30));
                var _local12 = _arg4++;
                _arg3.a[_local12] = (_local9 & 1073741823);
            };
            return (_arg5);
        }

        bi_internal function multiplyTo(_arg1:BigInteger, _arg2:BigInteger):void
        {
            var _local3:BigInteger = this.abs();
            var _local4:BigInteger = _arg1.abs();
            var _local5:int = _local3.t;
            _arg2.t = (_local5 + _local4.t);
            while (--_local5 >= 0)
            {
                _arg2.a[_local5] = 0;
            };
            _local5 = 0;
            while (_local5 < _local4.t)
            {
                _arg2.a[(_local5 + _local3.t)] = _local3.am(0, _local4.a[_local5], _arg2, _local5, 0, _local3.t);
                _local5++;
            };
            _arg2.s = 0;
            _arg2.clamp();
            if (this.s != _arg1.s)
            {
                ZERO.subTo(_arg2, _arg2);
            };
        }

        bi_internal function squareTo(_arg1:BigInteger):void
        {
            var _local4:int;
            var _local2:BigInteger = this.abs();
            var _local3:int = (_arg1.t = (2 * _local2.t));
            while (--_local3 >= 0)
            {
                _arg1.a[_local3] = 0;
            };
            _local3 = 0;
            while (_local3 < (_local2.t - 1))
            {
                _local4 = _local2.am(_local3, _local2.a[_local3], _arg1, (2 * _local3), 0, 1);
                if ((_arg1.a[(_local3 + _local2.t)] = (_arg1.a[(_local3 + _local2.t)] + _local2.am((_local3 + 1), (2 * _local2.a[_local3]), _arg1, ((2 * _local3) + 1), _local4, ((_local2.t - _local3) - 1)))) >= DV)
                {
                    _arg1.a[(_local3 + _local2.t)] = (_arg1.a[(_local3 + _local2.t)] - DV);
                    _arg1.a[((_local3 + _local2.t) + 1)] = 1;
                };
                _local3++;
            };
            if (_arg1.t > 0)
            {
                _arg1.a[(_arg1.t - 1)] = (_arg1.a[(_arg1.t - 1)] + _local2.am(_local3, _local2.a[_local3], _arg1, (2 * _local3), 0, 1));
            };
            _arg1.s = 0;
            _arg1.clamp();
        }

        bi_internal function divRemTo(m:BigInteger, q:BigInteger=null, r:BigInteger=null):void
        {
            var qd:int;
            var pm:BigInteger = m.abs();
            if (pm.t <= 0)
            {
                return;
            };
            var pt:BigInteger = this.abs();
            if (pt.t < pm.t)
            {
                if (q != null)
                {
                    q.fromInt(0);
                };
                if (r != null)
                {
                    this.copyTo(r);
                };
                return;
            };
            if (r == null)
            {
                r = this.nbi();
            };
            var y:BigInteger = this.nbi();
            var ts:int = this.s;
            var ms:int = m.s;
            var nsh:int = (DB - this.nbits(pm.a[(pm.t - 1)]));
            if (nsh > 0)
            {
                pm.lShiftTo(nsh, y);
                pt.lShiftTo(nsh, r);
            }
            else
            {
                pm.copyTo(y);
                pt.copyTo(r);
            };
            var ys:int = y.t;
            var y0:int = y.a[(ys - 1)];
            if (y0 == 0)
            {
                return;
            };
            var yt:Number = ((y0 * (1 << F1)) + (((ys)>1) ? (y.a[(ys - 2)] >> F2) : 0));
            var d1:Number = (FV / yt);
            var d2:Number = ((1 << F1) / yt);
            var e:Number = (1 << F2);
            var i:int = r.t;
            var j:int = (i - ys);
            var t:BigInteger = (((q)==null) ? this.nbi() : q);
            y.dlShiftTo(j, t);
            if (r.compareTo(t) >= 0)
            {
                var _local5 = r.t++;
                r.a[_local5] = 1;
                r.subTo(t, r);
            };
            ONE.dlShiftTo(ys, t);
            t.subTo(y, y);
            while (y.t < ys)
            {
                y.(y.t++, 0); //not popped
            };
            while (--j >= 0)
            {
                qd = (((r.a[--i])==y0) ? DM : ((Number(r.a[i]) * d1) + ((Number(r.a[(i - 1)]) + e) * d2)));
                if ((r.a[i] = (r.a[i] + y.am(0, qd, r, j, 0, ys))) < qd)
                {
                    y.dlShiftTo(j, t);
                    r.subTo(t, r);
                    while ((qd = (qd - 1)), r.a[i] < qd)
                    {
                        r.subTo(t, r);
                    };
                };
            };
            if (q != null)
            {
                r.drShiftTo(ys, q);
                if (ts != ms)
                {
                    ZERO.subTo(q, q);
                };
            };
            r.t = ys;
            r.clamp();
            if (nsh > 0)
            {
                r.rShiftTo(nsh, r);
            };
            if (ts < 0)
            {
                ZERO.subTo(r, r);
            };
        }

        bi_internal function invDigit():int
        {
            if (this.t < 1)
            {
                return (0);
            };
            var _local1:int = this.a[0];
            if ((_local1 & 1) == 0)
            {
                return (0);
            };
            var _local2 = (_local1 & 3);
            _local2 = ((_local2 * (2 - ((_local1 & 15) * _local2))) & 15);
            _local2 = ((_local2 * (2 - ((_local1 & 0xFF) * _local2))) & 0xFF);
            _local2 = ((_local2 * (2 - (((_local1 & 0xFFFF) * _local2) & 0xFFFF))) & 0xFFFF);
            _local2 = ((_local2 * (2 - ((_local1 * _local2) % DV))) % DV);
            return ((((_local2)>0) ? (DV - _local2) : -(_local2)));
        }

        bi_internal function isEven():Boolean
        {
            return (((((this.t)>0) ? (this.a[0] & 1) : this.s) == 0));
        }

        bi_internal function exp(_arg1:int, _arg2:IReduction):BigInteger
        {
            var _local7:BigInteger;
            if ((((_arg1 > 0xFFFFFFFF)) || ((_arg1 < 1))))
            {
                return (ONE);
            };
            var _local3:BigInteger = this.nbi();
            var _local4:BigInteger = this.nbi();
            var _local5:BigInteger = _arg2.convert(this);
            var _local6:int = (this.nbits(_arg1) - 1);
            _local5.copyTo(_local3);
            while (--_local6 >= 0)
            {
                _arg2.sqrTo(_local3, _local4);
                if ((_arg1 & (1 << _local6)) > 0)
                {
                    _arg2.mulTo(_local4, _local5, _local3);
                }
                else
                {
                    _local7 = _local3;
                    _local3 = _local4;
                    _local4 = _local7;
                };
            };
            return (_arg2.revert(_local3));
        }

        bi_internal function intAt(_arg1:String, _arg2:int):int
        {
            return (parseInt(_arg1.charAt(_arg2), 36));
        }

        protected function nbi()
        {
            return (new BigInteger());
        }

        public function clone():BigInteger
        {
            var _local1:BigInteger = new BigInteger();
            this.copyTo(_local1);
            return (_local1);
        }

        public function intValue():int
        {
            if (this.s < 0)
            {
                if (this.t == 1)
                {
                    return ((this.a[0] - DV));
                };
                if (this.t == 0)
                {
                    return (-1);
                };
            }
            else
            {
                if (this.t == 1)
                {
                    return (this.a[0]);
                };
                if (this.t == 0)
                {
                    return (0);
                };
            };
            return ((((this.a[1] & ((1 << (32 - DB)) - 1)) << DB) | this.a[0]));
        }

        public function byteValue():int
        {
            return ((((this.t)==0) ? this.s : ((this.a[0] << 24) >> 24)));
        }

        public function shortValue():int
        {
            return ((((this.t)==0) ? this.s : ((this.a[0] << 16) >> 16)));
        }

        protected function chunkSize(_arg1:Number):int
        {
            return (Math.floor(((Math.LN2 * DB) / Math.log(_arg1))));
        }

        public function sigNum():int
        {
            if (this.s < 0)
            {
                return (-1);
            };
            if ((((this.t <= 0)) || ((((this.t == 1)) && ((this.a[0] <= 0))))))
            {
                return (0);
            };
            return (1);
        }

        protected function toRadix(_arg1:uint=10):String
        {
            if ((((((this.sigNum() == 0)) || ((_arg1 < 2)))) || ((_arg1 > 32))))
            {
                return ("0");
            };
            var _local2:int = this.chunkSize(_arg1);
            var _local3:Number = Math.pow(_arg1, _local2);
            var _local4:BigInteger = nbv(_local3);
            var _local5:BigInteger = this.nbi();
            var _local6:BigInteger = this.nbi();
            var _local7 = "";
            this.divRemTo(_local4, _local5, _local6);
            while (_local5.sigNum() > 0)
            {
                _local7 = ((_local3 + _local6.intValue()).toString(_arg1).substr(1) + _local7);
                _local5.divRemTo(_local4, _local5, _local6);
            };
            return ((_local6.intValue().toString(_arg1) + _local7));
        }

        protected function fromRadix(_arg1:String, _arg2:int=10):void
        {
            var _local9:int;
            this.fromInt(0);
            var _local3:int = this.chunkSize(_arg2);
            var _local4:Number = Math.pow(_arg2, _local3);
            var _local5:Boolean;
            var _local6:int;
            var _local7:int;
            var _local8:int;
            while (_local8 < _arg1.length)
            {
                _local9 = this.intAt(_arg1, _local8);
                if (_local9 < 0)
                {
                    if ((((_arg1.charAt(_local8) == "-")) && ((this.sigNum() == 0))))
                    {
                        _local5 = true;
                    };
                }
                else
                {
                    _local7 = ((_arg2 * _local7) + _local9);
                    if (++_local6 >= _local3)
                    {
                        this.dMultiply(_local4);
                        this.dAddOffset(_local7, 0);
                        _local6 = 0;
                        _local7 = 0;
                    };
                };
                _local8++;
            };
            if (_local6 > 0)
            {
                this.dMultiply(Math.pow(_arg2, _local6));
                this.dAddOffset(_local7, 0);
            };
            if (_local5)
            {
                BigInteger.ZERO.subTo(this, this);
            };
        }

        public function toByteArray():ByteArray
        {
            var _local4:int;
            var _local1:int = this.t;
            var _local2:ByteArray = new ByteArray();
            _local2[0] = this.s;
            var _local3:int = (DB - ((_local1 * DB) % 8));
            var _local5:int;
            if (_local1-- > 0)
            {
                if ((((_local3 < DB)) && (!(((_local4 = (this.a[_local1] >> _local3)) == ((this.s & DM) >> _local3))))))
                {
                    var _local6 = _local5++;
                    _local2[_local6] = (_local4 | (this.s << (DB - _local3)));
                };
                while (_local1 >= 0)
                {
                    if (_local3 < 8)
                    {
                        _local4 = ((this.a[_local1] & ((1 << _local3) - 1)) << (8 - _local3));
                        var _temp1 = _local4;
                        _local3 = (_local3 + (DB - 8));
                        _local4 = (_temp1 | (this.a[--_local1] >> _local3));
                    }
                    else
                    {
                        _local3 = (_local3 - 8);
                        _local4 = ((this.a[_local1] >> _local3) & 0xFF);
                        if (_local3 <= 0)
                        {
                            _local3 = (_local3 + DB);
                            _local1--;
                        };
                    };
                    if ((_local4 & 128) != 0)
                    {
                        _local4 = (_local4 | -256);
                    };
                    if ((((_local5 == 0)) && (!(((this.s & 128) == (_local4 & 128))))))
                    {
                        _local5++;
                    };
                    if ((((_local5 > 0)) || (!((_local4 == this.s)))))
                    {
                        _local6 = _local5++;
                        _local2[_local6] = _local4;
                    };
                };
            };
            return (_local2);
        }

        public function equals(_arg1:BigInteger):Boolean
        {
            return ((this.compareTo(_arg1) == 0));
        }

        public function min(_arg1:BigInteger):BigInteger
        {
            return ((((this.compareTo(_arg1))<0) ? this : _arg1));
        }

        public function max(_arg1:BigInteger):BigInteger
        {
            return ((((this.compareTo(_arg1))>0) ? this : _arg1));
        }

        protected function bitwiseTo(_arg1:BigInteger, _arg2:Function, _arg3:BigInteger):void
        {
            var _local4:int;
            var _local5:int;
            var _local6:int = Math.min(_arg1.t, this.t);
            _local4 = 0;
            while (_local4 < _local6)
            {
                _arg3.a[_local4] = _arg2(this.a[_local4], _arg1.a[_local4]);
                _local4++;
            };
            if (_arg1.t < this.t)
            {
                _local5 = (_arg1.s & DM);
                _local4 = _local6;
                while (_local4 < this.t)
                {
                    _arg3.a[_local4] = _arg2(this.a[_local4], _local5);
                    _local4++;
                };
                _arg3.t = this.t;
            }
            else
            {
                _local5 = (this.s & DM);
                _local4 = _local6;
                while (_local4 < _arg1.t)
                {
                    _arg3.a[_local4] = _arg2(_local5, _arg1.a[_local4]);
                    _local4++;
                };
                _arg3.t = _arg1.t;
            };
            _arg3.s = _arg2(this.s, _arg1.s);
            _arg3.clamp();
        }

        private function op_and(_arg1:int, _arg2:int):int
        {
            return ((_arg1 & _arg2));
        }

        public function and(_arg1:BigInteger):BigInteger
        {
            var _local2:BigInteger = new BigInteger();
            this.bitwiseTo(_arg1, this.op_and, _local2);
            return (_local2);
        }

        private function op_or(_arg1:int, _arg2:int):int
        {
            return ((_arg1 | _arg2));
        }

        public function or(_arg1:BigInteger):BigInteger
        {
            var _local2:BigInteger = new BigInteger();
            this.bitwiseTo(_arg1, this.op_or, _local2);
            return (_local2);
        }

        private function op_xor(_arg1:int, _arg2:int):int
        {
            return ((_arg1 ^ _arg2));
        }

        public function xor(_arg1:BigInteger):BigInteger
        {
            var _local2:BigInteger = new BigInteger();
            this.bitwiseTo(_arg1, this.op_xor, _local2);
            return (_local2);
        }

        private function op_andnot(_arg1:int, _arg2:int):int
        {
            return ((_arg1 & ~(_arg2)));
        }

        public function andNot(_arg1:BigInteger):BigInteger
        {
            var _local2:BigInteger = new BigInteger();
            this.bitwiseTo(_arg1, this.op_andnot, _local2);
            return (_local2);
        }

        public function not():BigInteger
        {
            var _local1:BigInteger = new BigInteger();
            var _local2:int;
            while (_local2 < this.t)
            {
                _local1[_local2] = (DM & ~(this.a[_local2]));
                _local2++;
            };
            _local1.t = this.t;
            _local1.s = ~(this.s);
            return (_local1);
        }

        public function shiftLeft(_arg1:int):BigInteger
        {
            var _local2:BigInteger = new BigInteger();
            if (_arg1 < 0)
            {
                this.rShiftTo(-(_arg1), _local2);
            }
            else
            {
                this.lShiftTo(_arg1, _local2);
            };
            return (_local2);
        }

        public function shiftRight(_arg1:int):BigInteger
        {
            var _local2:BigInteger = new BigInteger();
            if (_arg1 < 0)
            {
                this.lShiftTo(-(_arg1), _local2);
            }
            else
            {
                this.rShiftTo(_arg1, _local2);
            };
            return (_local2);
        }

        private function lbit(_arg1:int):int
        {
            if (_arg1 == 0)
            {
                return (-1);
            };
            var _local2:int;
            if ((_arg1 & 0xFFFF) == 0)
            {
                _arg1 = (_arg1 >> 16);
                _local2 = (_local2 + 16);
            };
            if ((_arg1 & 0xFF) == 0)
            {
                _arg1 = (_arg1 >> 8);
                _local2 = (_local2 + 8);
            };
            if ((_arg1 & 15) == 0)
            {
                _arg1 = (_arg1 >> 4);
                _local2 = (_local2 + 4);
            };
            if ((_arg1 & 3) == 0)
            {
                _arg1 = (_arg1 >> 2);
                _local2 = (_local2 + 2);
            };
            if ((_arg1 & 1) == 0)
            {
                _local2++;
            };
            return (_local2);
        }

        public function getLowestSetBit():int
        {
            var _local1:int;
            while (_local1 < this.t)
            {
                if (this.a[_local1] != 0)
                {
                    return (((_local1 * DB) + this.lbit(this.a[_local1])));
                };
                _local1++;
            };
            if (this.s < 0)
            {
                return ((this.t * DB));
            };
            return (-1);
        }

        private function cbit(_arg1:int):int
        {
            var _local2:uint;
            while (_arg1 != 0)
            {
                _arg1 = (_arg1 & (_arg1 - 1));
                _local2++;
            };
            return (_local2);
        }

        public function bitCount():int
        {
            var _local1:int;
            var _local2 = (this.s & DM);
            var _local3:int;
            while (_local3 < this.t)
            {
                _local1 = (_local1 + this.cbit((this.a[_local3] ^ _local2)));
                _local3++;
            };
            return (_local1);
        }

        public function testBit(_arg1:int):Boolean
        {
            var _local2:int = Math.floor((_arg1 / DB));
            if (_local2 >= this.t)
            {
                return (!((this.s == 0)));
            };
            return (!(((this.a[_local2] & (1 << (_arg1 % DB))) == 0)));
        }

        protected function changeBit(_arg1:int, _arg2:Function):BigInteger
        {
            var _local3:BigInteger = BigInteger.ONE.shiftLeft(_arg1);
            this.bitwiseTo(_local3, _arg2, _local3);
            return (_local3);
        }

        public function setBit(_arg1:int):BigInteger
        {
            return (this.changeBit(_arg1, this.op_or));
        }

        public function clearBit(_arg1:int):BigInteger
        {
            return (this.changeBit(_arg1, this.op_andnot));
        }

        public function flipBit(_arg1:int):BigInteger
        {
            return (this.changeBit(_arg1, this.op_xor));
        }

        protected function addTo(_arg1:BigInteger, _arg2:BigInteger):void
        {
            var _local3:int;
            var _local4:int;
            var _local5:int = Math.min(_arg1.t, this.t);
            while (_local3 < _local5)
            {
                _local4 = (_local4 + (this.a[_local3] + _arg1.a[_local3]));
                var _local6 = _local3++;
                _arg2.a[_local6] = (_local4 & DM);
                _local4 = (_local4 >> DB);
            };
            if (_arg1.t < this.t)
            {
                _local4 = (_local4 + _arg1.s);
                while (_local3 < this.t)
                {
                    _local4 = (_local4 + this.a[_local3]);
                    _local6 = _local3++;
                    _arg2.a[_local6] = (_local4 & DM);
                    _local4 = (_local4 >> DB);
                };
                _local4 = (_local4 + this.s);
            }
            else
            {
                _local4 = (_local4 + this.s);
                while (_local3 < _arg1.t)
                {
                    _local4 = (_local4 + _arg1.a[_local3]);
                    _local6 = _local3++;
                    _arg2.a[_local6] = (_local4 & DM);
                    _local4 = (_local4 >> DB);
                };
                _local4 = (_local4 + _arg1.s);
            };
            _arg2.s = (((_local4)<0) ? -1 : 0);
            if (_local4 > 0)
            {
                _local6 = _local3++;
                _arg2.a[_local6] = _local4;
            }
            else
            {
                if (_local4 < -1)
                {
                    _local6 = _local3++;
                    _arg2.a[_local6] = (DV + _local4);
                };
            };
            _arg2.t = _local3;
            _arg2.clamp();
        }

        public function add(_arg1:BigInteger):BigInteger
        {
            var _local2:BigInteger = new BigInteger();
            this.addTo(_arg1, _local2);
            return (_local2);
        }

        public function subtract(_arg1:BigInteger):BigInteger
        {
            var _local2:BigInteger = new BigInteger();
            this.subTo(_arg1, _local2);
            return (_local2);
        }

        public function multiply(_arg1:BigInteger):BigInteger
        {
            var _local2:BigInteger = new BigInteger();
            this.multiplyTo(_arg1, _local2);
            return (_local2);
        }

        public function divide(_arg1:BigInteger):BigInteger
        {
            var _local2:BigInteger = new BigInteger();
            this.divRemTo(_arg1, _local2, null);
            return (_local2);
        }

        public function remainder(_arg1:BigInteger):BigInteger
        {
            var _local2:BigInteger = new BigInteger();
            this.divRemTo(_arg1, null, _local2);
            return (_local2);
        }

        public function divideAndRemainder(_arg1:BigInteger):Array
        {
            var _local2:BigInteger = new BigInteger();
            var _local3:BigInteger = new BigInteger();
            this.divRemTo(_arg1, _local2, _local3);
            return ([_local2, _local3]);
        }

        bi_internal function dMultiply(_arg1:int):void
        {
            this.a[this.t] = this.am(0, (_arg1 - 1), this, 0, 0, this.t);
            this.t++;
            this.clamp();
        }

        bi_internal function dAddOffset(_arg1:int, _arg2:int):void
        {
            while (this.t <= _arg2)
            {
                var _local3 = this.t++;
                this.a[_local3] = 0;
            };
            this.a[_arg2] = (this.a[_arg2] + _arg1);
            while (this.a[_arg2] >= DV)
            {
                this.a[_arg2] = (this.a[_arg2] - DV);
                if (++_arg2 >= this.t)
                {
                    _local3 = this.t++;
                    this.a[_local3] = 0;
                };
                _local3 = this.a;
                var _local4 = _arg2;
                var _local5 = (_local3[_local4] + 1);
                _local3[_local4] = _local5;
            };
        }

        public function pow(_arg1:int):BigInteger
        {
            return (this.exp(_arg1, new NullReduction()));
        }

        bi_internal function multiplyLowerTo(_arg1:BigInteger, _arg2:int, _arg3:BigInteger):void
        {
            var _local5:int;
            var _local4:int = Math.min((this.t + _arg1.t), _arg2);
            _arg3.s = 0;
            _arg3.t = _local4;
            while (_local4 > 0)
            {
                var _local6 = --_local4;
                _arg3.a[_local6] = 0;
            };
            _local5 = (_arg3.t - this.t);
            while (_local4 < _local5)
            {
                _arg3.a[(_local4 + this.t)] = this.am(0, _arg1.a[_local4], _arg3, _local4, 0, this.t);
                _local4++;
            };
            _local5 = Math.min(_arg1.t, _arg2);
            while (_local4 < _local5)
            {
                this.am(0, _arg1.a[_local4], _arg3, _local4, 0, (_arg2 - _local4));
                _local4++;
            };
            _arg3.clamp();
        }

        bi_internal function multiplyUpperTo(_arg1:BigInteger, _arg2:int, _arg3:BigInteger):void
        {
            _arg2--;
            var _local4:int = (_arg3.t = ((this.t + _arg1.t) - _arg2));
            _arg3.s = 0;
            while (--_local4 >= 0)
            {
                _arg3.a[_local4] = 0;
            };
            _local4 = Math.max((_arg2 - this.t), 0);
            while (_local4 < _arg1.t)
            {
                _arg3.a[((this.t + _local4) - _arg2)] = this.am((_arg2 - _local4), _arg1.a[_local4], _arg3, 0, 0, ((this.t + _local4) - _arg2));
                _local4++;
            };
            _arg3.clamp();
            _arg3.drShiftTo(1, _arg3);
        }

        public function modPow(_arg1:BigInteger, _arg2:BigInteger):BigInteger
        {
            var _local4:int;
            var _local6:IReduction;
            var _local12:int;
            var _local15:BigInteger;
            var _local16:BigInteger;
            var _local3:int = _arg1.bitLength();
            var _local5:BigInteger = nbv(1);
            if (_local3 <= 0)
            {
                return (_local5);
            };
            if (_local3 < 18)
            {
                _local4 = 1;
            }
            else
            {
                if (_local3 < 48)
                {
                    _local4 = 3;
                }
                else
                {
                    if (_local3 < 144)
                    {
                        _local4 = 4;
                    }
                    else
                    {
                        if (_local3 < 0x0300)
                        {
                            _local4 = 5;
                        }
                        else
                        {
                            _local4 = 6;
                        };
                    };
                };
            };
            if (_local3 < 8)
            {
                _local6 = new ClassicReduction(_arg2);
            }
            else
            {
                if (_arg2.isEven())
                {
                    _local6 = new BarrettReduction(_arg2);
                }
                else
                {
                    _local6 = new MontgomeryReduction(_arg2);
                };
            };
            var _local7:Array = [];
            var _local8:int = 3;
            var _local9:int = (_local4 - 1);
            var _local10:int = ((1 << _local4) - 1);
            _local7[1] = _local6.convert(this);
            if (_local4 > 1)
            {
                _local16 = new BigInteger();
                _local6.sqrTo(_local7[1], _local16);
                while (_local8 <= _local10)
                {
                    _local7[_local8] = new BigInteger();
                    _local6.mulTo(_local16, _local7[(_local8 - 2)], _local7[_local8]);
                    _local8 = (_local8 + 2);
                };
            };
            var _local11:int = (_arg1.t - 1);
            var _local13:Boolean = true;
            var _local14:BigInteger = new BigInteger();
            _local3 = (this.nbits(_arg1.a[_local11]) - 1);
            while (_local11 >= 0)
            {
                if (_local3 >= _local9)
                {
                    _local12 = ((_arg1.a[_local11] >> (_local3 - _local9)) & _local10);
                }
                else
                {
                    _local12 = ((_arg1.a[_local11] & ((1 << (_local3 + 1)) - 1)) << (_local9 - _local3));
                    if (_local11 > 0)
                    {
                        _local12 = (_local12 | (_arg1.a[(_local11 - 1)] >> ((DB + _local3) - _local9)));
                    };
                };
                _local8 = _local4;
                while ((_local12 & 1) == 0)
                {
                    _local12 = (_local12 >> 1);
                    _local8--;
                };
                _local3 = (_local3 - _local8);
                if (_local3 < 0)
                {
                    _local3 = (_local3 + DB);
                    _local11--;
                };
                if (_local13)
                {
                    _local7[_local12].copyTo(_local5);
                    _local13 = false;
                }
                else
                {
                    while (_local8 > 1)
                    {
                        _local6.sqrTo(_local5, _local14);
                        _local6.sqrTo(_local14, _local5);
                        _local8 = (_local8 - 2);
                    };
                    if (_local8 > 0)
                    {
                        _local6.sqrTo(_local5, _local14);
                    }
                    else
                    {
                        _local15 = _local5;
                        _local5 = _local14;
                        _local14 = _local15;
                    };
                    _local6.mulTo(_local14, _local7[_local12], _local5);
                };
                while ((((_local11 >= 0)) && (((_arg1.a[_local11] & (1 << _local3)) == 0))))
                {
                    _local6.sqrTo(_local5, _local14);
                    _local15 = _local5;
                    _local5 = _local14;
                    _local14 = _local15;
                    if (--_local3 < 0)
                    {
                        _local3 = (DB - 1);
                        _local11--;
                    };
                };
            };
            return (_local6.revert(_local5));
        }

        public function gcd(_arg1:BigInteger):BigInteger
        {
            var _local6:BigInteger;
            var _local2:BigInteger = (((this.s)<0) ? this.negate() : this.clone());
            var _local3:BigInteger = (((_arg1.s)<0) ? _arg1.negate() : _arg1.clone());
            if (_local2.compareTo(_local3) < 0)
            {
                _local6 = _local2;
                _local2 = _local3;
                _local3 = _local6;
            };
            var _local4:int = _local2.getLowestSetBit();
            var _local5:int = _local3.getLowestSetBit();
            if (_local5 < 0)
            {
                return (_local2);
            };
            if (_local4 < _local5)
            {
                _local5 = _local4;
            };
            if (_local5 > 0)
            {
                _local2.rShiftTo(_local5, _local2);
                _local3.rShiftTo(_local5, _local3);
            };
            while (_local2.sigNum() > 0)
            {
                _local4 = _local2.getLowestSetBit();
                if (_local4 > 0)
                {
                    _local2.rShiftTo(_local4, _local2);
                };
                _local4 = _local3.getLowestSetBit();
                if (_local4 > 0)
                {
                    _local3.rShiftTo(_local4, _local3);
                };
                if (_local2.compareTo(_local3) >= 0)
                {
                    _local2.subTo(_local3, _local2);
                    _local2.rShiftTo(1, _local2);
                }
                else
                {
                    _local3.subTo(_local2, _local3);
                    _local3.rShiftTo(1, _local3);
                };
            };
            if (_local5 > 0)
            {
                _local3.lShiftTo(_local5, _local3);
            };
            return (_local3);
        }

        protected function modInt(_arg1:int):int
        {
            var _local4:int;
            if (_arg1 <= 0)
            {
                return (0);
            };
            var _local2:int = (DV % _arg1);
            var _local3:int = (((this.s)<0) ? (_arg1 - 1) : 0);
            if (this.t > 0)
            {
                if (_local2 == 0)
                {
                    _local3 = (this.a[0] % _arg1);
                }
                else
                {
                    _local4 = (this.t - 1);
                    while (_local4 >= 0)
                    {
                        _local3 = (((_local2 * _local3) + this.a[_local4]) % _arg1);
                        _local4--;
                    };
                };
            };
            return (_local3);
        }

        public function modInverse(_arg1:BigInteger):BigInteger
        {
            var _local2:Boolean = _arg1.isEven();
            if (((((this.isEven()) && (_local2))) || ((_arg1.sigNum() == 0))))
            {
                return (BigInteger.ZERO);
            };
            var _local3:BigInteger = _arg1.clone();
            var _local4:BigInteger = this.clone();
            var _local5:BigInteger = nbv(1);
            var _local6:BigInteger = nbv(0);
            var _local7:BigInteger = nbv(0);
            var _local8:BigInteger = nbv(1);
            while (_local3.sigNum() != 0)
            {
                while (_local3.isEven())
                {
                    _local3.rShiftTo(1, _local3);
                    if (_local2)
                    {
                        if (((!(_local5.isEven())) || (!(_local6.isEven()))))
                        {
                            _local5.addTo(this, _local5);
                            _local6.subTo(_arg1, _local6);
                        };
                        _local5.rShiftTo(1, _local5);
                    }
                    else
                    {
                        if (!_local6.isEven())
                        {
                            _local6.subTo(_arg1, _local6);
                        };
                    };
                    _local6.rShiftTo(1, _local6);
                };
                while (_local4.isEven())
                {
                    _local4.rShiftTo(1, _local4);
                    if (_local2)
                    {
                        if (((!(_local7.isEven())) || (!(_local8.isEven()))))
                        {
                            _local7.addTo(this, _local7);
                            _local8.subTo(_arg1, _local8);
                        };
                        _local7.rShiftTo(1, _local7);
                    }
                    else
                    {
                        if (!_local8.isEven())
                        {
                            _local8.subTo(_arg1, _local8);
                        };
                    };
                    _local8.rShiftTo(1, _local8);
                };
                if (_local3.compareTo(_local4) >= 0)
                {
                    _local3.subTo(_local4, _local3);
                    if (_local2)
                    {
                        _local5.subTo(_local7, _local5);
                    };
                    _local6.subTo(_local8, _local6);
                }
                else
                {
                    _local4.subTo(_local3, _local4);
                    if (_local2)
                    {
                        _local7.subTo(_local5, _local7);
                    };
                    _local8.subTo(_local6, _local8);
                };
            };
            if (_local4.compareTo(BigInteger.ONE) != 0)
            {
                return (BigInteger.ZERO);
            };
            if (_local8.compareTo(_arg1) >= 0)
            {
                return (_local8.subtract(_arg1));
            };
            if (_local8.sigNum() < 0)
            {
                _local8.addTo(_arg1, _local8);
            }
            else
            {
                return (_local8);
            };
            if (_local8.sigNum() < 0)
            {
                return (_local8.add(_arg1));
            };
            return (_local8);
        }

        public function isProbablePrime(_arg1:int):Boolean
        {
            var _local2:int;
            var _local4:int;
            var _local5:int;
            var _local3:BigInteger = this.abs();
            if ((((_local3.t == 1)) && ((_local3.a[0] <= lowprimes[(lowprimes.length - 1)]))))
            {
                _local2 = 0;
                while (_local2 < lowprimes.length)
                {
                    if (_local3[0] == lowprimes[_local2])
                    {
                        return (true);
                    };
                    _local2++;
                };
                return (false);
            };
            if (_local3.isEven())
            {
                return (false);
            };
            _local2 = 1;
            while (_local2 < lowprimes.length)
            {
                _local4 = lowprimes[_local2];
                _local5 = (_local2 + 1);
                while ((((_local5 < lowprimes.length)) && ((_local4 < lplim))))
                {
                    _local4 = (_local4 * lowprimes[_local5++]);
                };
                _local4 = _local3.modInt(_local4);
                while (_local2 < _local5)
                {
                    if ((_local4 % lowprimes[_local2++]) == 0)
                    {
                        return (false);
                    };
                };
            };
            return (_local3.millerRabin(_arg1));
        }

        protected function millerRabin(_arg1:int):Boolean
        {
            var _local7:BigInteger;
            var _local8:int;
            var _local2:BigInteger = this.subtract(BigInteger.ONE);
            var _local3:int = _local2.getLowestSetBit();
            if (_local3 <= 0)
            {
                return (false);
            };
            var _local4:BigInteger = _local2.shiftRight(_local3);
            _arg1 = ((_arg1 + 1) >> 1);
            if (_arg1 > lowprimes.length)
            {
                _arg1 = lowprimes.length;
            };
            var _local5:BigInteger = new BigInteger();
            var _local6:int;
            while (_local6 < _arg1)
            {
                _local5.fromInt(lowprimes[_local6]);
                _local7 = _local5.modPow(_local4, this);
                if (((!((_local7.compareTo(BigInteger.ONE) == 0))) && (!((_local7.compareTo(_local2) == 0)))))
                {
                    _local8 = 1;
                    while ((((_local8++ < _local3)) && (!((_local7.compareTo(_local2) == 0)))))
                    {
                        _local7 = _local7.modPowInt(2, this);
                        if (_local7.compareTo(BigInteger.ONE) == 0)
                        {
                            return (false);
                        };
                    };
                    if (_local7.compareTo(_local2) != 0)
                    {
                        return (false);
                    };
                };
                _local6++;
            };
            return (true);
        }

        public function primify(_arg1:int, _arg2:int):void
        {
            if (!this.testBit((_arg1 - 1)))
            {
                this.bitwiseTo(BigInteger.ONE.shiftLeft((_arg1 - 1)), this.op_or, this);
            };
            if (this.isEven())
            {
                this.dAddOffset(1, 0);
            };
            while (!(this.isProbablePrime(_arg2)))
            {
                this.dAddOffset(2, 0);
                while (this.bitLength() > _arg1)
                {
                    this.subTo(BigInteger.ONE.shiftLeft((_arg1 - 1)), this);
                };
            };
        }


    }
}

