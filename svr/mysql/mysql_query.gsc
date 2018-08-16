
#include svr\util;
#include svr\mysql\mysql;
#include svr\mysql\mysql_util;


SqlCreateTable( tableName , tableFields )
{
    SqlRegisterTable( tableName , tableFields );

    fields = "";

    for( i = 0 ; i < tableFields.size ; i++ )
    {
        field = tableFields[ i ];

        fields += SqlKey( field.name ) + " " + field.type + " , ";
    }

    q = "CREATE TABLE IF NOT EXISTS " + SqlKey( tableName ) + " (" + fields + SqlKey( "Id" ) + " INT UNSIGNED AUTO_INCREMENT PRIMARY KEY )";

    level notify( "sql_query" , tableName , q );

    waittillframeend;
}

SqlRegisterTable( tableName , tableFields )
{
    table = spawnStruct();
    table.id = level.sql_tables.size;
    table.fieldNames = [];

    for( i = 0 ; i < tableFields.size ; i++ )
    {
        table.fieldNames[ table.fieldNames.size ] = tableFields[ i ].name;
    }

    level.sql_table[ tableName ] = table;
    level.sql_tables[ table.id ] = tableName;
}

SqlCreateTableField( fieldName , fieldType )
{
    field = spawnStruct();
    field.name = fieldName;
    field.type = fieldType;

    return field;
}

SqlGenerateInsertQuery( tableName , values , lastIdName )
{
    q = "INSERT INTO " + SqlKey( tableName ) + " " +
        SqlKeys( level.sql_table[ tableName ].fieldNames ) +
        " VALUES " + SqlValues( values );
        
    if( isDefined( lastIdName ) )
        q += ";SELECT LAST_INSERT_ID() AS " + SqlKey( lastIdName );
    
    return q;
}

SqlGenerateInsertOrUpdateQuery( tableName , values , lastIdName )
{
    q = "INSERT INTO " + SqlKey( tableName ) + " " +
        SqlKeys( level.sql_table[ tableName ].fieldNames ) +
        " VALUES " + SqlValues( values ) +
        "ON DUPLICATE KEY UPDATE " + SqlGenerateKeyValuesQuery( tableName , values );

    if( isDefined( lastIdName ) )
        q += " , " + SqlKey( "Id" ) + " = LAST_INSERT_ID( " + SqlKey( "Id" ) + " );" +
             "SELECT LAST_INSERT_ID() AS " + SqlKey( lastIdName );
    
    return q;
}

SqlGenerateUpdateSingleQuery( tableName , key , value )
{
    return "UPDATE  " + SqlKey( tableName ) + " SET " + SqlGenerateKeyValueQuery( key , value );
}

SqlGenerateUpdateQuery( tableName , values )
{
    return "UPDATE  " + SqlKey( tableName ) + " SET " + SqlGenerateKeyValuesQuery( tableName , values );
}

SqlGenerateKeyValuesQuery( tableName , values )
{
    q = "";

    for( i = 0 ; i < level.sql_table[ tableName ].fieldNames.size ; i++ )
    {
        q += SqlGenerateKeyValueQuery( level.sql_table[ tableName ].fieldNames[ i ] , values[ i ] );

        if( i < level.sql_table[ tableName ].fieldNames.size - 1 )
            q += " , ";
    }

    return q;
}

SqlGenerateKeyValueQuery( key , value )
{
    return SqlKey( key ) + " = " + SqlValue( value );
}
