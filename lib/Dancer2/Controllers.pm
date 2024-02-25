package Dancer2::Controllers;

use strict;
use warnings;

use Carp     qw(croak);
use Exporter qw(import);

our $VERSION = '1.0';
our @EXPORT  = qw(controllers);
our @ROUTES;

my %dsl;
@dsl{qw(get post put patch del options)} = qw(1 1 1 1 1 1);

sub controllers {
    my $controllers = exists $_[1] ? $_[1] : $_[0];
    for ( $controllers->@* ) {
        my $module = $_;
        eval { require $module; }
          or croak qq{Couldn't evaluate package '$module' because: $@ };
    }
    my ($pkg) = caller;
    for (@ROUTES) {
        my ( $action, $location, $sub ) = @$_;

        croak qq{Invalid HTTP method specified '$action' for '$location'.}
          unless exists $dsl{$location};

        $pkg->$action->( $location, $sub );
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

    # Add the Dancer2::Controllers::Controller role to your controller classes
    with 'Dancer2::Controllers::Controller';

    sub hello_world : Route(get => /) {
        "Hello World!";
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
