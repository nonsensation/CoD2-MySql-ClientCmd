Init()
{
    name = strTok( "register" , " " );

    svr\clientcmd\clientcmd::RegisterChatCmd( name , ::ClientCmdCallbackFunc_Register , true );
}

ClientCmdCallbackFunc_Register( client , cmdName , text )
{
    textTokens = strTok( text , " " );

    username = textTokens[ 0 ];
    password = textTokens[ 1 ];

    if( !CheckLoginString( username , client , 3 , 20 , "Username" ) ||
        !CheckLoginString( password , client , 3 , 20 , "Password" ) ||
        username == password )
        return;

    query = "";
    query += "INSERT INTO `Clients` ( `Username` , `Password` ) ";
    query += "SELECT * FROM ( SELECT '" + username + "' , '" + password + "' ) AS tmp ";
    query += "WHERE NOT EXISTS ( SELECT `Username` FROM `Clients` WHERE `Username` = '" + username + "' ) LIMIT 1";

    level thread svr\mysql\mysql::MysqlAsyncQuery( query , ::MysqlAsyncCallbackFunc_Register , client );
}

MysqlAsyncCallbackFunc_Register( client , rows , args )
{
    if( isDefined( client ) && isPlayer( client ) )
    {
        if( isDefined( rows ) && isDefined( rows[ 0 ] ) && isDefined( rows[ 0 ][ "Id" ] ) )
        {
            client iPrintLn( "You have been registered as user #" + rows[ 0 ][ "Id" ] );
        }
        else
        {
            // client iPrintLn( "Something went horrible wrong!" );
        }
    }
}

CheckLoginString( username , entity , minLength , maxLength , prefixString )
{
    if( !isDefined( minLength ) )
        minLength = 3;
    if( !isDefined( maxLength ) )
        maxLength = 20;
    if( !isDefined( prefixString ) )
        prefixString = "Login-String";

    isEntityDefined = isDefined( entity );
    isValidUserName = false;
    errorMsg = prefixString;

    if( !isDefined( username ) )
        errorMsg += " is undefined!";
    else if( username.size < minLength )
        errorMsg += " is too short (min " + minLength + " characters)!";
    else if( username.size > maxLength )
        errorMsg += " is too long (max " + maxLength + " characters)!";
    else if( username != CleanUpString( username ) )
        errorMsg += " is contains invalid characters!";
    else
        return true;

    if( isEntityDefined )
        entity iPrintLn( errorMsg );

    return false;
}

CleanUpString( inputStr )
{
    validChars = "";
    validChars += "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    validChars += "abcdefghijklmnopqrstuvwxyz";
    validChars += "0123456789";
    validChars += "!$&/()[]{}=?+*~#-_.:,;<>|@";

    outputStr = "";

    for( i = 0 ; i < inputStr.size ; i++ )
    {
        if( isSubStr( validChars , "" + inputStr[ i ] ) )
            outputStr += inputStr[ i ];
    }

    printf( "inpout-str: " + inputStr + " output-str: " + outputStr + "\n" );

    return outputStr;
}