package com.hurlant.math
{
	use namespace bi_internal;
	
    public class NullReduction implements IReduction 
    {


        public function revert(_arg1:BigInteger):BigInteger
        {
            return (_arg1);
        }

        public function mulTo(_arg1:BigInteger, _arg2:BigInteger, _arg3:BigInteger):void
        {
            _arg1.multiplyTo(_arg2, _arg3);
        }

        public function sqrTo(_arg1:BigInteger, _arg2:BigInteger):void
        {
            _arg1.squareTo(_arg2);
        }

        public function convert(_arg1:BigInteger):BigInteger
        {
            return (_arg1);
        }

        public function reduce(_arg1:BigInteger):void
        {
        }


    }
}

