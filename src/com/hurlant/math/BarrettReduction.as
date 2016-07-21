package com.hurlant.math
{
    import com.hurlant.math.BigInteger;
    import com.hurlant.math.bi_internal;

    use namespace bi_internal;

    class BarrettReduction implements IReduction 
    {

        private var m:BigInteger;
        private var r2:BigInteger;
        private var q3:BigInteger;
        private var mu:BigInteger;

        public function BarrettReduction(_arg1:BigInteger)
        {
            this.r2 = new BigInteger();
            this.q3 = new BigInteger();
            BigInteger.ONE.dlShiftTo((2 * _arg1.t), this.r2);
            this.mu = this.r2.divide(_arg1);
            this.m = _arg1;
        }

        public function revert(_arg1:BigInteger):BigInteger
        {
            return (_arg1);
        }

        public function mulTo(_arg1:BigInteger, _arg2:BigInteger, _arg3:BigInteger):void
        {
            _arg1.multiplyTo(_arg2, _arg3);
            this.reduce(_arg3);
        }

        public function sqrTo(_arg1:BigInteger, _arg2:BigInteger):void
        {
            _arg1.squareTo(_arg2);
            this.reduce(_arg2);
        }

        public function convert(_arg1:BigInteger):BigInteger
        {
            var _local2:BigInteger;
            if ((((_arg1.s < 0)) || ((_arg1.t > (2 * this.m.t)))))
            {
                return (_arg1.mod(this.m));
            };
            if (_arg1.compareTo(this.m) < 0)
            {
                return (_arg1);
            };
            _local2 = new BigInteger();
            _arg1.copyTo(_local2);
            this.reduce(_local2);
            return (_local2);
        }

        public function reduce(_arg1:BigInteger):void
        {
            var _local2:BigInteger = (_arg1 as BigInteger);
            _local2.drShiftTo((this.m.t - 1), this.r2);
            if (_local2.t > (this.m.t + 1))
            {
                _local2.t = (this.m.t + 1);
                _local2.clamp();
            };
            this.mu.multiplyUpperTo(this.r2, (this.m.t + 1), this.q3);
            this.m.multiplyLowerTo(this.q3, (this.m.t + 1), this.r2);
            while (_local2.compareTo(this.r2) < 0)
            {
                _local2.dAddOffset(1, (this.m.t + 1));
            };
            _local2.subTo(this.r2, _local2);
            while (_local2.compareTo(this.m) >= 0)
            {
                _local2.subTo(this.m, _local2);
            };
        }


    }
}

