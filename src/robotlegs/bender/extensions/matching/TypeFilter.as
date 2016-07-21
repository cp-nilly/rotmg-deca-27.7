package robotlegs.bender.extensions.matching
{
    import __AS3__.vec.Vector;
    import flash.utils.getQualifiedClassName;
    import __AS3__.vec.*;

    public class TypeFilter implements ITypeFilter 
    {

        protected var _allOfTypes:Vector.<Class>;
        protected var _anyOfTypes:Vector.<Class>;
        protected var _descriptor:String;
        protected var _noneOfTypes:Vector.<Class>;

        public function TypeFilter(_arg1:Vector.<Class>, _arg2:Vector.<Class>, _arg3:Vector.<Class>)
        {
            if (((((!(_arg1)) || (!(_arg2)))) || (!(_arg3))))
            {
                throw (ArgumentError("TypeFilter parameters can not be null"));
            };
            this._allOfTypes = _arg1;
            this._anyOfTypes = _arg2;
            this._noneOfTypes = _arg3;
        }

        public function get allOfTypes():Vector.<Class>
        {
            return (this._allOfTypes);
        }

        public function get anyOfTypes():Vector.<Class>
        {
            return (this._anyOfTypes);
        }

        public function get descriptor():String
        {
            return ((this._descriptor = ((this._descriptor) || (this.createDescriptor()))));
        }

        public function get noneOfTypes():Vector.<Class>
        {
            return (this._noneOfTypes);
        }

        public function matches(_arg1:*):Boolean
        {
            var _local2:uint = this._allOfTypes.length;
            while (_local2--)
            {
                if (!(_arg1 is this._allOfTypes[_local2]))
                {
                    return (false);
                };
            };
            _local2 = this._noneOfTypes.length;
            while (_local2--)
            {
                if ((_arg1 is this._noneOfTypes[_local2]))
                {
                    return (false);
                };
            };
            if ((((this._anyOfTypes.length == 0)) && ((((this._allOfTypes.length > 0)) || ((this._noneOfTypes.length > 0))))))
            {
                return (true);
            };
            _local2 = this._anyOfTypes.length;
            while (_local2--)
            {
                if ((_arg1 is this._anyOfTypes[_local2]))
                {
                    return (true);
                };
            };
            return (false);
        }

        protected function alphabetiseCaseInsensitiveFCQNs(_arg1:Vector.<Class>):Vector.<String>
        {
            var _local2:String;
            var _local3:Vector.<String> = new <String>[];
            var _local4:uint = _arg1.length;
            var _local5:uint;
            while (_local5 < _local4)
            {
                _local2 = getQualifiedClassName(_arg1[_local5]);
                _local3[_local3.length] = _local2;
                _local5++;
            };
            _local3.sort(this.stringSort);
            return (_local3);
        }

        protected function createDescriptor():String
        {
            var _local1:Vector.<String> = this.alphabetiseCaseInsensitiveFCQNs(this.allOfTypes);
            var _local2:Vector.<String> = this.alphabetiseCaseInsensitiveFCQNs(this.anyOfTypes);
            var _local3:Vector.<String> = this.alphabetiseCaseInsensitiveFCQNs(this.noneOfTypes);
            return (((((("all of: " + _local1.toString()) + ", any of: ") + _local2.toString()) + ", none of: ") + _local3.toString()));
        }

        protected function stringSort(_arg1:String, _arg2:String):int
        {
            if (_arg1 < _arg2)
            {
                return (1);
            };
            return (-1);
        }


    }
}

