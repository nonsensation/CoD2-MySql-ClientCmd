


Init()
{
    level.clientcmd_cmdIdentifier = "!";
    level.clientcmd_cmdList = [];

    // level thread svr\clientcmd\clientcmd_time::Init();
    // level thread svr\clientcmd\clientcmd_help::Init();
    // level thread svr\clientcmd\clientcmd_kill::Init();
    // level thread svr\clientcmd\clientcmd_register::Init();
}

RegisterChatCmd( cmdNameList , cmdCallbackFunc , isHiddenCmd , helpText )
{
    if( !isDefined( isHiddenCmd ) )
        isHiddenCmd = false;

    cmd = spawnStruct();
    cmd.nameList = cmdNameList;
    cmd.isHidden = isHiddenCmd;
    cmd.callback = cmdCallbackFunc;
    cmd.id = level.clientcmd_cmdList.size;
    cmd.helpText = helpText;
    
    level.clientcmd_cmdList[ cmd.id ] = cmd;

    return cmd.id;
}

GetChatCmdByName( cmdName )
{
    for( i = 0 ; i < level.clientcmd_cmdList.size ; i++ )
    {
        cmd = level.clientcmd_cmdList[ i ];

        for( ii = 0 ; ii < cmd.nameList.size ; ii++ )
        {
            if( cmd.nameList[ ii ] == cmdName )
                return cmd;
        }
    }

    return undefined;
}

GetChatCmdById( cmdId )
{
    return level.clientcmd_cmdList[ cmdId ];
}

CodeCallback_ClientCommand( client , cmdArgList  )
{
    if( !isDefined( client ) || !isPlayer( client ) )
        return;
    else if( !isDefined( cmdArgList ) || cmdArgList.size <= 0 )
        return;

    if( isDefined( cmdArgList[ 0 ] ) )
    {
        if( cmdArgList[ 0 ] == "say" )
            return ProcessChatCmd( client , cmdArgList );

        client clientCommand(); // send cmd from server to clients
    }
}

ProcessChatCmd( client , cmdArgList )
{
    text = "";

    // skip the first arg "say" and join into a string
    for( i = 2 ; i < cmdArgList.size ; i++ )
    {
        if( isDefined( cmdArgList[ i ] ) )
        {
            if( i > 2 )
                text += " ";

            text += cmdArgList[ i ];
        }
    }

    cmdName = cmdArgList[ 1 ];

    // skip the first control character, if there is any
    ascii = getAscii( cmdName[ 0 ] );

    if( ascii > 19 && ascii < 23 )
        cmdName = getSubStr( cmdName , 1 );

    if( cmdName[ 0 ] != level.clientcmd_cmdIdentifier )
        return CheckChatText( client , text );

    cmdName = getSubStr( cmdName , 1 ); // skip level.clientcmd_cmdIdentifier
    cmd = GetChatCmdByName( cmdName );

    if( !isDefined( cmd ) )
    {
        client iPrintLn( "No command " + cmdName + " found!" );

        return;
    }

    level thread [[cmd.callback]]( client , cmdName , text );
}

CheckChatText( client , text )
{
    client clientCommand();
}


