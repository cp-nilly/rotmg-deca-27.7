package com.hurlant.crypto.symmetric
{
    import flash.utils.ByteArray;

    public interface ICipher 
    {

        function getBlockSize():uint;
        function encrypt(_arg1:ByteArray):void;
        function decrypt(_arg1:ByteArray):void;
        function dispose():void;
        function toString():String;

    }
}

