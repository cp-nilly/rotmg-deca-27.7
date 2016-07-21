package org.osflash.signals
{
    public interface ISignal extends IOnceSignal 
    {

        function add(_arg1:Function):ISlot;

    }
}

