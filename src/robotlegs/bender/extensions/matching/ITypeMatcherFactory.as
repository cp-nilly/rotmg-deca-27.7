package robotlegs.bender.extensions.matching
{
    public interface ITypeMatcherFactory extends ITypeMatcher 
    {

        function clone():TypeMatcher;

    }
}

