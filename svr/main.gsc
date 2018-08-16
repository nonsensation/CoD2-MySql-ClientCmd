
Main()
{
    level.CodeCallback_ClientCommand = svr\clientcmd\clientcmd::CodeCallback_ClientCommand;

    level thread svr\mysql\mysql::Init_Mysql();
    level thread svr\clientcmd\clientcmd::Init();
}
