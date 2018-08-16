Init()
{
    names = strTok( "kick" , " " );
    helpText = "[Player-Name|Player-ID] <Reason>";

    svr\clientcmd\clientcmd::RegisterChatCmd( names , ::ClientCmdCallbackFunc_Kick , true , helpText );
}

ClientCmdCallbackFunc_Kick( client , cmdName , text )
{
    helpText = "";

    if( !isDefined( text ) || text.size <= 0 )
        return client iPrintLn( helpText );
    
    textTokens = strTok( text , " " );

    if( textTokens.size < 1 )
        return client iPrintLn( helpText );

    clientName = textTokens[ 0 ];
    reason = undefined;

    if( textTokens.size > 1 )
        reason = getSubStr( text , clientName.size + 1 );

    query = "";
    query += "INSERT INTO `MetaInfo` ( `ClientId` , `MetaType` , `MetaData` ) ";
    query += "VALUES ( '" + self.pers["client"].Id + "' , '" + mysql_MetaData_MetaType_kick + "' , + '" +  + "' )";


    level thread svr\mysql\mysql::MysqlAsyncQuery( query , ::MysqlAsyncCallbackFunc_Register , client );
}

InsertIntoMetaInfo( client , callback , metaType , metaData )
{
    query = "";
    query += "INSERT INTO `MetaInfo` ( `ClientId` , `MetaType` , `MetaData` ) ";
    query += "VALUES ( '" + client.pers["client"].Id + "' , '" + metaType + "' , + '" + metaData + "' )";

    level thread svr\mysql\mysql::MysqlAsyncQuery( query , callback , client );
}

KickPlayer( client , player , reason )
{
    metaData = "";
    
    InsertIntoMetaInfo( client , callback , level.mysql_MetaData_MetaType_kick , metaData )
}

