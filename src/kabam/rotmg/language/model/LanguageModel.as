﻿package kabam.rotmg.language.model
{
    import __AS3__.vec.Vector;

    public interface LanguageModel 
    {

        function getLanguage():String;
        function setLanguage(_arg1:String):void;
        function getLanguageFamily():String;
        function getLanguageNames():Vector.<String>;
        function getLanguageCodeForName(_arg1:String):String;
        function getNameForLanguageCode(_arg1:String):String;

    }
}

