Init()
{
    names = strTok( "time serverstime localtime t" , " " );

    svr\clientcmd\clientcmd::RegisterChatCmd( names , ::ClientCmdCallbackFunc_Time , true );
}

ClientCmdCallbackFunc_Time( client , cmdName , text )
{
    query = "SELECT NOW() AS `time`";
    level thread svr\mysql\mysql::MysqlAsyncQuery( query , ::MysqlAsyncCallbackFunc_Time , client );
}

MysqlAsyncCallbackFunc_Time( client , rows , args )
{
    if( isDefined( rows ) &&
        isDefined( rows[ 0 ] ) &&
        isDefined( rows[ 0 ][ "time" ] ) &&
        isDefined( client ) &&
        isPlayer( client ) )
    {
        client iPrintLn( "It is " + rows[ 0 ][ "time" ] );
    }
}