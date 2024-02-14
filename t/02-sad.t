package MyApp::Controller;

use strict;
use warnings;

sub hello_world {
    "Hello World!";
}

sub foo {
    'Foo!';
}

sub routes {
    [ [ 'get' => '/' => 'hello_worl' ], [ 'get' => '/foo' => 'foo' ] ]
}

1;

package MyApp::Controller::Two;

use strict;
use warnings;

sub hello_world {
    "Hello World!";
}

sub routes {
    [ [ 'flarb' => '/' => 'hello_world' ] ]
}

1;

package MyApp::Controller::Three;

use strict;
use warnings;

1;

use Test::More;
use Test::Exception;
use Plack::Test;
use HTTP::Request::Common;
use Dancer2;
use strict;
use warnings;

use_ok('Dancer2::Controllers');

require Dancer2::Controllers;

dies_ok { Dancer2::Controllers::controllers( ['MyApp::Controller::Two'] ) };
dies_ok { Dancer2::Controllers::controllers( ['MyApp::Controller::Three'] ) };
dies_ok { Dancer2::Controllers::controllers( ['MyApp::Controller'] ) };

done_testing
