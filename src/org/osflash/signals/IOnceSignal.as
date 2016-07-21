package org.osflash.signals
{
    public interface IOnceSignal 
    {

        function get valueClasses():Array;
        function set valueClasses(_arg1:Array):void;
        function get numListeners():uint;
        function addOnce(_arg1:Function):ISlot;
        function dispatch(... _args):void;
        function remove(_arg1:Function):ISlot;
        function removeAll():void;

    }
}

