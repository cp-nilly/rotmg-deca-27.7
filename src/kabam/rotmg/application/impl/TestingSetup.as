﻿package kabam.rotmg.application.impl
{
    import kabam.rotmg.application.api.ApplicationSetup;
    import com.company.assembleegameclient.parameters.Parameters;

    public class TestingSetup implements ApplicationSetup 
    {

        private const SERVER:String = "rotmgtesting.appspot.com";
        private const UNENCRYPTED:String = ("http://" + SERVER);
        private const ENCRYPTED:String = ("https://" + SERVER);
        private const ANALYTICS:String = "UA-11236645-6";
        private const BUILD_LABEL:String = "<font color='#FF0000'>TESTING</font> #{VERSION}";


        public function getAppEngineUrl(_arg1:Boolean=false):String
        {
            return (((_arg1) ? this.UNENCRYPTED : this.ENCRYPTED));
        }

        public function getAnalyticsCode():String
        {
            return (this.ANALYTICS);
        }

        public function getBuildLabel():String
        {
            var _local1:String = ((Parameters.BUILD_VERSION + ".") + Parameters.MINOR_VERSION);
            return (this.BUILD_LABEL.replace("{VERSION}", _local1));
        }

        public function useLocalTextures():Boolean
        {
            return (true);
        }

        public function isToolingEnabled():Boolean
        {
            return (true);
        }

        public function isGameLoopMonitored():Boolean
        {
            return (true);
        }

        public function areErrorsReported():Boolean
        {
            return (false);
        }

        public function useProductionDialogs():Boolean
        {
            return (true);
        }

        public function areDeveloperHotkeysEnabled():Boolean
        {
            return (false);
        }

        public function isDebug():Boolean
        {
            return (false);
        }


    }
}
