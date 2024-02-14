package MyApp::Controller;

use Moo;

use strict;
use warnings;

with 'Dancer2::Controllers::Controller';

sub hello_world {
    "Hello World!";
}

sub routes {
    return [ [ 'get' => '/' => 'hello_world' ] ];
}

1;

use Dancer2;
use Dancer2::Controllers qw(controllers);

set port => 8080;

controllers( ['MyApp::Controller'] );

dance;
