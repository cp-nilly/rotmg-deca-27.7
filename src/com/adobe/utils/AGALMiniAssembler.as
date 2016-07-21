package com.adobe.utils
{
    import flash.utils.Dictionary;
    import flash.utils.ByteArray;
    import flash.utils.getTimer;
    import flash.utils.Endian;
    import flash.utils.*;

    public class AGALMiniAssembler 
    {

        private static const OPMAP:Dictionary = new Dictionary();
        private static const REGMAP:Dictionary = new Dictionary();
        private static const SAMPLEMAP:Dictionary = new Dictionary();
        private static const MAX_NESTING:int = 4;
        private static const MAX_OPCODES:int = 0x0100;
        private static const FRAGMENT:String = "fragment";
        private static const VERTEX:String = "vertex";
        private static const SAMPLER_DIM_SHIFT:uint = 12;
        private static const SAMPLER_SPECIAL_SHIFT:uint = 16;
        private static const SAMPLER_REPEAT_SHIFT:uint = 20;
        private static const SAMPLER_MIPMAP_SHIFT:uint = 24;
        private static const SAMPLER_FILTER_SHIFT:uint = 28;
        private static const REG_WRITE:uint = 1;
        private static const REG_READ:uint = 2;
        private static const REG_FRAG:uint = 32;
        private static const REG_VERT:uint = 64;
        private static const OP_SCALAR:uint = 1;
        private static const OP_INC_NEST:uint = 2;
        private static const OP_DEC_NEST:uint = 4;
        private static const OP_SPECIAL_TEX:uint = 8;
        private static const OP_SPECIAL_MATRIX:uint = 16;
        private static const OP_FRAG_ONLY:uint = 32;
        private static const OP_VERT_ONLY:uint = 64;
        private static const OP_NO_DEST:uint = 128;
        private static const MOV:String = "mov";
        private static const ADD:String = "add";
        private static const SUB:String = "sub";
        private static const MUL:String = "mul";
        private static const DIV:String = "div";
        private static const RCP:String = "rcp";
        private static const MIN:String = "min";
        private static const MAX:String = "max";
        private static const FRC:String = "frc";
        private static const SQT:String = "sqt";
        private static const RSQ:String = "rsq";
        private static const POW:String = "pow";
        private static const LOG:String = "log";
        private static const EXP:String = "exp";
        private static const NRM:String = "nrm";
        private static const SIN:String = "sin";
        private static const COS:String = "cos";
        private static const CRS:String = "crs";
        private static const DP3:String = "dp3";
        private static const DP4:String = "dp4";
        private static const ABS:String = "abs";
        private static const NEG:String = "neg";
        private static const SAT:String = "sat";
        private static const M33:String = "m33";
        private static const M44:String = "m44";
        private static const M34:String = "m34";
        private static const IFZ:String = "ifz";
        private static const INZ:String = "inz";
        private static const IFE:String = "ife";
        private static const INE:String = "ine";
        private static const IFG:String = "ifg";
        private static const IFL:String = "ifl";
        private static const IEG:String = "ieg";
        private static const IEL:String = "iel";
        private static const ELS:String = "els";
        private static const EIF:String = "eif";
        private static const REP:String = "rep";
        private static const ERP:String = "erp";
        private static const BRK:String = "brk";
        private static const KIL:String = "kil";
        private static const TEX:String = "tex";
        private static const SGE:String = "sge";
        private static const SLT:String = "slt";
        private static const SGN:String = "sgn";
        private static const VA:String = "va";
        private static const VC:String = "vc";
        private static const VT:String = "vt";
        private static const OP:String = "op";
        private static const V:String = "v";
        private static const FC:String = "fc";
        private static const FT:String = "ft";
        private static const FS:String = "fs";
        private static const OC:String = "oc";
        private static const D2:String = "2d";
        private static const D3:String = "3d";
        private static const CUBE:String = "cube";
        private static const MIPNEAREST:String = "mipnearest";
        private static const MIPLINEAR:String = "miplinear";
        private static const MIPNONE:String = "mipnone";
        private static const NOMIP:String = "nomip";
        private static const NEAREST:String = "nearest";
        private static const LINEAR:String = "linear";
        private static const CENTROID:String = "centroid";
        private static const SINGLE:String = "single";
        private static const DEPTH:String = "depth";
        private static const REPEAT:String = "repeat";
        private static const WRAP:String = "wrap";
        private static const CLAMP:String = "clamp";

        private static var initialized:Boolean = false;

        private var _agalcode:ByteArray = null;
        private var _error:String = "";
        private var debugEnabled:Boolean = false;

        public function AGALMiniAssembler(_arg1:Boolean=false):void
        {
            this.debugEnabled = _arg1;
            if (!initialized)
            {
                init();
            };
        }

        private static function init():void
        {
            initialized = true;
            OPMAP[MOV] = new OpCode(MOV, 2, 0, 0);
            OPMAP[ADD] = new OpCode(ADD, 3, 1, 0);
            OPMAP[SUB] = new OpCode(SUB, 3, 2, 0);
            OPMAP[MUL] = new OpCode(MUL, 3, 3, 0);
            OPMAP[DIV] = new OpCode(DIV, 3, 4, 0);
            OPMAP[RCP] = new OpCode(RCP, 2, 5, 0);
            OPMAP[MIN] = new OpCode(MIN, 3, 6, 0);
            OPMAP[MAX] = new OpCode(MAX, 3, 7, 0);
            OPMAP[FRC] = new OpCode(FRC, 2, 8, 0);
            OPMAP[SQT] = new OpCode(SQT, 2, 9, 0);
            OPMAP[RSQ] = new OpCode(RSQ, 2, 10, 0);
            OPMAP[POW] = new OpCode(POW, 3, 11, 0);
            OPMAP[LOG] = new OpCode(LOG, 2, 12, 0);
            OPMAP[EXP] = new OpCode(EXP, 2, 13, 0);
            OPMAP[NRM] = new OpCode(NRM, 2, 14, 0);
            OPMAP[SIN] = new OpCode(SIN, 2, 15, 0);
            OPMAP[COS] = new OpCode(COS, 2, 16, 0);
            OPMAP[CRS] = new OpCode(CRS, 3, 17, 0);
            OPMAP[DP3] = new OpCode(DP3, 3, 18, 0);
            OPMAP[DP4] = new OpCode(DP4, 3, 19, 0);
            OPMAP[ABS] = new OpCode(ABS, 2, 20, 0);
            OPMAP[NEG] = new OpCode(NEG, 2, 21, 0);
            OPMAP[SAT] = new OpCode(SAT, 2, 22, 0);
            OPMAP[M33] = new OpCode(M33, 3, 23, OP_SPECIAL_MATRIX);
            OPMAP[M44] = new OpCode(M44, 3, 24, OP_SPECIAL_MATRIX);
            OPMAP[M34] = new OpCode(M34, 3, 25, OP_SPECIAL_MATRIX);
            OPMAP[IFZ] = new OpCode(IFZ, 1, 26, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[INZ] = new OpCode(INZ, 1, 27, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[IFE] = new OpCode(IFE, 2, 28, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[INE] = new OpCode(INE, 2, 29, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[IFG] = new OpCode(IFG, 2, 30, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[IFL] = new OpCode(IFL, 2, 31, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[IEG] = new OpCode(IEG, 2, 32, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[IEL] = new OpCode(IEL, 2, 33, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[ELS] = new OpCode(ELS, 0, 34, ((OP_NO_DEST | OP_INC_NEST) | OP_DEC_NEST));
            OPMAP[EIF] = new OpCode(EIF, 0, 35, (OP_NO_DEST | OP_DEC_NEST));
            OPMAP[REP] = new OpCode(REP, 1, 36, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[ERP] = new OpCode(ERP, 0, 37, (OP_NO_DEST | OP_DEC_NEST));
            OPMAP[BRK] = new OpCode(BRK, 0, 38, OP_NO_DEST);
            OPMAP[KIL] = new OpCode(KIL, 1, 39, (OP_NO_DEST | OP_FRAG_ONLY));
            OPMAP[TEX] = new OpCode(TEX, 3, 40, (OP_FRAG_ONLY | OP_SPECIAL_TEX));
            OPMAP[SGE] = new OpCode(SGE, 3, 41, 0);
            OPMAP[SLT] = new OpCode(SLT, 3, 42, 0);
            OPMAP[SGN] = new OpCode(SGN, 2, 43, 0);
            REGMAP[VA] = new Register(VA, "vertex attribute", 0, 7, (REG_VERT | REG_READ));
            REGMAP[VC] = new Register(VC, "vertex constant", 1, 127, (REG_VERT | REG_READ));
            REGMAP[VT] = new Register(VT, "vertex temporary", 2, 7, ((REG_VERT | REG_WRITE) | REG_READ));
            REGMAP[OP] = new Register(OP, "vertex output", 3, 0, (REG_VERT | REG_WRITE));
            REGMAP[V] = new Register(V, "varying", 4, 7, (((REG_VERT | REG_FRAG) | REG_READ) | REG_WRITE));
            REGMAP[FC] = new Register(FC, "fragment constant", 1, 27, (REG_FRAG | REG_READ));
            REGMAP[FT] = new Register(FT, "fragment temporary", 2, 7, ((REG_FRAG | REG_WRITE) | REG_READ));
            REGMAP[FS] = new Register(FS, "texture sampler", 5, 7, (REG_FRAG | REG_READ));
            REGMAP[OC] = new Register(OC, "fragment output", 3, 0, (REG_FRAG | REG_WRITE));
            SAMPLEMAP[D2] = new Sampler(D2, SAMPLER_DIM_SHIFT, 0);
            SAMPLEMAP[D3] = new Sampler(D3, SAMPLER_DIM_SHIFT, 2);
            SAMPLEMAP[CUBE] = new Sampler(CUBE, SAMPLER_DIM_SHIFT, 1);
            SAMPLEMAP[MIPNEAREST] = new Sampler(MIPNEAREST, SAMPLER_MIPMAP_SHIFT, 1);
            SAMPLEMAP[MIPLINEAR] = new Sampler(MIPLINEAR, SAMPLER_MIPMAP_SHIFT, 2);
            SAMPLEMAP[MIPNONE] = new Sampler(MIPNONE, SAMPLER_MIPMAP_SHIFT, 0);
            SAMPLEMAP[NOMIP] = new Sampler(NOMIP, SAMPLER_MIPMAP_SHIFT, 0);
            SAMPLEMAP[NEAREST] = new Sampler(NEAREST, SAMPLER_FILTER_SHIFT, 0);
            SAMPLEMAP[LINEAR] = new Sampler(LINEAR, SAMPLER_FILTER_SHIFT, 1);
            SAMPLEMAP[CENTROID] = new Sampler(CENTROID, SAMPLER_SPECIAL_SHIFT, (1 << 0));
            SAMPLEMAP[SINGLE] = new Sampler(SINGLE, SAMPLER_SPECIAL_SHIFT, (1 << 1));
            SAMPLEMAP[DEPTH] = new Sampler(DEPTH, SAMPLER_SPECIAL_SHIFT, (1 << 2));
            SAMPLEMAP[REPEAT] = new Sampler(REPEAT, SAMPLER_REPEAT_SHIFT, 1);
            SAMPLEMAP[WRAP] = new Sampler(WRAP, SAMPLER_REPEAT_SHIFT, 1);
            SAMPLEMAP[CLAMP] = new Sampler(CLAMP, SAMPLER_REPEAT_SHIFT, 0);
        }


        public function get error():String
        {
            return (this._error);
        }

        public function get agalcode():ByteArray
        {
            return (this._agalcode);
        }

        public function assemble(_arg1:String, _arg2:String, _arg3:Boolean=false):ByteArray
        {
            var _local9:int;
            var _local11:String;
            var _local12:int;
            var _local13:int;
            var _local14:Array;
            var _local15:Array;
            var _local16:OpCode;
            var _local17:Array;
            var _local18:Boolean;
            var _local19:uint;
            var _local20:uint;
            var _local21:int;
            var _local22:Boolean;
            var _local23:Array;
            var _local24:Array;
            var _local25:Register;
            var _local26:Array;
            var _local27:uint;
            var _local28:uint;
            var _local29:Array;
            var _local30:Boolean;
            var _local31:Boolean;
            var _local32:uint;
            var _local33:uint;
            var _local34:int;
            var _local35:uint;
            var _local36:uint;
            var _local37:int;
            var _local38:Array;
            var _local39:Register;
            var _local40:Array;
            var _local41:Array;
            var _local42:uint;
            var _local43:uint;
            var _local44:Number;
            var _local45:Sampler;
            var _local46:String;
            var _local47:uint;
            var _local48:uint;
            var _local49:String;
            var _local4:uint = getTimer();
            this._agalcode = new ByteArray();
            this._error = "";
            var _local5:Boolean;
            if (_arg1 == FRAGMENT)
            {
                _local5 = true;
            }
            else
            {
                if (_arg1 != VERTEX)
                {
                    this._error = (((((('ERROR: mode needs to be "' + FRAGMENT) + '" or "') + VERTEX) + '" but is "') + _arg1) + '".');
                };
            };
            this.agalcode.endian = Endian.LITTLE_ENDIAN;
            this.agalcode.writeByte(160);
            this.agalcode.writeUnsignedInt(1);
            this.agalcode.writeByte(161);
            this.agalcode.writeByte(((_local5) ? 1 : 0));
            var _local6:Array = _arg2.replace(/[\f\n\r\v]+/g, "\n").split("\n");
            var _local7:int;
            var _local8:int;
            var _local10:int = _local6.length;
            _local9 = 0;
            while ((((_local9 < _local10)) && ((this._error == ""))))
            {
                _local11 = new String(_local6[_local9]);
                _local12 = _local11.search("//");
                if (_local12 != -1)
                {
                    _local11 = _local11.slice(0, _local12);
                };
                _local13 = _local11.search(/<.*>/g);
                if (_local13 != -1)
                {
                    _local14 = _local11.slice(_local13).match(/([\w\.\-\+]+)/gi);
                    _local11 = _local11.slice(0, _local13);
                };
                _local15 = _local11.match(/^\w{3}/ig);
                _local16 = OPMAP[_local15[0]];
                if (this.debugEnabled)
                {
                    trace(_local16);
                };
                if (_local16 == null)
                {
                    if (_local11.length >= 3)
                    {
                        trace(((("warning: bad line " + _local9) + ": ") + _local6[_local9]));
                    };
                }
                else
                {
                    _local11 = _local11.slice((_local11.search(_local16.name) + _local16.name.length));
                    if ((_local16.flags & OP_DEC_NEST))
                    {
                        if (--_local7 < 0)
                        {
                            this._error = "error: conditional closes without open.";
                            break;
                        };
                    };
                    if ((_local16.flags & OP_INC_NEST))
                    {
                        if (++_local7 > MAX_NESTING)
                        {
                            this._error = (("error: nesting to deep, maximum allowed is " + MAX_NESTING) + ".");
                            break;
                        };
                    };
                    if ((((_local16.flags & OP_FRAG_ONLY)) && (!(_local5))))
                    {
                        this._error = "error: opcode is only allowed in fragment programs.";
                        break;
                    };
                    if (_arg3)
                    {
                        trace(("emit opcode=" + _local16));
                    };
                    this.agalcode.writeUnsignedInt(_local16.emitCode);
                    if (++_local8 > MAX_OPCODES)
                    {
                        this._error = (("error: too many opcodes. maximum is " + MAX_OPCODES) + ".");
                        break;
                    };
                    _local17 = _local11.match(/vc\[([vof][actps]?)(\d*)?(\.[xyzw](\+\d{1,3})?)?\](\.[xyzw]{1,4})?|([vof][actps]?)(\d*)?(\.[xyzw]{1,4})?/gi);
                    if (_local17.length != _local16.numRegister)
                    {
                        this._error = (((("error: wrong number of operands. found " + _local17.length) + " but expected ") + _local16.numRegister) + ".");
                        break;
                    };
                    _local18 = false;
                    _local19 = ((64 + 64) + 32);
                    _local20 = _local17.length;
                    _local21 = 0;
                    while (_local21 < _local20)
                    {
                        _local22 = false;
                        _local23 = _local17[_local21].match(/\[.*\]/ig);
                        if (_local23.length > 0)
                        {
                            _local17[_local21] = _local17[_local21].replace(_local23[0], "0");
                            if (_arg3)
                            {
                                trace("IS REL");
                            };
                            _local22 = true;
                        };
                        _local24 = _local17[_local21].match(/^\b[A-Za-z]{1,2}/ig);
                        _local25 = REGMAP[_local24[0]];
                        if (this.debugEnabled)
                        {
                            trace(_local25);
                        };
                        if (_local25 == null)
                        {
                            this._error = (((("error: could not parse operand " + _local21) + " (") + _local17[_local21]) + ").");
                            _local18 = true;
                            break;
                        };
                        if (_local5)
                        {
                            if (!(_local25.flags & REG_FRAG))
                            {
                                this._error = (((("error: register operand " + _local21) + " (") + _local17[_local21]) + ") only allowed in vertex programs.");
                                _local18 = true;
                                break;
                            };
                            if (_local22)
                            {
                                this._error = (((("error: register operand " + _local21) + " (") + _local17[_local21]) + ") relative adressing not allowed in fragment programs.");
                                _local18 = true;
                                break;
                            };
                        }
                        else
                        {
                            if (!(_local25.flags & REG_VERT))
                            {
                                this._error = (((("error: register operand " + _local21) + " (") + _local17[_local21]) + ") only allowed in fragment programs.");
                                _local18 = true;
                                break;
                            };
                        };
                        _local17[_local21] = _local17[_local21].slice((_local17[_local21].search(_local25.name) + _local25.name.length));
                        _local26 = ((_local22) ? _local23[0].match(/\d+/) : _local17[_local21].match(/\d+/));
                        _local27 = 0;
                        if (_local26)
                        {
                            _local27 = uint(_local26[0]);
                        };
                        if (_local25.range < _local27)
                        {
                            this._error = (((((("error: register operand " + _local21) + " (") + _local17[_local21]) + ") index exceeds limit of ") + (_local25.range + 1)) + ".");
                            _local18 = true;
                            break;
                        };
                        _local28 = 0;
                        _local29 = _local17[_local21].match(/(\.[xyzw]{1,4})/);
                        _local30 = (((_local21 == 0)) && (!((_local16.flags & OP_NO_DEST))));
                        _local31 = (((_local21 == 2)) && ((_local16.flags & OP_SPECIAL_TEX)));
                        _local32 = 0;
                        _local33 = 0;
                        _local34 = 0;
                        if (((_local30) && (_local22)))
                        {
                            this._error = "error: relative can not be destination";
                            _local18 = true;
                            break;
                        };
                        if (_local29)
                        {
                            _local28 = 0;
                            _local36 = _local29[0].length;
                            _local37 = 1;
                            while (_local37 < _local36)
                            {
                                _local35 = (_local29[0].charCodeAt(_local37) - "x".charCodeAt(0));
                                if (_local35 > 2)
                                {
                                    _local35 = 3;
                                };
                                if (_local30)
                                {
                                    _local28 = (_local28 | (1 << _local35));
                                }
                                else
                                {
                                    _local28 = (_local28 | (_local35 << ((_local37 - 1) << 1)));
                                };
                                _local37++;
                            };
                            if (!_local30)
                            {
                                while (_local37 <= 4)
                                {
                                    _local28 = (_local28 | (_local35 << ((_local37 - 1) << 1)));
                                    _local37++;
                                };
                            };
                        }
                        else
                        {
                            _local28 = ((_local30) ? 15 : 228);
                        };
                        if (_local22)
                        {
                            _local38 = _local23[0].match(/[A-Za-z]{1,2}/ig);
                            _local39 = REGMAP[_local38[0]];
                            if (_local39 == null)
                            {
                                this._error = "error: bad index register";
                                _local18 = true;
                                break;
                            };
                            _local32 = _local39.emitCode;
                            _local40 = _local23[0].match(/(\.[xyzw]{1,1})/);
                            if (_local40.length == 0)
                            {
                                this._error = "error: bad index register select";
                                _local18 = true;
                                break;
                            };
                            _local33 = (_local40[0].charCodeAt(1) - "x".charCodeAt(0));
                            if (_local33 > 2)
                            {
                                _local33 = 3;
                            };
                            _local41 = _local23[0].match(/\+\d{1,3}/ig);
                            if (_local41.length > 0)
                            {
                                _local34 = _local41[0];
                            };
                            if ((((_local34 < 0)) || ((_local34 > 0xFF))))
                            {
                                this._error = (("error: index offset " + _local34) + " out of bounds. [0..255]");
                                _local18 = true;
                                break;
                            };
                            if (_arg3)
                            {
                                trace(((((((((((("RELATIVE: type=" + _local32) + "==") + _local38[0]) + " sel=") + _local33) + "==") + _local40[0]) + " idx=") + _local27) + " offset=") + _local34));
                            };
                        };
                        if (_arg3)
                        {
                            trace((((((("  emit argcode=" + _local25) + "[") + _local27) + "][") + _local28) + "]"));
                        };
                        if (_local30)
                        {
                            this.agalcode.writeShort(_local27);
                            this.agalcode.writeByte(_local28);
                            this.agalcode.writeByte(_local25.emitCode);
                            _local19 = (_local19 - 32);
                        }
                        else
                        {
                            if (_local31)
                            {
                                if (_arg3)
                                {
                                    trace("  emit sampler");
                                };
                                _local42 = 5;
                                _local43 = _local14.length;
                                _local44 = 0;
                                _local37 = 0;
                                while (_local37 < _local43)
                                {
                                    if (_arg3)
                                    {
                                        trace(("    opt: " + _local14[_local37]));
                                    };
                                    _local45 = SAMPLEMAP[_local14[_local37]];
                                    if (_local45 == null)
                                    {
                                        _local44 = Number(_local14[_local37]);
                                        if (_arg3)
                                        {
                                            trace(("    bias: " + _local44));
                                        };
                                    }
                                    else
                                    {
                                        if (_local45.flag != SAMPLER_SPECIAL_SHIFT)
                                        {
                                            _local42 = (_local42 & ~((15 << _local45.flag)));
                                        };
                                        _local42 = (_local42 | (uint(_local45.mask) << uint(_local45.flag)));
                                    };
                                    _local37++;
                                };
                                this.agalcode.writeShort(_local27);
                                this.agalcode.writeByte(int((_local44 * 8)));
                                this.agalcode.writeByte(0);
                                this.agalcode.writeUnsignedInt(_local42);
                                if (_arg3)
                                {
                                    trace(("    bits: " + (_local42 - 5)));
                                };
                                _local19 = (_local19 - 64);
                            }
                            else
                            {
                                if (_local21 == 0)
                                {
                                    this.agalcode.writeUnsignedInt(0);
                                    _local19 = (_local19 - 32);
                                };
                                this.agalcode.writeShort(_local27);
                                this.agalcode.writeByte(_local34);
                                this.agalcode.writeByte(_local28);
                                this.agalcode.writeByte(_local25.emitCode);
                                this.agalcode.writeByte(_local32);
                                this.agalcode.writeShort(((_local22) ? (_local33 | (1 << 15)) : 0));
                                _local19 = (_local19 - 64);
                            };
                        };
                        _local21++;
                    };
                    _local21 = 0;
                    while (_local21 < _local19)
                    {
                        this.agalcode.writeByte(0);
                        _local21 = (_local21 + 8);
                    };
                    if (_local18) break;
                };
                _local9++;
            };
            if (this._error != "")
            {
                this._error = (this._error + ((("\n  at line " + _local9) + " ") + _local6[_local9]));
                this.agalcode.length = 0;
                trace(this._error);
            };
            if (this.debugEnabled)
            {
                _local46 = "generated bytecode:";
                _local47 = this.agalcode.length;
                _local48 = 0;
                while (_local48 < _local47)
                {
                    if (!(_local48 % 16))
                    {
                        _local46 = (_local46 + "\n");
                    };
                    if (!(_local48 % 4))
                    {
                        _local46 = (_local46 + " ");
                    };
                    _local49 = this.agalcode[_local48].toString(16);
                    if (_local49.length < 2)
                    {
                        _local49 = ("0" + _local49);
                    };
                    _local46 = (_local46 + _local49);
                    _local48++;
                };
                trace(_local46);
            };
            if (_arg3)
            {
                trace((("AGALMiniAssembler.assemble time: " + ((getTimer() - _local4) / 1000)) + "s"));
            };
            return (this.agalcode);
        }


    }
}

class OpCode 
{

    /*private*/ var _emitCode:uint;
    /*private*/ var _flags:uint;
    /*private*/ var _name:String;
    /*private*/ var _numRegister:uint;

    public function OpCode(_arg1:String, _arg2:uint, _arg3:uint, _arg4:uint)
    {
        this._name = _arg1;
        this._numRegister = _arg2;
        this._emitCode = _arg3;
        this._flags = _arg4;
    }

    public function get emitCode():uint
    {
        return (this._emitCode);
    }

    public function get flags():uint
    {
        return (this._flags);
    }

    public function get name():String
    {
        return (this._name);
    }

    public function get numRegister():uint
    {
        return (this._numRegister);
    }

    public function toString():String
    {
        return ((((((((('[OpCode name="' + this._name) + '", numRegister=') + this._numRegister) + ", emitCode=") + this._emitCode) + ", flags=") + this._flags) + "]"));
    }


}
class Register 
{

    /*private*/ var _emitCode:uint;
    /*private*/ var _name:String;
    /*private*/ var _longName:String;
    /*private*/ var _flags:uint;
    /*private*/ var _range:uint;

    public function Register(_arg1:String, _arg2:String, _arg3:uint, _arg4:uint, _arg5:uint)
    {
        this._name = _arg1;
        this._longName = _arg2;
        this._emitCode = _arg3;
        this._range = _arg4;
        this._flags = _arg5;
    }

    public function get emitCode():uint
    {
        return (this._emitCode);
    }

    public function get longName():String
    {
        return (this._longName);
    }

    public function get name():String
    {
        return (this._name);
    }

    public function get flags():uint
    {
        return (this._flags);
    }

    public function get range():uint
    {
        return (this._range);
    }

    public function toString():String
    {
        return ((((((((((('[Register name="' + this._name) + '", longName="') + this._longName) + '", emitCode=') + this._emitCode) + ", range=") + this._range) + ", flags=") + this._flags) + "]"));
    }


}
class Sampler 
{

    /*private*/ var _flag:uint;
    /*private*/ var _mask:uint;
    /*private*/ var _name:String;

    public function Sampler(_arg1:String, _arg2:uint, _arg3:uint)
    {
        this._name = _arg1;
        this._flag = _arg2;
        this._mask = _arg3;
    }

    public function get flag():uint
    {
        return (this._flag);
    }

    public function get mask():uint
    {
        return (this._mask);
    }

    public function get name():String
    {
        return (this._name);
    }

    public function toString():String
    {
        return ((((((('[Sampler name="' + this._name) + '", flag="') + this._flag) + '", mask=') + this.mask) + "]"));
    }


}

