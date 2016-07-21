package org.swiftsuspenders.dependencyproviders
{
    import org.swiftsuspenders.Injector;
    import flash.utils.Dictionary;

    public interface DependencyProvider 
    {

        function apply(_arg1:Class, _arg2:Injector, _arg3:Dictionary):Object;
        function destroy():void;

    }
}

