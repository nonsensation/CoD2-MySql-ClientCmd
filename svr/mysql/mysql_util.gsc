
#include svr\util;



SqlAsyncBlank( invoker , rows , args )
{
    printf( "[SQL][BLANK_CALLBACK] " );

    if( isDefined( rows ) )
    {
        printf( "rows: " + rows.size );

        for( i = 0 ; i < rows.size ; i++ )
        {
            if( isDefined( rows[ i ] ) )
                printf( "row[" + i + "]: " + rows[ i ].size );
        }
    }
    
    printf( "\n" );
}

SqlArraySqlEscapeFunc( array , func , wrapInParens )
{
    vals = "";

    for( i = 0 ; i < array.size ; i++ )
    {
        vals += " " + [[func]]( array[ i ] ) + " ";

        if( i < array.size - 1 )
            vals += ",";
    }

    return " (" + vals + ") ";
}

SqlKeys( array , wrapInParens )
{
    return SqlArraySqlEscapeFunc( array , ::SqlKey , isDefined( wrapInParens ) && wrapInParens );
}

SqlValues( array , wrapInParens )
{
    return SqlArraySqlEscapeFunc( array , ::SqlValue , isDefined( wrapInParens ) && wrapInParens );
}

SqlEscape( value , escapeChar )
{
    if( isString( value ) && value[ 0 ] == level.sql_skipEscape )
        return getSubStr( value , 1 );
    else
        return escapeChar + value + escapeChar;
}

SqlKey( key )
{
    return "`" + key + "`";
}

SqlValue( value )
{
    return SqlEscape( value , "'" );
}

SqlPrintRows( rows , index , colName )
{
    text = "Check rows[" + index + "][" + colName + "]:\t";

    if( isDefined( rows ) )
        if( isDefined( rows[ index ] ) )
            if( isDefined( rows[ index ][ colName ] ) )
                text += "size: " + rows[ index ].size + " | " + colName + ": " + rows[ index ][ colName ];        
            else  
                text += "size: " + rows[ index ].size + " | " + colName + ": undefined";  
        else
            text += "rows[" + index + "] undefined";
    else
        text += "rows undefined";

    printf( text + "\n" );
}

SqlGetLastId( rows )
{
    return rows[ 0 ][ level.sql_lastId ];
}

SqlGenerateLastIdQuery( variableName )
{
    return "; SET " + variableName + " = LAST_INSERT_ID(); ";
}

SqlGenerateSelectLastIdQuery( variableName )
{
    escapedVariableName = SqlGenerateVariable( variableName );

    return "; SET " + escapedVariableName + " = LAST_INSERT_ID(); SELECT " + escapedVariableName + " AS " + variableName;
}

SqlGenerateVariable( variableName )
{
    return "@" + SqlKey( variableName );
}


SqlWaittillResult( identifier , query )
{
    if( !isDefined( level.sql_queryCount ) )
        level.sql_queryCount = 0;

    startTime = getTime();
    queryId = identifier + "_" + startTime + "_" + level.sql_queryCount;
    timeoutStr = "sql_resuld_timed_out_" + queryId;
    timeoutEndonStr = "sql_result_" + queryId;

    level thread SqlWaittillResultTimeout( 0.05 , timeoutStr , queryId );
    level endon( timeoutStr );

    level.sql_queryCount++;

    printf( "STARTTIME: " + startTime + "\n" );

    level notify( "sql_query" , queryId , query );

    while( true )
    {
        level waittill( "sql_result" , resultId , result );

        if( resultId != queryId )
            continue;

        level notify( timeoutEndonStr );

        stopTime = getTime();

        printf( "STOPTIME: " + stopTime + "\n" );
        printf( "DURATION: " + ( stopTime - startTime ) + "\n" );

        SqlPrintResult( result );

        return result;
    }
}

SqlWaittillResultTimeout( timeout , notifyStr , endonStr )
{
    level endon( endonStr );

    wait( timeout );

    printf( "SQL TIMEOUT: " + notifyStr + "\n" );

    level notify( notifyStr );
}

SqlPrintResult( result )
{
    for( i = 0 ; i < result.fields.size ; i++ )
    {
        printf( "Field[ " + i + " ] = " + result.fields[ i ] + "\n" );
    }

    for( i = 0 ; i < result.rows.size ; i++ )
    {
        row = result.rows[ i ];

        for( ii = 0 ; ii < result.fields.size ; ii++ )
        {
            field = result.fields[ ii ];

            printf( "Rows[ " + i + " ][ " + field + " ] = " + row[ field ] + "\n" );
        }
    }
}