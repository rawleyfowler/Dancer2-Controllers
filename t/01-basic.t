package MyApp::Controller::Foo;

use strict;
use warnings;

sub hello_world {
    return "Hello World!";
}

sub foo {
    return 'Foo!';
}

sub routes {
    [ [ 'get' => '/' => 'hello_world' ], [ 'get' => '/foo' => 'foo' ] ]
}

1;

use Test::More;
use Test::Exception;
use Plack::Test;
use HTTP::Request::Common;
use Dancer2;
use strict;
use warnings;
use Dancer2::Controllers qw(controllers);

lives_ok { controllers( ['MyApp::Controller::Foo'] ) };

my $app = to_app;

my $test = Plack::Test->create($app);

my $response = $test->request( GET '/' );

ok( $response->is_success, 'Success' );
is( $response->content, 'Hello World!', 'Correct content' );

$response = $test->request( GET '/foo' );

ok( $response->is_success, 'Success' );
is( $response->content, 'Foo!', 'Correct content' );

done_testing
