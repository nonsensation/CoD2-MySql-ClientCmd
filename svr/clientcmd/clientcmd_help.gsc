
Init()
{
    names = strTok( "help h" , " " );

    svr\clientcmd\clientcmd::RegisterChatCmd( names , ::ClientCmdCallbackFunc_Help , true );
}

ClientCmdCallbackFunc_Help( client , cmdName , text )
{
    cmdText = "";

    if( !isDefined( text ) || text.size <= 0 )
    {
        cmdText = "Available commands:";

        for( i = 0 ; i < level.clientcmd_cmdList.size ; i++ )
        {
            cmdText += " ^1" + level.clientcmd_cmdIdentifier + "^3" + level.clientcmd_cmdList[ i ].nameList[ 0 ];
        }
    }
    else
    {
        cmd = svr\clientcmd\clientcmd::GetChatCmdByName( text );

        if( isDefined( cmd ) )
        {
            if( isDefined( cmd.helpText ) && cmd.helpText.size > 0 )
                cmdText = "^1" + level.clientcmd_cmdIdentifier + "^3" + cmd.nameList[ 0 ] + " " + cmd.helpText;
            else
                cmdText = "^3***^1WARNING^3***^7 NO INFORMATION FOUND, PLEASE CONTACT AN ADMIN";
        }
    }

    if( cmdText.size > 0 )
        client iPrintLn( cmdText );
    else
        client iPrintLn( "Something went horrible wrong!" );
}