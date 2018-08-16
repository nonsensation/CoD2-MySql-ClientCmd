

FindClientByEntityNumber( entityNum )
{
    players = getEntArray( "player" , "classname" );

    for( i = 0 ; i < players.size ; i++ )
    {
        p = players[ i ];

        if( isDefined( p ) && p getEntityNumber() == entityNum )
            return p;
    }

    return undefined;
}

FindClientByName( name )
{
    players = getEntArray( "player" , "classname" );

    for( i = 0 ; i < players.size ; i++ )
    {
        p = players[ i ];

        if( isDefined( p ) && p.name == name )
            return p;
    }

    for( i = 0 ; i < players.size ; i++ )
    {
        p = players[ i ];

        if( isDefined( p ) && isSubStr( p.name , name ) )
            return p;

        // TODO: cleanup player name
    }
    return undefined;
}