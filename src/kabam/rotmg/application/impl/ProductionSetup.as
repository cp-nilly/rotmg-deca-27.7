﻿package kabam.rotmg.application.impl
{
    import kabam.rotmg.application.api.ApplicationSetup;
    import com.company.assembleegameclient.parameters.Parameters;

    public class ProductionSetup implements ApplicationSetup 
    {

        private const SERVER:String = "realmofthemadgodhrd.appspot.com";
        private const UNENCRYPTED:String = ("http://" + SERVER);
        private const ENCRYPTED:String = ("https://" + SERVER);
        private const ANALYTICS:String = "UA-11236645-4";
        private const BUILD_LABEL:String = "RotMG #{VERSION}.{MINOR}";


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
            return (this.BUILD_LABEL.replace("{VERSION}", Parameters.BUILD_VERSION).replace("{MINOR}", Parameters.MINOR_VERSION));
        }

        public function useLocalTextures():Boolean
        {
            return (false);
        }

        public function isToolingEnabled():Boolean
        {
            return (false);
        }

        public function isGameLoopMonitored():Boolean
        {
            return (false);
        }

        public function useProductionDialogs():Boolean
        {
            return (true);
        }

        public function areErrorsReported():Boolean
        {
            return (false);
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

