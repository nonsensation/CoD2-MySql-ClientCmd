
#include svr\util;
#include svr\mysql\mysql;
#include svr\mysql\mysql_util;
#include svr\mysql\mysql_query;


Init_Functions()
{
    wait( 1.0 );
    
    SqlCreateTable( "MetaData" , array(
        SqlCreateTableField( "Key" , "VARCHAR( 16 ) NOT NULL" ) ,
        SqlCreateTableField( "Val" , "VARCHAR( 1024 ) NOT NULL" )
    ) );

    SqlCreateTable( "Link" , array(
        SqlCreateTableField( "SourceId" , "INT UNSIGNED NOT NULL" ) ,
        SqlCreateTableField( "TargetId" , "INT UNSIGNED NOT NULL" ) ,
        SqlCreateTableField( "SourceType" , "VARCHAR( 16 ) NOT NULL" ) ,
        SqlCreateTableField( "Targetype" , "VARCHAR( 16 ) NOT NULL" ) 
    ) );
    
    SqlCreateTable( "Action" , array(
        SqlCreateTableField( "ActionType" , "VARCHAR( 16 ) NOT NULL" ) ,
        SqlCreateTableField( "ClientId" , "INT UNSIGNED" ) ,
        SqlCreateTableField( "Timestamp" , "DATETIME" ) 
    ) );

    SqlCreateTable( "IpAddress" , array(
        SqlCreateTableField( "Ip" , "VARCHAR( 16 ) NOT NULL UNIQUE" ) ,
        SqlCreateTableField( "ClientId" , "INT UNSIGNED" ) ,
        SqlCreateTableField( "IsBanned" , "BOOL NOT NULL"  )
    ) );

    SqlCreateTable( "NameAlias" , array(
        SqlCreateTableField( "Name" , "VARCHAR( 32 ) NOT NULL" ) ,
        SqlCreateTableField( "ClientId" , "INT UNSIGNED" ) 
    ) );

    SqlCreateTable( "Client" , array(
        SqlCreateTableField( "UserRight" , "INT UNSIGNED NOT NULL" ) ,
        SqlCreateTableField( "Username" , "VARCHAR( 32 ) NOT NULL" ) ,
        SqlCreateTableField( "Password" , "VARCHAR( 32 ) NOT NULL" )
    ) );

    level waittill( "connected" , player );

    player.pers[ "client_id" ] = 1;

    BanPlayer( player , player , "test" );
}

BanPlayer( admin , player , reason )
{
    // 1. Action
    // 2. IpAddress
    // 3. Link: Action <-> IpAddress
    // 3. MetaData's
    // 4. Link's: MetaData's <-> Action

    playerIp = player getIp();
    playerId = player.pers[ "client_id" ];

    if( !isDefined( playerId ) )
        playerId = level.sql_Null;

    lastActionIdName = "last_Action_Id";
    lastIpAddressIdName = "last_IpAddress_Id";
    lastMetaDataIdName = "last_MetaData_Id";

    q = SqlGenerateInsertQuery( "Action" , array( "ban" , admin.pers[ "client_id" ] , level.sql_CurTime ) ) +
        SqlGenerateSelectLastIdQuery( lastActionIdName );
    result = SqlWaittillResult( "Action" , q );
    lastActionIdName = result.rows[ 0 ][ lastActionIdName ];

    q = SqlGenerateInsertOrUpdateQuery( "IpAddress" , array( playerIp , playerId , true ) , lastIpAddressIdName );
    result = SqlWaittillResult( "IpAddress" , q );
    lastIpAddressId = result.rows[ 0 ][ lastIpAddressIdName ];

    q = SqlGenerateInsertQuery( "Link" , array( lastActionIdName , lastIpAddressId , "Action" , "IpAddress" ) );
    result = SqlWaittillResult( "Link" , q );

    metaDatas = array( 
        array( "reason1" , reason ) ,
        array( "reason2" , reason ) ,
        array( "reason3" , reason ) 
    );

    for( i = 0 ; i < metaDatas.size ; i++ )
    {
        q = SqlGenerateInsertQuery( "MetaData" , array( metaDatas[ i ][ 0 ] , metaDatas[ i ][ 1 ] ) , lastMetaDataIdName + i );
        result = SqlWaittillResult( "MetaData_" + i , q );
        lastIpAddressId = result.rows[ 0 ][ lastMetaDataIdName + i ];

        q = SqlGenerateInsertQuery( "Link" , array( lastActionIdName , lastIpAddressId , "Action" , "IpAddress" ) );
        result = SqlWaittillResult( "Link_" + i , q );
    }
}



