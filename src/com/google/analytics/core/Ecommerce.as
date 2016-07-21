package com.google.analytics.core
{
    import com.google.analytics.debug.DebugConfiguration;
    import com.google.analytics.ecommerce.Transaction;

    public class Ecommerce 
    {

        private var _debug:DebugConfiguration;
        private var _trans:Array;

        public function Ecommerce(_arg1:DebugConfiguration)
        {
            this._debug = _arg1;
            _trans = new Array();
        }

        public function getTransLength():Number
        {
            return (_trans.length);
        }

        public function getTransFromArray(_arg1:Number):Transaction
        {
            return (_trans[_arg1]);
        }

        public function addTransaction(_arg1:String, _arg2:String, _arg3:String, _arg4:String, _arg5:String, _arg6:String, _arg7:String, _arg8:String):Transaction
        {
            var _local9:Transaction;
            _local9 = getTransaction(_arg1);
            if (_local9 == null)
            {
                _local9 = new Transaction(_arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8);
                _trans.push(_local9);
            }
            else
            {
                _local9.affiliation = _arg2;
                _local9.total = _arg3;
                _local9.tax = _arg4;
                _local9.shipping = _arg5;
                _local9.city = _arg6;
                _local9.state = _arg7;
                _local9.country = _arg8;
            };
            return (_local9);
        }

        public function getTransaction(_arg1:String):Transaction
        {
            var _local2:Number;
            _local2 = 0;
            while (_local2 < _trans.length)
            {
                if (_trans[_local2].id == _arg1)
                {
                    return (_trans[_local2]);
                };
                _local2++;
            };
            return (null);
        }


    }
}

