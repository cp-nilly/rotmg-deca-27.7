package com.hurlant.crypto.symmetric
{
    import flash.utils.ByteArray;

    public interface IPad 
    {

        function pad(_arg1:ByteArray):void;
        function unpad(_arg1:ByteArray):void;
        function setBlockSize(_arg1:uint):void;

    }
}

