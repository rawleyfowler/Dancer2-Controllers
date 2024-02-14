package MyController;

use strict;
use warnings;

sub routes {
    return [ [ get => '/' => sub { 'Hello World!' } ] ];
}

1;

package ControllerGuy;

use strict;
use warnings;

sub routes {
    return [ [ get => '/' => undef ] ];
}

1;

package MyOtherController;

use strict;
use warnings;

1;

use Dancer2::Controllers;
use Test::More;
use Test::Exception;
use strict;
use warnings;

dies_ok { controllers("foo!") } 'Dies when not array ref';
dies_ok { controllers( ['MyController'] ) }
'Dies when caller not a Dancer2 app';
dies_ok { controllers( ['MyOtherController'] ) }
'Dies when no routes method on controller';
dies_ok { controllers( ['ControllerGuy'] ) }
'Dies when action is bad';

done_testing;
