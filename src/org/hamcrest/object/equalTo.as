package org.hamcrest.object
{
    import org.hamcrest.Matcher;

    public function equalTo(_arg1:Object):Matcher
    {
        return (new IsEqualMatcher(_arg1));
    }

}

