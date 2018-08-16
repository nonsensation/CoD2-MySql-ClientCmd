
#include svr\util;
#include svr\mysql\mysql_util;


Init_MySql()
{   
    level.sql_lastId = "LastId";
    level.sql_skipEscape = "#";
    level.sql_table = [];
    level.sql_tables = [];
    level.sql_handle = mysql_reuse_connection();

    level.sql_Null = level.sql_skipEscape + "NULL";
    level.sql_CurTime = level.sql_skipEscape + "CURRENT_TIMESTAMP";

    if( !isDefined( level.sql_handle ) )
    {
        hostname = getCvar( "mysql_hostname" );
        username = getCvar( "mysql_username" );
        password = getCvar( "mysql_password" );
        database = getCvar( "mysql_database" );
        port = getCvarInt( "mysql_port" );

        level.sql_handle = mysql_init();

        result = mysql_real_connect( level.sql_handle , hostname , username , password , database , port );

        if( !isDefined( result ) || result == 0 )
        {
            printf( "[SQL][ERROR] errno #1 = " + mysql_errno( level.sql_handle ) + "\n" );
            printf( "[SQL][ERROR] errno #2 = " + mysql_errno( level.sql_handle ) + "\n" );
            
            mysql_close( level.sql_handle );

            return;
        }

        mysql_async_initializer( hostname , username , password , database , port , 4 );
    }

    level thread svr\mysql\mysql_functions::Init_Functions();

    level thread SqlAsyncLoop();
}

SqlAsyncLoop()
{
    level.sql_async_task_list = [];

    level thread SqlQueryListener();

    while( true )
    {
        taskIds = mysql_async_getdone_list();

        for( i = 0 ; i < taskIds.size ; i++ )
        {
            taskId = taskIds[ i ];
            resultHandle = mysql_async_getresult_and_free( taskId );

            if( !isDefined( resultHandle ) )
                continue;

            task = level.sql_async_task_list[ taskId ];

            if( isDefined( task ) )
            {
                result = SqlGetResult( resultHandle );

                printf( "[SQL][QUERY_RESULT] " + task.identifier + "\n" );

                level notify( "sql_result" , task.identifier , result , task.args );
            }
            else if( resultHandle != 0 )
            {
                mysql_free_result( resultHandle );
            }

            level.sql_async_task_list[ taskId ] = undefined;
        }

        wait( 0.05 );
    }
}

SqlQueryListener()
{
    while( true )
    {
        level waittill( "sql_query" , identifier , query , args );

        task = spawnStruct();
        task.identifier = identifier;
        task.args = args;

        taskId = mysql_async_create_query( query );

        level.sql_async_task_list[ taskId ] = task;

        printf( "[SQL][QUERY_CREATE][" + getTime() + "] " + identifier + "\n" );
        printf( "[SQL][QUERY] " + query + "\n" );
    }
}

SqlGetResult( resultHandle )
{
    result = spawnStruct();
    result.fields = [];
    result.rows = [];

    if( isDefined( resultHandle ) && resultHandle != 0 )
    {
        for( field = mysql_fetch_field( resultHandle ) 
        ; isDefined( field )
        ; field = mysql_fetch_field( resultHandle ) )
        {
            result.fields[ result.fields.size ] = field;
        }

        for( rowIndex = 0 ; rowIndex < mysql_num_rows( resultHandle ) ; rowIndex++ )
        {
            row = mysql_fetch_row( resultHandle );
            result.rows[ result.rows.size ] = [];

            for( fieldIndex = 0 ; fieldIndex < result.fields.size ; fieldIndex++ )
            {
                result.rows[ result.rows.size - 1 ][ result.fields[ fieldIndex ] ] = row[ fieldIndex ];
            }
        }

        mysql_free_result( resultHandle );
    }

    return result;
}



