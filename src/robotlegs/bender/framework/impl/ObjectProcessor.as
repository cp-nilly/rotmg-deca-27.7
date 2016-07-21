package robotlegs.bender.framework.impl
{
    import org.hamcrest.Matcher;

    public class ObjectProcessor 
    {

        private const _handlers:Array = [];


        public function addObjectHandler(_arg1:Matcher, _arg2:Function):void
        {
            this._handlers.push(new ObjectHandler(_arg1, _arg2));
        }

        public function processObject(_arg1:Object):void
        {
            var _local2:ObjectHandler;
            for each (_local2 in this._handlers)
            {
                _local2.handle(_arg1);
            };
        }


    }
}

import org.hamcrest.Matcher;

class ObjectHandler 
{

    /*private*/ var _matcher:Matcher;
    /*private*/ var _handler:Function;

    public function ObjectHandler(_arg1:Matcher, _arg2:Function)
    {
        this._matcher = _arg1;
        this._handler = _arg2;
    }

    public function handle(_arg1:Object):void
    {
        ((this._matcher.matches(_arg1)) && (this._handler(_arg1)));
    }


}

