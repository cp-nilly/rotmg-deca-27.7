package com.google.analytics.ecommerce
{
    import com.google.analytics.utils.Variables;

    public class Transaction 
    {

        private var _items:Array;
        private var _total:String;
        private var _vars:Variables;
        private var _shipping:String;
        private var _city:String;
        private var _state:String;
        private var _country:String;
        private var _tax:String;
        private var _affiliation:String;
        private var _id:String;

        public function Transaction(_arg1:String, _arg2:String, _arg3:String, _arg4:String, _arg5:String, _arg6:String, _arg7:String, _arg8:String)
        {
            this._id = _arg1;
            this._affiliation = _arg2;
            this._total = _arg3;
            this._tax = _arg4;
            this._shipping = _arg5;
            this._city = _arg6;
            this._state = _arg7;
            this._country = _arg8;
            _items = new Array();
        }

        public function get total():String
        {
            return (_total);
        }

        public function getItemFromArray(_arg1:Number):Item
        {
            return (_items[_arg1]);
        }

        public function set total(_arg1:String):void
        {
            _total = _arg1;
        }

        public function getItem(_arg1:String):Item
        {
            var _local2:Number;
            _local2 = 0;
            while (_local2 < _items.length)
            {
                if (_items[_local2].sku == _arg1)
                {
                    return (_items[_local2]);
                };
                _local2++;
            };
            return (null);
        }

        public function getItemsLength():Number
        {
            return (_items.length);
        }

        public function addItem(_arg1:String, _arg2:String, _arg3:String, _arg4:String, _arg5:String):void
        {
            var _local6:Item;
            _local6 = getItem(_arg1);
            if (_local6 == null)
            {
                _local6 = new Item(_id, _arg1, _arg2, _arg3, _arg4, _arg5);
                _items.push(_local6);
            }
            else
            {
                _local6.name = _arg2;
                _local6.category = _arg3;
                _local6.price = _arg4;
                _local6.quantity = _arg5;
            };
        }

        public function set shipping(_arg1:String):void
        {
            _shipping = _arg1;
        }

        public function get country():String
        {
            return (_country);
        }

        public function get state():String
        {
            return (_state);
        }

        public function set tax(_arg1:String):void
        {
            _tax = _arg1;
        }

        public function set affiliation(_arg1:String):void
        {
            _affiliation = _arg1;
        }

        public function set state(_arg1:String):void
        {
            _state = _arg1;
        }

        public function get id():String
        {
            return (_id);
        }

        public function get tax():String
        {
            return (_tax);
        }

        public function toGifParams():Variables
        {
            var _local1:Variables = new Variables();
            _local1.URIencode = true;
            _local1.utmt = "tran";
            _local1.utmtid = id;
            _local1.utmtst = affiliation;
            _local1.utmtto = total;
            _local1.utmttx = tax;
            _local1.utmtsp = shipping;
            _local1.utmtci = city;
            _local1.utmtrg = state;
            _local1.utmtco = country;
            _local1.post = ["utmtid", "utmtst", "utmtto", "utmttx", "utmtsp", "utmtci", "utmtrg", "utmtco"];
            return (_local1);
        }

        public function get affiliation():String
        {
            return (_affiliation);
        }

        public function get city():String
        {
            return (_city);
        }

        public function get shipping():String
        {
            return (_shipping);
        }

        public function set id(_arg1:String):void
        {
            _id = _arg1;
        }

        public function set city(_arg1:String):void
        {
            _city = _arg1;
        }

        public function set country(_arg1:String):void
        {
            _country = _arg1;
        }


    }
}

