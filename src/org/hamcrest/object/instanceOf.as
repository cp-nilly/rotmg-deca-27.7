package org.hamcrest.object
{
    import org.hamcrest.Matcher;

    public function instanceOf(_arg1:Class):Matcher
    {
        return (new IsInstanceOfMatcher(_arg1));
    }

}

