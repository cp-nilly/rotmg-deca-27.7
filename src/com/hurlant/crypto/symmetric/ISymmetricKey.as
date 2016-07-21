package com.hurlant.crypto.symmetric
{
    import flash.utils.ByteArray;

    public interface ISymmetricKey 
    {

        function getBlockSize():uint;
        function encrypt(_arg1:ByteArray, _arg2:uint=0):void;
        function decrypt(_arg1:ByteArray, _arg2:uint=0):void;
        function dispose():void;
        function toString():String;

    }
}

