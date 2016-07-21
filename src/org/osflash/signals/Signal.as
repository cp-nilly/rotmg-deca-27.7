package org.osflash.signals
{
    public class Signal extends OnceSignal implements ISignal 
    {

        public function Signal(... _args)
        {
            _args = (((((_args.length == 1)) && ((_args[0] is Array)))) ? _args[0] : _args);
            super(_args);
        }

        public function add(_arg1:Function):ISlot
        {
            return (registerListener(_arg1));
        }


    }
}

