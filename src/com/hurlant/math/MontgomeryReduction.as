package com.hurlant.math
{
    import com.hurlant.math.BigInteger;
    import com.hurlant.math.bi_internal;
    import com.hurlant.math.*;

    use namespace bi_internal;

    class MontgomeryReduction implements IReduction 
    {

        private var m:BigInteger;
        private var mp:int;
        private var mpl:int;
        private var mph:int;
        private var um:int;
        private var mt2:int;

        public function MontgomeryReduction(_arg1:BigInteger)
        {
            this.m = _arg1;
            this.mp = _arg1.invDigit();
            this.mpl = (this.mp & 32767);
            this.mph = (this.mp >> 15);
            this.um = ((1 << (BigInteger.DB - 15)) - 1);
            this.mt2 = (2 * _arg1.t);
        }

        public function convert(_arg1:BigInteger):BigInteger
        {
            var _local2:BigInteger = new BigInteger();
            _arg1.abs().dlShiftTo(this.m.t, _local2);
            _local2.divRemTo(this.m, null, _local2);
            if ((((_arg1.s < 0)) && ((_local2.compareTo(BigInteger.ZERO) > 0))))
            {
                this.m.subTo(_local2, _local2);
            };
            return (_local2);
        }

        public function revert(_arg1:BigInteger):BigInteger
        {
            var _local2:BigInteger = new BigInteger();
            _arg1.copyTo(_local2);
            this.reduce(_local2);
            return (_local2);
        }

        public function reduce(_arg1:BigInteger):void
        {
            var _local3:int;
            var _local4:int;
            while (_arg1.t <= this.mt2)
            {
                var _local5 = _arg1.t++;
                _arg1.a[_local5] = 0;
            };
            var _local2:int;
            while (_local2 < this.m.t)
            {
                _local3 = (_arg1.a[_local2] & 32767);
                _local4 = (((_local3 * this.mpl) + ((((_local3 * this.mph) + ((_arg1.a[_local2] >> 15) * this.mpl)) & this.um) << 15)) & BigInteger.DM);
                _local3 = (_local2 + this.m.t);
                _arg1.a[_local3] = (_arg1.a[_local3] + this.m.am(0, _local4, _arg1, _local2, 0, this.m.t));
                while (_arg1.a[_local3] >= BigInteger.DV)
                {
                    _arg1.a[_local3] = (_arg1.a[_local3] - BigInteger.DV);
                    _local5 = _arg1.a;
                    var _local6 = ++_local3;
                    var _local7 = (_local5[_local6] + 1);
                    _local5[_local6] = _local7;
                };
                _local2++;
            };
            _arg1.clamp();
            _arg1.drShiftTo(this.m.t, _arg1);
            if (_arg1.compareTo(this.m) >= 0)
            {
                _arg1.subTo(this.m, _arg1);
            };
        }

        public function sqrTo(_arg1:BigInteger, _arg2:BigInteger):void
        {
            _arg1.squareTo(_arg2);
            this.reduce(_arg2);
        }

        public function mulTo(_arg1:BigInteger, _arg2:BigInteger, _arg3:BigInteger):void
        {
            _arg1.multiplyTo(_arg2, _arg3);
            this.reduce(_arg3);
        }


    }
}

