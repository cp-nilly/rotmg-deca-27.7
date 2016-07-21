package com.hurlant.util.der
{
    import flash.utils.ByteArray;
    import com.hurlant.crypto.rsa.RSAKey;
    import com.hurlant.util.Base64;

    public class PEM 
    {

        private static const RSA_PRIVATE_KEY_HEADER:String = "-----BEGIN RSA PRIVATE KEY-----";
        private static const RSA_PRIVATE_KEY_FOOTER:String = "-----END RSA PRIVATE KEY-----";
        private static const RSA_PUBLIC_KEY_HEADER:String = "-----BEGIN PUBLIC KEY-----";
        private static const RSA_PUBLIC_KEY_FOOTER:String = "-----END PUBLIC KEY-----";
        private static const CERTIFICATE_HEADER:String = "-----BEGIN CERTIFICATE-----";
        private static const CERTIFICATE_FOOTER:String = "-----END CERTIFICATE-----";


        public static function readRSAPrivateKey(_arg1:String):RSAKey
        {
            var _local4:Array;
            var _local2:ByteArray = extractBinary(RSA_PRIVATE_KEY_HEADER, RSA_PRIVATE_KEY_FOOTER, _arg1);
            if (_local2 == null)
            {
                return (null);
            };
            var _local3:* = DER.parse(_local2);
            if ((_local3 is Array))
            {
                _local4 = (_local3 as Array);
                return (new RSAKey(_local4[1], _local4[2].valueOf(), _local4[3], _local4[4], _local4[5], _local4[6], _local4[7], _local4[8]));
            };
            return (null);
        }

        public static function readRSAPublicKey(_arg1:String):RSAKey
        {
            var _local4:Array;
            var _local2:ByteArray = extractBinary(RSA_PUBLIC_KEY_HEADER, RSA_PUBLIC_KEY_FOOTER, _arg1);
            if (_local2 == null)
            {
                return (null);
            };
            var _local3:* = DER.parse(_local2);
            if ((_local3 is Array))
            {
                _local4 = (_local3 as Array);
                if (_local4[0][0].toString() != OID.RSA_ENCRYPTION)
                {
                    return (null);
                };
                if (_local4[1][_local4[1].position] == 0)
                {
                    _local4[1].position++;
                };
                _local3 = DER.parse(_local4[1]);
                if ((_local3 is Array))
                {
                    _local4 = (_local3 as Array);
                    return (new RSAKey(_local4[0], _local4[1]));
                };
                return (null);
            };
            return (null);
        }

        public static function readCertIntoArray(_arg1:String):ByteArray
        {
            return (extractBinary(CERTIFICATE_HEADER, CERTIFICATE_FOOTER, _arg1));
        }

        private static function extractBinary(_arg1:String, _arg2:String, _arg3:String):ByteArray
        {
            var _local4:int = _arg3.indexOf(_arg1);
            if (_local4 == -1)
            {
                return (null);
            };
            _local4 = (_local4 + _arg1.length);
            var _local5:int = _arg3.indexOf(_arg2);
            if (_local5 == -1)
            {
                return (null);
            };
            var _local6:String = _arg3.substring(_local4, _local5);
            _local6 = _local6.replace(/\s/mg, "");
            return (Base64.decodeToByteArray(_local6));
        }


    }
}

