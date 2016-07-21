package com.google.analytics.utils
{
    import flash.system.System;
    import com.google.analytics.core.Utils;
    import flash.system.Capabilities;

    public class UserAgent 
    {

        public static var minimal:Boolean = false;

        private var _localInfo:Environment;
        private var _applicationProduct:String;
        private var _version:Version;

        public function UserAgent(_arg1:Environment, _arg2:String="", _arg3:String="")
        {
            _localInfo = _arg1;
            applicationProduct = _arg2;
            _version = Version.fromString(_arg3);
        }

        public function get tamarinProductToken():String
        {
            if (UserAgent.minimal)
            {
                return ("");
            };
            if (System.vmVersion)
            {
                return (("Tamarin/" + Utils.trim(System.vmVersion, true)));
            };
            return ("");
        }

        public function get applicationVersion():String
        {
            return (_version.toString(2));
        }

        public function get vendorProductToken():String
        {
            var _local1 = "";
            if (_localInfo.isAIR())
            {
                _local1 = (_local1 + "AIR");
            }
            else
            {
                _local1 = (_local1 + "FlashPlayer");
            };
            _local1 = (_local1 + "/");
            return ((_local1 + _version.toString(3)));
        }

        public function toString():String
        {
            var _local1 = "";
            _local1 = (_local1 + applicationProductToken);
            if (applicationComment != "")
            {
                _local1 = (_local1 + (" " + applicationComment));
            };
            if (tamarinProductToken != "")
            {
                _local1 = (_local1 + (" " + tamarinProductToken));
            };
            if (vendorProductToken != "")
            {
                _local1 = (_local1 + (" " + vendorProductToken));
            };
            return (_local1);
        }

        public function get applicationComment():String
        {
            var _local1:Array = [];
            _local1.push(_localInfo.platform);
            _local1.push(_localInfo.playerType);
            if (!UserAgent.minimal)
            {
                _local1.push(_localInfo.operatingSystem);
                _local1.push(_localInfo.language);
            };
            if (Capabilities.isDebugger)
            {
                _local1.push("DEBUG");
            };
            if (_local1.length > 0)
            {
                return ((("(" + _local1.join("; ")) + ")"));
            };
            return ("");
        }

        public function set applicationVersion(_arg1:String):void
        {
            _version = Version.fromString(_arg1);
        }

        public function get applicationProductToken():String
        {
            var _local1:String = applicationProduct;
            if (applicationVersion != "")
            {
                _local1 = (_local1 + ("/" + applicationVersion));
            };
            return (_local1);
        }

        public function set applicationProduct(_arg1:String):void
        {
            _applicationProduct = _arg1;
        }

        public function get applicationProduct():String
        {
            return (_applicationProduct);
        }


    }
}

