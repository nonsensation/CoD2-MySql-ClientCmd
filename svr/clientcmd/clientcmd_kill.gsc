Init()
{
    names = strTok( "kill" , " " );
    helpText = "!kill [player-name]";

    svr\clientcmd\clientcmd::RegisterChatCmd( names , ::ClientCmdCallbackFunc_Kill , true , helpText );
}

ClientCmdCallbackFunc_Kill( client , cmdName , text )
{
    p = undefined;

    if( isDefined( text ) )
        p = svr\util_client::FindClientByName( text );
    else
        p = client;

    if( isDefined( p ) && isPlayer( p ) && p.sessionstate == "playing" )
        p suicide();
}
