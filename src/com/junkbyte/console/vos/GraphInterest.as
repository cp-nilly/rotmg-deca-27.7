package com.junkbyte.console.vos
{
    import flash.utils.ByteArray;
    import com.junkbyte.console.core.Executer;

    public class GraphInterest 
    {

        private var _ref:WeakRef;
        public var _prop:String;
        private var useExec:Boolean;
        public var key:String;
        public var col:Number;
        public var v:Number;
        public var avg:Number;

        public function GraphInterest(_arg1:String="", _arg2:Number=0):void
        {
            this.col = _arg2;
            this.key = _arg1;
        }

        public static function FromBytes(_arg1:ByteArray):GraphInterest
        {
            var _local2:GraphInterest = new (GraphInterest)(_arg1.readUTF(), _arg1.readUnsignedInt());
            _local2.v = _arg1.readDouble();
            _local2.avg = _arg1.readDouble();
            return (_local2);
        }


        public function setObject(_arg1:Object, _arg2:String):Number
        {
            this._ref = new WeakRef(_arg1);
            this._prop = _arg2;
            this.useExec = (this._prop.search(/[^\w\d]/) >= 0);
            this.v = this.getCurrentValue();
            this.avg = this.v;
            return (this.v);
        }

        public function get obj():Object
        {
            return ((((this._ref)!=null) ? this._ref.reference : undefined));
        }

        public function get prop():String
        {
            return (this._prop);
        }

        public function getCurrentValue():Number
        {
            return (((this.useExec) ? Executer.Exec(this.obj, this._prop) : this.obj[this._prop]));
        }

        public function setValue(_arg1:Number, _arg2:uint=0):void
        {
            this.v = _arg1;
            if (_arg2 > 0)
            {
                if (isNaN(this.avg))
                {
                    this.avg = this.v;
                }
                else
                {
                    this.avg = (this.avg + ((this.v - this.avg) / _arg2));
                };
            };
        }

        public function toBytes(_arg1:ByteArray):void
        {
            _arg1.writeUTF(this.key);
            _arg1.writeUnsignedInt(this.col);
            _arg1.writeDouble(this.v);
            _arg1.writeDouble(this.avg);
        }


    }
}

