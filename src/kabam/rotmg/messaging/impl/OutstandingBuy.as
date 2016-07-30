package kabam.rotmg.messaging.impl
{
    class OutstandingBuy
    {
        private var id_:String;
        private var price_:int;
        private var currency_:int;
        private var converted_:Boolean;

        public function OutstandingBuy(_arg1:String, _arg2:int, _arg3:int, _arg4:Boolean)
        {
            this.id_ = _arg1;
            this.price_ = _arg2;
            this.currency_ = _arg3;
            this.converted_ = _arg4;
        }
    }
}

