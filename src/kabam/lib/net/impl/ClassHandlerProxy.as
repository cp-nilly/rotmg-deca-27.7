package kabam.lib.net.impl
{
    import kabam.lib.net.api.MessageHandlerProxy;
	import robotlegs.bender.framework.api.IInjector;

    public class ClassHandlerProxy implements MessageHandlerProxy 
    {

        private var injector:IInjector;
        private var handlerType:Class;
        private var handler:Object;


        public function setType(_arg1:Class):ClassHandlerProxy
        {
            this.handlerType = _arg1;
            return (this);
        }

        public function setInjector(_arg1:IInjector):ClassHandlerProxy
        {
            this.injector = _arg1;
            return (this);
        }

        public function getMethod():Function
        {
            return (((this.handler) ? this.handler.execute : this.makeHandlerAndReturnExecute()));
        }

        private function makeHandlerAndReturnExecute():Function
        {
            if (!this.handlerType)
            {
                return (null);
            };
            this.handler = this.injector.getInstance(this.handlerType);
            return (this.handler.execute);
        }


    }
}

