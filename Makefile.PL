use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Net::IP::ACL',
    AUTHOR           => q{Toshifumi Sakaguchi <sischkg@gmail.com>},
    VERSION_FROM     => 'lib/Net/IP/ACL.pm',
    ABSTRACT_FROM    => 'lib/Net/IP/ACL.pm',
    LICENSE          => 'MIT',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
        'Moose'               => 0,
        'Net::IP'             => 0,
	'Exception::Class'    => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'ExtUtils::MakeMaker' => 0,
        'Moose'               => 0,
        'Net::IP'             => 0,
	'Exception::Class'    => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Net-IP-ACL-*' },
);
