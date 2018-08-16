

#include svr\util;
#include svr\mysql\mysql;
#include svr\mysql\mysql_query;
#include svr\mysql\mysql_functions;


UpdateClientInfo( clientid )
{
    keys = array(
        "Kills" ,
    );

    q = "SELECT EXISTS( SELECT 1337 FROM " + SqlKey( "MetaInfo" ) + " , " + SqlKey( "MetaData" ) +
        " WHERE " + SqlKey( "MetaType" ) + " = " + SqlValue( metaType ) +
        " AND " + SqlKey( "Key" ) + " = " + SqlValue( key ) +
        " AND " + SqlKey( "Val" ) + " = " + SqlValue( val ) +
        " LIMIT 1 ) AS " + SqlKey( "Result" );

    args = array( "mysql_HasMetaData" , val );

    level thread MysqlAsyncQuery( q , ::HasMetaData_Callback , undefined , args );
}

HasMetaData_Callback( invoker , rows , args )
{

}
