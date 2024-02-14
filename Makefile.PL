use strict;
use warnings;

use utf8;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Dancer2::Controllers',
    VERSION_FROM => 'lib/Dancer2/Controllers.pm',
    ABSTRACT     => qq{A tool to allow OO style route declaration in Dancer2},
    license      => 'artistic_2',
    META_MERGE   => {
        dynamic_config => 0,
        'meta-spec'    => { version   => 2 },
        no_index       => { directory => [ 'examples', 't' ] },
        prereqs        => { runtime   => { requires => { perl => '5.014' } } },
        resources      => {
            bugtracker => {
                web =>
                  'https://github.com/rawleyfowler/Dancer2-Controllers/issues'
            },
            license =>
              [qq{http://www.opensource.org/licenses/artistic-license-2.0}],
            repository => {
                type => 'git',
                url  => 'https://github.com/rawleyfowler/Dancer2-Controllers'
            }
        },
    },
    TEST_REQUIRES => {
        'Test::Simple'          => '1.302195',
        'HTTP::Request::Common' => '6.45',
        'Test::Exception'       => '0.43'
    },
    PREREQ_PM => {
        'Dancer2' => '1.1.0',
    },
    test => { TESTS => 't/*.t t/*/*.t it/*.t it/*/*.t' }
);
