#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Net::IP::ACL' ) || print "Bail out!\n";
}

diag( "Testing Net::IP::ACL $Net::IP::ACL::VERSION, Perl $], $^X" );
