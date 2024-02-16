package Dancer2::Controllers;

use strict;
use warnings;

use Carp     qw(croak);
use Exporter qw(import);

our $VERSION = '0.2';
our @EXPORT  = qw(controllers);

my %dsl;
@dsl{qw(get post put patch del options)} = qw(1 1 1 1 1 1);

sub controllers {
    my $controllers = exists $_[1] ? $_[1] : $_[0];
    my ($package) = caller;

    croak
qq{Invalid arguments for Dancer2::Controllers::controllers, please pass an array ref of controllers.}
      if ( ref($controllers) ne 'ARRAY' );

    foreach my $controller (@$controllers) {
        croak qq{$controller has no `routes` method, please implement one.}
          unless $controller->can('routes');

        for ( $controller->routes()->@* ) {
            my ( $action, $location, $func_name_or_sub ) = @$_;

            croak
              qq{Invalid action `$action` when registering route `$location`}
              unless exists $dsl{$action};

            croak qq{Invalid action provided for route: undef}
              unless defined $func_name_or_sub;

            my $f;
            if ( ref($func_name_or_sub) eq 'CODE' ) {
                $f = $func_name_or_sub;
            }
            else {
                $f = $controller->can($func_name_or_sub);
            }

            croak qq{Invalid action provided for route $func_name_or_sub}
              unless defined $f;

            my $cb = $package->can($action);

            croak
qq{Caller of Dancer2::Controllers::controller must `use Dancer2;`, calling package: $package does not.}
              unless $cb;

            $cb->( $location, $f );
        }
    }
}

1;

=encoding utf8

=head1 NAME

Dancer2::Controllers

=head1 SYNOPSIS

Dancer2::Controllers is a Spring-Boot esq wrapper for defining Dancer2 routes, it allows you to define
routes inside of modules using a C<routes> method.

=head1 EXAMPLE

    package MyApp::Controller;

    use Moo;

    use strict;
    use warnings;

    # Optionally use the Dancer2::Controllers::Controller role to explicitly display
    # that this module is a controller.
    with 'Dancer2::Controllers::Controller';

    sub hello_world {
        "Hello World!";
    }

    sub routes {
        return [
            [ 'get' => '/' => 'hello_world' ],
            [ 'get' => '/foo' => sub { 'Foo!' } ] # or, use a subroutine!
        ];
    }

    1;

    use Dancer2;
    use Dancer2::Controllers;

    controllers( ['MyApp::Controller'] );

    dance;

=head1 API

=head2 controllers

    controllers( [
        'MyApp::Controller::Foo',
        'MyApp::Controller::Bar'
    ] );

A subroutine that takes a list of controller module names, and registers their C<routes>.
