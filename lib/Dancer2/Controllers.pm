package Dancer2::Controllers;

use strict;
use warnings;

use Carp qw(croak);
use Dancer2;

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
            my ( $action, $location, $func ) = @$_;
            croak qq{Invalid action $action when registering route $location}
              unless exists $dsl{$action};
            $dsl{$action}->( $location, *{"$controller::$func"} );
        }
    }
}

1;
