package com.google.analytics.core
{
    import com.google.analytics.utils.Variables;

    public class Organic 
    {

        public static var throwErrors:Boolean = false;

        private var _sourcesCache:Array;
        private var _sourcesEngine:Array;
        private var _ignoredKeywords:Array;
        private var _ignoredReferralsCache:Object;
        private var _ignoredReferrals:Array;
        private var _ignoredKeywordsCache:Object;
        private var _sources:Array;

        public function Organic()
        {
            _sources = [];
            _sourcesCache = [];
            _sourcesEngine = [];
            _ignoredReferrals = [];
            _ignoredReferralsCache = {};
            _ignoredKeywords = [];
            _ignoredKeywordsCache = {};
        }

        public static function getKeywordValueFromPath(_arg1:String, _arg2:String):String
        {
            var _local3:String;
            var _local4:Variables;
            if (_arg2.indexOf((_arg1 + "=")) > -1)
            {
                if (_arg2.charAt(0) == "?")
                {
                    _arg2 = _arg2.substr(1);
                };
                _arg2 = _arg2.split("+").join("%20");
                _local4 = new Variables(_arg2);
                _local3 = _local4[_arg1];
            };
            return (_local3);
        }


        public function isIgnoredKeyword(_arg1:String):Boolean
        {
            if (_ignoredKeywordsCache.hasOwnProperty(_arg1))
            {
                return (true);
            };
            return (false);
        }

        public function getKeywordValue(_arg1:OrganicReferrer, _arg2:String):String
        {
            var _local3:String = _arg1.keyword;
            return (getKeywordValueFromPath(_local3, _arg2));
        }

        public function isIgnoredReferral(_arg1:String):Boolean
        {
            if (_ignoredReferralsCache.hasOwnProperty(_arg1))
            {
                return (true);
            };
            return (false);
        }

        public function clear():void
        {
            clearEngines();
            clearIgnoredReferrals();
            clearIgnoredKeywords();
        }

        public function get count():int
        {
            return (_sources.length);
        }

        public function get ignoredKeywordsCount():int
        {
            return (_ignoredKeywords.length);
        }

        public function match(_arg1:String):Boolean
        {
            if (_arg1 == "")
            {
                return (false);
            };
            _arg1 = _arg1.toLowerCase();
            if (_sourcesEngine[_arg1] != undefined)
            {
                return (true);
            };
            return (false);
        }

        public function clearIgnoredKeywords():void
        {
            _ignoredKeywords = [];
            _ignoredKeywordsCache = {};
        }

        public function addSource(_arg1:String, _arg2:String):void
        {
            var _local3:OrganicReferrer = new OrganicReferrer(_arg1, _arg2);
            if (_sourcesCache[_local3.toString()] == undefined)
            {
                _sources.push(_local3);
                _sourcesCache[_local3.toString()] = (_sources.length - 1);
                if (_sourcesEngine[_local3.engine] == undefined)
                {
                    _sourcesEngine[_local3.engine] = [(_sources.length - 1)];
                }
                else
                {
                    _sourcesEngine[_local3.engine].push((_sources.length - 1));
                };
            }
            else
            {
                if (throwErrors)
                {
                    throw (new Error((_local3.toString() + " already exists, we don't add it.")));
                };
            };
        }

        public function clearEngines():void
        {
            _sources = [];
            _sourcesCache = [];
            _sourcesEngine = [];
        }

        public function get ignoredReferralsCount():int
        {
            return (_ignoredReferrals.length);
        }

        public function addIgnoredReferral(_arg1:String):void
        {
            if (_ignoredReferralsCache[_arg1] == undefined)
            {
                _ignoredReferrals.push(_arg1);
                _ignoredReferralsCache[_arg1] = (_ignoredReferrals.length - 1);
            }
            else
            {
                if (throwErrors)
                {
                    throw (new Error((('"' + _arg1) + "\" already exists, we don't add it.")));
                };
            };
        }

        public function clearIgnoredReferrals():void
        {
            _ignoredReferrals = [];
            _ignoredReferralsCache = {};
        }

        public function getReferrerByName(_arg1:String):OrganicReferrer
        {
            var _local2:int;
            if (match(_arg1))
            {
                _local2 = _sourcesEngine[_arg1][0];
                return (_sources[_local2]);
            };
            return (null);
        }

        public function addIgnoredKeyword(_arg1:String):void
        {
            if (_ignoredKeywordsCache[_arg1] == undefined)
            {
                _ignoredKeywords.push(_arg1);
                _ignoredKeywordsCache[_arg1] = (_ignoredKeywords.length - 1);
            }
            else
            {
                if (throwErrors)
                {
                    throw (new Error((('"' + _arg1) + "\" already exists, we don't add it.")));
                };
            };
        }

        public function get sources():Array
        {
            return (_sources);
        }


    }
}

