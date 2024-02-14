package Dancer2::Controllers;

use strict;
use warnings;

use Carp qw(croak);
use Dancer2;
use Exporter qw(import);

our @EXPORT_OK = qw(controllers);

my %dsl = (
    get     => \&get,
    post    => \&post,
    put     => \&put,
    patch   => \&patch,
    options => \&options,
    del     => \&del
);

sub controllers {
    my $controllers = $_[1] ? $_[1] : $_[0];

    croak
qq{Invalid arguments for Dancer2::Controllers::controllers, please pass an array ref of controllers.}
      if ( ref($controllers) ne 'ARRAY' );

    foreach my $controller (@$controllers) {
        for ( $controller->routes->@* ) {
            my ( $action, $location, $func_name_or_sub ) = @$_;
            say @$_;
            croak qq{Invalid action $action when registering route $location}
              unless exists $dsl{$action};

            my $f;
            if ( ref($func_name_or_sub) eq 'CODE' ) {
                $f = $func_name_or_sub;
            }
            else {
                no strict;
                $f = \&{ *{ $controller . '::' . $func_name_or_sub } };
            }

            croak qq{Invalid action provided for route $func_name_or_sub}
              unless defined $f;

            $dsl{$action}->( $location, $f );
        }
    }
}

1;

=encoding utf8

=head1 NAME

Dancer2::Controllers

=head1 SYNOPSIS

Dancer2::Controllers is a OO (object-oriented) wrapper for defining Dancer2 routes, it allows you to define
routes inside of modules that inherit from L<Dancer2::Controllers::Controller>.

=head1 EXAMPLE

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

    controllers( ['MyApp::Controller'] );

    dance;

=head1 API

=head2 controllers

    controllers( [
        'MyApp::Controller::Foo',
        'MyApp::Controller::Bar'
    ] );

A subroutine that takes a list of controller module names, and registers their C<routes>
function routes.
