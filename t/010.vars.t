use Test::More no_plan;

use strict;
use PHP::Include;

include_php_vars( "t/test.php" );

## numbers
ok( $number1 == 123, 'integer assignment' );
ok( $number2 == 123.45, 'float assignment w/ spaces' );

## strings
ok( $string1 eq 'McHenry, IL', 'string assignment w/ single quotes' );
ok( $string2 eq 'McHenry, IL', 'string assignement w/ double quotes' );

## arrays
ok( $array1[0] == 123, 'array with one integer element' );
ok( ($array2[0] == 123 and $array2[1] == 456 and $array2[2] == 789),
    'array with three integer elements' 
);
ok( $array3[0] eq 'abc', 'array with one string element' );
ok( ($array4[0] eq 'abc' and $array4[1] eq 'def' and $array4[2] eq 'ghi' ),
    'array with three string elements'
);

## hashes
ok( $hash1{'a'} == 1, 'hash with one key/value pair' );
ok( ($hash2{'a'} == 1 and $hash2{'b'} == 2 and $hash2{'c'} == 3 ),
    'hash with three key/value pairs' 
);
ok( ($hash3{1} eq 'a', $hash3{'foo'} eq 'bar' and $hash3{123.45} eq 'moog' ),
    'hash with different types of key/value pairs'
);
ok ( ($hash4{abe} eq 'Abraham Lincoln' and $hash4{larry} = 'Larry Wall' ),
    'hash spread out over several lines'
);

## thats all folks
