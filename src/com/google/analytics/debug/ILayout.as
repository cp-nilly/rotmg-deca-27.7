package com.google.analytics.debug
{
    import flash.display.DisplayObject;
    import flash.net.URLRequest;
    import com.google.analytics.core.GIFRequest;

    public interface ILayout 
    {

        function createAlert(_arg1:String):void;
        function addToStage(_arg1:DisplayObject):void;
        function createGIFRequestAlert(_arg1:String, _arg2:URLRequest, _arg3:GIFRequest):void;
        function createWarning(_arg1:String):void;
        function createPanel(_arg1:String, _arg2:uint, _arg3:uint):void;
        function createInfo(_arg1:String):void;
        function createFailureAlert(_arg1:String):void;
        function addToPanel(_arg1:String, _arg2:DisplayObject):void;
        function init():void;
        function createSuccessAlert(_arg1:String):void;
        function createVisualDebug():void;
        function destroy():void;
        function bringToFront(_arg1:DisplayObject):void;
        function isAvailable():Boolean;

    }
}

