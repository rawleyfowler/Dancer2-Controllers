package Dancer2::Controllers::Controller;

use strict;
use warnings;
use Moo;
use Carp qw(croak);

sub routes {
    croak qq{Abstract method "routes" on }
      . __PACKAGE__
      . qq{ needs to be overwritten to register routes.};
}

1;
