﻿package kabam.display.Loader
{
    import flash.display.Sprite;
    import flash.display.DisplayObject;
    import kabam.display.LoaderInfo.LoaderInfoProxy;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;

    public class LoaderProxy extends Sprite 
    {


        public function get content():DisplayObject
        {
            return (null);
        }

        public function get contentLoaderInfo():LoaderInfoProxy
        {
            return (null);
        }

        public function load(_arg1:URLRequest, _arg2:LoaderContext=null):void
        {
        }

        public function unload():void
        {
        }


    }
}

