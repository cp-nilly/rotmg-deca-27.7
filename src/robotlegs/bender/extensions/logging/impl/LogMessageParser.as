package robotlegs.bender.extensions.logging.impl
{
    public class LogMessageParser 
    {


        public function parseMessage(_arg1:String, _arg2:Array):String
        {
            var _local3:int;
            var _local4:int;
            if (_arg2)
            {
                _local3 = _arg2.length;
                _local4 = 0;
                while (_local4 < _local3)
                {
                    _arg1 = _arg1.split((("{" + _local4) + "}")).join(_arg2[_local4]);
                    _local4++;
                };
            };
            return (_arg1);
        }


    }
}

