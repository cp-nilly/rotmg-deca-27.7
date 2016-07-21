package ion.utils.png
{
    import flash.utils.ByteArray;
    import flash.display.BitmapData;

    public class PNGDecoder 
    {

        private static const IHDR:int = 1229472850;
        private static const IDAT:int = 1229209940;
        private static const tEXt:int = 1950701684;
        private static const iTXt:int = 1767135348;
        private static const zTXt:int = 2052348020;
        private static const IEND:int = 1229278788;

        private static var infoWidth:uint;
        private static var infoHeight:uint;
        private static var infoBitDepth:int;
        private static var infoColourType:int;
        private static var infoCompressionMethod:int;
        private static var infoFilterMethod:int;
        private static var infoInterlaceMethod:int;
        private static var fileIn:ByteArray;
        private static var buffer:ByteArray;
        private static var scanline:int;
        private static var samples:int;


        public static function decodeImage(_arg1:ByteArray):BitmapData
        {
            var _local4:Boolean;
            var _local5:int;
            if (_arg1 == null)
            {
                return (null);
            };
            fileIn = _arg1;
            buffer = new ByteArray();
            samples = 4;
            fileIn.position = 0;
            if (fileIn.readUnsignedInt() != 2303741511)
            {
                return (invalidPNG());
            };
            if (fileIn.readUnsignedInt() != 218765834)
            {
                return (invalidPNG());
            };
            var _local2:Array = getChunks();
            var _local3:int;
            _local5 = 0;
            while (_local5 < _local2.length)
            {
                fileIn.position = _local2[_local5].position;
                _local4 = true;
                if (_local2[_local5].type == IHDR)
                {
                    _local3++;
                    if (_local5 == 0)
                    {
                        _local4 = processIHDR(_local2[_local5].length);
                    }
                    else
                    {
                        _local4 = false;
                    };
                };
                if (_local2[_local5].type == IDAT)
                {
                    buffer.writeBytes(fileIn, fileIn.position, _local2[_local5].length);
                };
                if (((!(_local4)) || ((_local3 > 1))))
                {
                    return (invalidPNG());
                };
                _local5++;
            };
            var _local6:BitmapData = processIDAT();
            fileIn = null;
            buffer = null;
            return (_local6);
        }

        public static function decodeInfo(_arg1:ByteArray):XML
        {
            var _local4:int;
            if (_arg1 == null)
            {
                return (null);
            };
            fileIn = _arg1;
            fileIn.position = 0;
            if (fileIn.readUnsignedInt() != 2303741511)
            {
                fileIn = null;
                return (null);
            };
            if (fileIn.readUnsignedInt() != 218765834)
            {
                fileIn = null;
                return (null);
            };
            var _local2:Array = getChunks();
            var _local3:XML = <information/>
            ;
            _local4 = 0;
            while (_local4 < _local2.length)
            {
                if (_local2[_local4].type == tEXt)
                {
                    _local3.appendChild(gettEXt(_local2[_local4].position, _local2[_local4].length));
                };
                if (_local2[_local4].type == iTXt)
                {
                    _local3.appendChild(getiTXt(_local2[_local4].position, _local2[_local4].length));
                };
                if (_local2[_local4].type == zTXt)
                {
                    _local3.appendChild(getzTXt(_local2[_local4].position, _local2[_local4].length));
                };
                _local4++;
            };
            fileIn = null;
            return (_local3);
        }

        private static function gettEXt(_arg1:int, _arg2:int):XML
        {
            var _local3:XML = <tEXt/>
            ;
            var _local4 = "";
            var _local5 = "";
            var _local6:int = -1;
            fileIn.position = _arg1;
            while (fileIn.position < (_arg1 + _arg2))
            {
                _local6 = fileIn.readUnsignedByte();
                if (_local6 > 0)
                {
                    _local4 = (_local4 + String.fromCharCode(_local6));
                }
                else
                {
                    break;
                };
            };
            _local5 = fileIn.readUTFBytes(((_arg1 + _arg2) - fileIn.position));
            _local3.appendChild(new (XML)((("<keyword>" + _local4) + "</keyword>")));
            _local3.appendChild(new (XML)((("<text>" + _local5) + "</text>")));
            return (_local3);
        }

        private static function getzTXt(_arg1:int, _arg2:int):XML
        {
            var _local8:ByteArray;
            var _local3:XML = <zTXt/>
            ;
            var _local4 = "";
            var _local5 = "";
            var _local6:int = -1;
            fileIn.position = _arg1;
            while (fileIn.position < (_arg1 + _arg2))
            {
                _local6 = fileIn.readUnsignedByte();
                if (_local6 > 0)
                {
                    _local4 = (_local4 + String.fromCharCode(_local6));
                }
                else
                {
                    break;
                };
            };
            var _local7:int = fileIn.readUnsignedByte();
            if (_local7 == 0)
            {
                _local8 = new ByteArray();
                _local8.writeBytes(fileIn, fileIn.position, ((_arg1 + _arg2) - fileIn.position));
                _local8.uncompress();
                _local5 = _local8.readUTFBytes(_local8.length);
            };
            _local3.appendChild(new (XML)((("<keyword>" + _local4) + "</keyword>")));
            _local3.appendChild(new (XML)((("<text>" + _local5) + "</text>")));
            return (_local3);
        }

        private static function getiTXt(_arg1:int, _arg2:int):XML
        {
            var _local11:ByteArray;
            var _local3:XML = <iTXt/>
            ;
            var _local4 = "";
            var _local5 = "";
            var _local6 = "";
            var _local7 = "";
            var _local8:int = -1;
            fileIn.position = _arg1;
            while (fileIn.position < (_arg1 + _arg2))
            {
                _local8 = fileIn.readUnsignedByte();
                if (_local8 > 0)
                {
                    _local4 = (_local4 + String.fromCharCode(_local8));
                }
                else
                {
                    break;
                };
            };
            var _local9 = (fileIn.readUnsignedByte() == 1);
            var _local10:int = fileIn.readUnsignedByte();
            while (fileIn.position < (_arg1 + _arg2))
            {
                _local8 = fileIn.readUnsignedByte();
                if (_local8 > 0)
                {
                    _local5 = (_local5 + String.fromCharCode(_local8));
                }
                else
                {
                    break;
                };
            };
            while (fileIn.position < (_arg1 + _arg2))
            {
                _local8 = fileIn.readUnsignedByte();
                if (_local8 > 0)
                {
                    _local6 = (_local6 + String.fromCharCode(_local8));
                }
                else
                {
                    break;
                };
            };
            if (_local9)
            {
                if (_local10 == 0)
                {
                    _local11 = new ByteArray();
                    _local11.writeBytes(fileIn, fileIn.position, ((_arg1 + _arg2) - fileIn.position));
                    _local11.uncompress();
                    _local7 = _local11.readUTFBytes(_local11.length);
                };
            }
            else
            {
                _local7 = fileIn.readUTFBytes(((_arg1 + _arg2) - fileIn.position));
            };
            _local3.appendChild(new (XML)((("<keyword>" + _local4) + "</keyword>")));
            _local3.appendChild(new (XML)((("<text>" + _local7) + "</text>")));
            _local3.appendChild(new (XML)((("<languageTag>" + _local5) + "</languageTag>")));
            _local3.appendChild(new (XML)((("<translatedKeyword>" + _local6) + "</translatedKeyword>")));
            return (_local3);
        }

        private static function invalidPNG():BitmapData
        {
            fileIn = null;
            buffer = null;
            return (null);
        }

        private static function getChunks():Array
        {
            var _local2:uint;
            var _local3:int;
            var _local1:Array = [];
            do 
            {
                _local2 = fileIn.readUnsignedInt();
                _local3 = fileIn.readInt();
                _local1.push({
                    "type":_local3,
                    "position":fileIn.position,
                    "length":_local2
                });
                fileIn.position = (fileIn.position + (_local2 + 4));
            } while (((!((_local3 == IEND))) && ((fileIn.bytesAvailable > 0))));
            return (_local1);
        }

        private static function processIHDR(_arg1:int):Boolean
        {
            if (_arg1 != 13)
            {
                return (false);
            };
            infoWidth = fileIn.readUnsignedInt();
            infoHeight = fileIn.readUnsignedInt();
            infoBitDepth = fileIn.readUnsignedByte();
            infoColourType = fileIn.readUnsignedByte();
            infoCompressionMethod = fileIn.readUnsignedByte();
            infoFilterMethod = fileIn.readUnsignedByte();
            infoInterlaceMethod = fileIn.readUnsignedByte();
            if ((((infoWidth <= 0)) || ((infoHeight <= 0))))
            {
                return (false);
            };
            switch (infoBitDepth)
            {
                case 1:
                case 2:
                case 4:
                case 8:
                case 16:
                    break;
                default:
                    return (false);
            };
            switch (infoColourType)
            {
                case 0:
                    if (((((((((!((infoBitDepth == 1))) && (!((infoBitDepth == 2))))) && (!((infoBitDepth == 4))))) && (!((infoBitDepth == 8))))) && (!((infoBitDepth == 16)))))
                    {
                        return (false);
                    };
                    break;
                case 2:
                case 4:
                case 6:
                    if (((!((infoBitDepth == 8))) && (!((infoBitDepth == 16)))))
                    {
                        return (false);
                    };
                    break;
                case 3:
                    if (((((((!((infoBitDepth == 1))) && (!((infoBitDepth == 2))))) && (!((infoBitDepth == 4))))) && (!((infoBitDepth == 8)))))
                    {
                        return (false);
                    };
                    break;
                default:
                    return (false);
            };
            if (((!((infoCompressionMethod == 0))) || (!((infoFilterMethod == 0)))))
            {
                return (false);
            };
            if (((!((infoInterlaceMethod == 0))) && (!((infoInterlaceMethod == 1)))))
            {
                return (false);
            };
            return (true);
        }

        private static function processIDAT():BitmapData
        {
            var bufferLen:uint;
            var filter:int;
            var i:int;
            var r:uint;
            var g:uint;
            var b:uint;
            var a:uint;
            var bd:BitmapData = new BitmapData(infoWidth, infoHeight);
            try
            {
                buffer.uncompress();
            }
            catch(err)
            {
                return (null);
            };
            scanline = 0;
            bufferLen = buffer.length;
            while (buffer.position < bufferLen)
            {
                filter = buffer.readUnsignedByte();
                if (filter == 0)
                {
                    i = 0;
                    while (i < infoWidth)
                    {
                        r = (noSample() << 16);
                        g = (noSample() << 8);
                        b = noSample();
                        a = (noSample() << 24);
                        bd.setPixel32(i, scanline, (((a + r) + g) + b));
                        i = (i + 1);
                    };
                }
                else
                {
                    if (filter == 1)
                    {
                        i = 0;
                        while (i < infoWidth)
                        {
                            r = (subSample() << 16);
                            g = (subSample() << 8);
                            b = subSample();
                            a = (subSample() << 24);
                            bd.setPixel32(i, scanline, (((a + r) + g) + b));
                            i = (i + 1);
                        };
                    }
                    else
                    {
                        if (filter == 2)
                        {
                            i = 0;
                            while (i < infoWidth)
                            {
                                r = (upSample() << 16);
                                g = (upSample() << 8);
                                b = upSample();
                                a = (upSample() << 24);
                                bd.setPixel32(i, scanline, (((a + r) + g) + b));
                                i = (i + 1);
                            };
                        }
                        else
                        {
                            if (filter == 3)
                            {
                                i = 0;
                                while (i < infoWidth)
                                {
                                    r = (averageSample() << 16);
                                    g = (averageSample() << 8);
                                    b = averageSample();
                                    a = (averageSample() << 24);
                                    bd.setPixel32(i, scanline, (((a + r) + g) + b));
                                    i = (i + 1);
                                };
                            }
                            else
                            {
                                if (filter == 4)
                                {
                                    i = 0;
                                    while (i < infoWidth)
                                    {
                                        r = (paethSample() << 16);
                                        g = (paethSample() << 8);
                                        b = paethSample();
                                        a = (paethSample() << 24);
                                        bd.setPixel32(i, scanline, (((a + r) + g) + b));
                                        i = (i + 1);
                                    };
                                }
                                else
                                {
                                    buffer.position = (buffer.position + (samples * infoWidth));
                                };
                            };
                        };
                    };
                };
                scanline++;
            };
            return (bd);
        }

        private static function noSample():uint
        {
            return (buffer[buffer.position++]);
        }

        private static function subSample():uint
        {
            var _local1:uint = (buffer[buffer.position] + byteA());
            _local1 = (_local1 & 0xFF);
            var _local2 = buffer.position++;
            buffer[_local2] = _local1;
            return (_local1);
        }

        private static function upSample():uint
        {
            var _local1:uint = (buffer[buffer.position] + byteB());
            _local1 = (_local1 & 0xFF);
            var _local2 = buffer.position++;
            buffer[_local2] = _local1;
            return (_local1);
        }

        private static function averageSample():uint
        {
            var _local1:uint = (buffer[buffer.position] + Math.floor(((byteA() + byteB()) / 2)));
            _local1 = (_local1 & 0xFF);
            var _local2 = buffer.position++;
            buffer[_local2] = _local1;
            return (_local1);
        }

        private static function paethSample():uint
        {
            var _local1:uint = (buffer[buffer.position] + paethPredictor());
            _local1 = (_local1 & 0xFF);
            var _local2 = buffer.position++;
            buffer[_local2] = _local1;
            return (_local1);
        }

        private static function paethPredictor():uint
        {
            var _local1:uint = byteA();
            var _local2:uint = byteB();
            var _local3:uint = byteC();
            var _local4:int;
            var _local5:int;
            var _local6:int;
            var _local7:int;
            var _local8:int;
            _local4 = ((_local1 + _local2) - _local3);
            _local5 = Math.abs((_local4 - _local1));
            _local6 = Math.abs((_local4 - _local2));
            _local7 = Math.abs((_local4 - _local3));
            if ((((_local5 <= _local6)) && ((_local5 <= _local7))))
            {
                _local8 = _local1;
            }
            else
            {
                if (_local6 <= _local7)
                {
                    _local8 = _local2;
                }
                else
                {
                    _local8 = _local3;
                };
            };
            return (_local8);
        }

        private static function byteA():uint
        {
            var _local1:int = (scanline * ((infoWidth * samples) + 1));
            var _local2:int = (buffer.position - samples);
            if (_local2 <= _local1)
            {
                return (0);
            };
            return (buffer[_local2]);
        }

        private static function byteB():uint
        {
            var _local1:int = (buffer.position - ((infoWidth * samples) + 1));
            if (_local1 < 0)
            {
                return (0);
            };
            return (buffer[_local1]);
        }

        private static function byteC():uint
        {
            var _local1:int = (buffer.position - ((infoWidth * samples) + 1));
            if (_local1 < 0)
            {
                return (0);
            };
            var _local2:int = ((scanline - 1) * ((infoWidth * samples) + 1));
            _local1 = (_local1 - samples);
            if (_local1 <= _local2)
            {
                return (0);
            };
            return (buffer[_local1]);
        }


    }
}

