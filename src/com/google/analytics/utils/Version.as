package com.google.analytics.utils
{
    public class Version 
    {

        private var _revision:uint;
        private var _maxBuild:uint = 0xFF;
        private var _maxMinor:uint = 15;
        private var _maxMajor:uint = 15;
        private var _separator:String = ".";
        private var _maxRevision:uint = 0xFFFF;
        private var _build:uint;
        private var _major:uint;
        private var _minor:uint;

        public function Version(_arg1:uint=0, _arg2:uint=0, _arg3:uint=0, _arg4:uint=0)
        {
            var _local5:Version;
            super();
            if ((((((((_arg1 > _maxMajor)) && ((_arg2 == 0)))) && ((_arg3 == 0)))) && ((_arg4 == 0))))
            {
                _local5 = Version.fromNumber(_arg1);
                _arg1 = _local5.major;
                _arg2 = _local5.minor;
                _arg3 = _local5.build;
                _arg4 = _local5.revision;
            };
            this.major = _arg1;
            this.minor = _arg2;
            this.build = _arg3;
            this.revision = _arg4;
        }

        public static function fromString(_arg1:String="", _arg2:String="."):Version
        {
            var _local4:Array;
            var _local3:Version = new (Version)();
            if ((((_arg1 == "")) || ((_arg1 == null))))
            {
                return (_local3);
            };
            if (_arg1.indexOf(_arg2) > -1)
            {
                _local4 = _arg1.split(_arg2);
                _local3.major = parseInt(_local4[0]);
                _local3.minor = parseInt(_local4[1]);
                _local3.build = parseInt(_local4[2]);
                _local3.revision = parseInt(_local4[3]);
            }
            else
            {
                _local3.major = parseInt(_arg1);
            };
            return (_local3);
        }

        public static function fromNumber(_arg1:Number=0):Version
        {
            var _local2:Version = new (Version)();
            if (((((((((((isNaN(_arg1)) || ((_arg1 == 0)))) || ((_arg1 < 0)))) || ((_arg1 == Number.MAX_VALUE)))) || ((_arg1 == Number.POSITIVE_INFINITY)))) || ((_arg1 == Number.NEGATIVE_INFINITY))))
            {
                return (_local2);
            };
            _local2.major = (_arg1 >>> 28);
            _local2.minor = ((_arg1 & 251658240) >>> 24);
            _local2.build = ((_arg1 & 0xFF0000) >>> 16);
            _local2.revision = (_arg1 & 0xFFFF);
            return (_local2);
        }


        public function toString(_arg1:int=0):String
        {
            var _local2:Array;
            if ((((_arg1 <= 0)) || ((_arg1 > 4))))
            {
                _arg1 = getFields();
            };
            switch (_arg1)
            {
                case 1:
                    _local2 = [major];
                    break;
                case 2:
                    _local2 = [major, minor];
                    break;
                case 3:
                    _local2 = [major, minor, build];
                    break;
                case 4:
                default:
                    _local2 = [major, minor, build, revision];
            };
            return (_local2.join(_separator));
        }

        public function set revision(_arg1:uint):void
        {
            _revision = Math.min(_arg1, _maxRevision);
        }

        public function get revision():uint
        {
            return (_revision);
        }

        public function set build(_arg1:uint):void
        {
            _build = Math.min(_arg1, _maxBuild);
        }

        public function set minor(_arg1:uint):void
        {
            _minor = Math.min(_arg1, _maxMinor);
        }

        public function get build():uint
        {
            return (_build);
        }

        public function set major(_arg1:uint):void
        {
            _major = Math.min(_arg1, _maxMajor);
        }

        public function get minor():uint
        {
            return (_minor);
        }

        private function getFields():int
        {
            var _local1:int = 4;
            if (revision == 0)
            {
                _local1--;
            };
            if ((((_local1 == 3)) && ((build == 0))))
            {
                _local1--;
            };
            if ((((_local1 == 2)) && ((minor == 0))))
            {
                _local1--;
            };
            return (_local1);
        }

        public function valueOf():uint
        {
            return (((((major << 28) | (minor << 24)) | (build << 16)) | revision));
        }

        public function get major():uint
        {
            return (_major);
        }

        public function equals(_arg1:*):Boolean
        {
            if (!(_arg1 is Version))
            {
                return (false);
            };
            if ((((((((_arg1.major == major)) && ((_arg1.minor == minor)))) && ((_arg1.build == build)))) && ((_arg1.revision == revision))))
            {
                return (true);
            };
            return (false);
        }


    }
}

