

blank( a , b , c , d , e , f , g , h , i , j , k , l , m , n , o , p , q , r , s , t , u , v , w , x , y , z )
{
    
}

array( a , b , c , d , e , f , g , h , i , j , k , l , m , n , o , p , q , r , s , t , u , v , w , x , y , z )
{
    arr = [];

    if( !isDefined( a ) ) return arr; else arr[ arr.size ] = a;
    if( !isDefined( b ) ) return arr; else arr[ arr.size ] = b;
    if( !isDefined( c ) ) return arr; else arr[ arr.size ] = c;
    if( !isDefined( d ) ) return arr; else arr[ arr.size ] = d;
    if( !isDefined( e ) ) return arr; else arr[ arr.size ] = e;
    if( !isDefined( f ) ) return arr; else arr[ arr.size ] = f;
    if( !isDefined( g ) ) return arr; else arr[ arr.size ] = g;
    if( !isDefined( h ) ) return arr; else arr[ arr.size ] = h;
    if( !isDefined( i ) ) return arr; else arr[ arr.size ] = i;
    if( !isDefined( j ) ) return arr; else arr[ arr.size ] = j;
    if( !isDefined( k ) ) return arr; else arr[ arr.size ] = k;
    if( !isDefined( l ) ) return arr; else arr[ arr.size ] = l;
    if( !isDefined( m ) ) return arr; else arr[ arr.size ] = m;
    if( !isDefined( n ) ) return arr; else arr[ arr.size ] = n;
    if( !isDefined( o ) ) return arr; else arr[ arr.size ] = o;
    if( !isDefined( p ) ) return arr; else arr[ arr.size ] = p;
    if( !isDefined( q ) ) return arr; else arr[ arr.size ] = q;
    if( !isDefined( r ) ) return arr; else arr[ arr.size ] = r;
    if( !isDefined( s ) ) return arr; else arr[ arr.size ] = s;
    if( !isDefined( t ) ) return arr; else arr[ arr.size ] = t;
    if( !isDefined( u ) ) return arr; else arr[ arr.size ] = u;
    if( !isDefined( v ) ) return arr; else arr[ arr.size ] = v;
    if( !isDefined( w ) ) return arr; else arr[ arr.size ] = w;
    if( !isDefined( x ) ) return arr; else arr[ arr.size ] = x;
    if( !isDefined( y ) ) return arr; else arr[ arr.size ] = y;
    if( !isDefined( z ) ) return arr; else arr[ arr.size ] = z;

    return arr;  
}

arrayConcat( array1 , array2 )
{
    for( i = 0 ; i < array2.size ; i++ )
    {
        array1[ array1.size ] = array2[ i ]; 
    }

    return array1;
}

isInt( str )
{
    return ( int( str ) + "" ) == ( str + "" );
}

PrintArray( arr )
{
    printf( "ARRAY(" + arr.size + ") = " + ArrayToString( arr ) + "\n" );
}

ArrayToString( arr )
{
    str = "";

    for( i = 0 ; i < arr.size ; i++ )
    {
        elem = arr[ i ];

        if( !isDefined( elem ) )
            elem = "undefined";
        else if( isString( elem ) )
            elem = "\"" + elem + "\"";
        else if( isPlayer( elem ) )
            elem = "{ " + elem.name + " }";
        // else if( isArray( elem ) )
        //     elem = ArrayToString( arr );
        else
            elem = "?";

        str += " " + elem + " ";

        if( i < arr.size - 1 )
            str += ",";
    }

    return "[" + str + "]";
}

arrayInsertValueAtPosition( value , arr , pos )
{
    if( !isDefined( pos ) )
        pos = arr.size;

    for( i = arr.size ; i > pos ; i-- )
    {
        arr[ i ] = arr[ i - 1 ];
    }

    arr[ pos ] = value;
    
    return arr;
}