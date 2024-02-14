package Dancer2::Controllers::Controller;

use strict;
use warnings;
use Moo::Role;
use Carp qw(croak);

sub routes {
    croak qq{Abstract method "routes" on }
      . ref(shift)
      . qq{ needs to be overwritten to register routes.};
}

1;
