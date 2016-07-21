package com.adobe.serialization.json
{
    public class JSONDecoder 
    {

        private var value;
        private var tokenizer:JSONTokenizer;
        private var token:JSONToken;

        public function JSONDecoder(_arg1:String)
        {
            this.tokenizer = new JSONTokenizer(_arg1);
            this.nextToken();
            this.value = this.parseValue();
        }

        public function getValue()
        {
            return (this.value);
        }

        private function nextToken():JSONToken
        {
            return ((this.token = this.tokenizer.getNextToken()));
        }

        private function parseArray():Array
        {
            var _local1:Array = new Array();
            this.nextToken();
            if (this.token.type == JSONTokenType.RIGHT_BRACKET)
            {
                return (_local1);
            };
            while (true)
            {
                _local1.push(this.parseValue());
                this.nextToken();
                if (this.token.type == JSONTokenType.RIGHT_BRACKET)
                {
                    return (_local1);
                };
                if (this.token.type == JSONTokenType.COMMA)
                {
                    this.nextToken();
                }
                else
                {
                    this.tokenizer.parseError(("Expecting ] or , but found " + this.token.value));
                };
            };
            return (null); //dead code
        }

        private function parseObject():Object
        {
            var _local2:String;
            var _local1:Object = new Object();
            this.nextToken();
            if (this.token.type == JSONTokenType.RIGHT_BRACE)
            {
                return (_local1);
            };
            while (true)
            {
                if (this.token.type == JSONTokenType.STRING)
                {
                    _local2 = String(this.token.value);
                    this.nextToken();
                    if (this.token.type == JSONTokenType.COLON)
                    {
                        this.nextToken();
                        _local1[_local2] = this.parseValue();
                        this.nextToken();
                        if (this.token.type == JSONTokenType.RIGHT_BRACE)
                        {
                            return (_local1);
                        };
                        if (this.token.type == JSONTokenType.COMMA)
                        {
                            this.nextToken();
                        }
                        else
                        {
                            this.tokenizer.parseError(("Expecting } or , but found " + this.token.value));
                        };
                    }
                    else
                    {
                        this.tokenizer.parseError(("Expecting : but found " + this.token.value));
                    };
                }
                else
                {
                    this.tokenizer.parseError(("Expecting string but found " + this.token.value));
                };
            };
            return (null); //dead code
        }

        private function parseValue():Object
        {
            if (this.token == null)
            {
                this.tokenizer.parseError("Unexpected end of input");
            };
            switch (this.token.type)
            {
                case JSONTokenType.LEFT_BRACE:
                    return (this.parseObject());
                case JSONTokenType.LEFT_BRACKET:
                    return (this.parseArray());
                case JSONTokenType.STRING:
                case JSONTokenType.NUMBER:
                case JSONTokenType.TRUE:
                case JSONTokenType.FALSE:
                case JSONTokenType.NULL:
                    return (this.token.value);
                default:
                    this.tokenizer.parseError(("Unexpected " + this.token.value));
            };
            return (null);
        }


    }
}

