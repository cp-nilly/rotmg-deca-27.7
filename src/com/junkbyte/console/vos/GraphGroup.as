package com.junkbyte.console.vos
{
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;

    public class GraphGroup 
    {

        public static const FPS:uint = 1;
        public static const MEM:uint = 2;

        public var type:uint;
        public var name:String;
        public var freq:int = 1;
        public var low:Number;
        public var hi:Number;
        public var fixed:Boolean;
        public var averaging:uint;
        public var inv:Boolean;
        public var interests:Array;
        public var rect:Rectangle;
        public var idle:int;

        public function GraphGroup(_arg1:String)
        {
            this.interests = [];
            super();
            this.name = _arg1;
        }

        public static function FromBytes(_arg1:ByteArray):GraphGroup
        {
            var _local2:GraphGroup = new (GraphGroup)(_arg1.readUTF());
            _local2.type = _arg1.readUnsignedInt();
            _local2.idle = _arg1.readUnsignedInt();
            _local2.low = _arg1.readDouble();
            _local2.hi = _arg1.readDouble();
            _local2.inv = _arg1.readBoolean();
            var _local3:uint = _arg1.readUnsignedInt();
            while (_local3)
            {
                _local2.interests.push(GraphInterest.FromBytes(_arg1));
                _local3--;
            };
            return (_local2);
        }


        public function updateMinMax(_arg1:Number):void
        {
            if (((!(isNaN(_arg1))) && (!(this.fixed))))
            {
                if (isNaN(this.low))
                {
                    this.low = _arg1;
                    this.hi = _arg1;
                };
                if (_arg1 > this.hi)
                {
                    this.hi = _arg1;
                };
                if (_arg1 < this.low)
                {
                    this.low = _arg1;
                };
            };
        }

        public function toBytes(_arg1:ByteArray):void
        {
            var _local2:GraphInterest;
            _arg1.writeUTF(this.name);
            _arg1.writeUnsignedInt(this.type);
            _arg1.writeUnsignedInt(this.idle);
            _arg1.writeDouble(this.low);
            _arg1.writeDouble(this.hi);
            _arg1.writeBoolean(this.inv);
            _arg1.writeUnsignedInt(this.interests.length);
            for each (_local2 in this.interests)
            {
                _local2.toBytes(_arg1);
            };
        }


    }
}

