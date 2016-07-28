package kabam.rotmg.account.web
{
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.util.GUID;

    import flash.external.ExternalInterface;
    import flash.net.SharedObject;

    import kabam.rotmg.account.core.Account;

    public class WebAccount implements Account
    {
        public static const NETWORK_NAME:String = "rotmg";
        private static const WEB_USER_ID:String = "";
        private static const WEB_PLAY_PLATFORM_NAME:String = "rotmg";
        private var userId:String = "";
        private var password:String;
        private var entryTag:String = "";
        private var isVerifiedEmail:Boolean;
        private var platformToken:String;
        public var signedRequest:String;
        public var kabamId:String;

        public function WebAccount()
        {
            try
            {
                this.entryTag = ExternalInterface.call("rotmg.UrlLib.getParam", "entrypt");
            }
            catch (error:Error)
            {
            }
        }

        public function getUserName():String
        {
            return (this.userId);
        }

        public function getUserId():String
        {
            return ((this.userId = ((this.userId) || (GUID.create()))));
        }

        public function getPassword():String
        {
            return (((this.password) || ("")));
        }

        public function getCredentials():Object
        {
            return ({
                "guid": this.getUserId(), "password": this.getPassword()
            });
        }

        public function isRegistered():Boolean
        {
            return (!((this.getPassword() == "")));
        }

        public function updateUser(_arg1:String, _arg2:String):void
        {
            var _local3:SharedObject;
            this.userId = _arg1;
            this.password = _arg2;
            try
            {
                _local3 = SharedObject.getLocal("RotMG", "/");
                _local3.data["GUID"] = _arg1;
                _local3.data["Password"] = _arg2;
                _local3.flush();
            }
            catch (error:Error)
            {
            }
        }

        public function clear():void
        {
            this.updateUser(GUID.create(), null);
            Parameters.sendLogin_ = true;
            Parameters.data_.charIdUseMap = {};
            Parameters.save();
        }

        public function reportIntStat(_arg1:String, _arg2:int):void
        {
        }

        public function getRequestPrefix():String
        {
            return ("/credits");
        }

        public function gameNetworkUserId():String
        {
            return (WEB_USER_ID);
        }

        public function gameNetwork():String
        {
            return (NETWORK_NAME);
        }

        public function playPlatform():String
        {
            return (WEB_PLAY_PLATFORM_NAME);
        }

        public function getEntryTag():String
        {
            return (((this.entryTag) || ("")));
        }

        public function getSecret():String
        {
            return ("");
        }

        public function verify(_arg1:Boolean):void
        {
            this.isVerifiedEmail = _arg1;
        }

        public function isVerified():Boolean
        {
            return (this.isVerifiedEmail);
        }

        public function getPlatformToken():String
        {
            return (((this.platformToken) || ("")));
        }

        public function setPlatformToken(_arg1:String):void
        {
            this.platformToken = _arg1;
        }

        public function getMoneyAccessToken():String
        {
            return (this.signedRequest);
        }

        public function getMoneyUserId():String
        {
            return (this.kabamId);
        }
    }
}

