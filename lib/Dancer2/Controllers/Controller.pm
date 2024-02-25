package Dancer2::Controllers::Controller;

use strict;
use warnings;
use Moo::Role;
use Carp qw(croak);
use B 'svref_2object';
use Dancer2::Controllers;

sub MODIFY_CODE_ATTRIBUTES {
    my ( $package, $coderef, @attributes ) = @_;
    my $sub_name = svref_2object($coderef)->GV->NAME;

    my @not_allowed;

    for (@attributes) {

        #unless ( $_ =~ /^(get|put|post|patch|del|any).*/x ) {
        #    push @not_allowed, $_;
        #    next;
        #}

        my ( $action, $location ) =
          $_ =~ /^(get|put|post|patch|del|any)\s'?"?(\([\w\-_:\/]+\))'?"?$/x;

        my $fq_name = $package . '::' . $sub_name;
        my $fq_code = \&{$fq_name};

        push @Dancer2::Controllers::ROUTES, [ $action, $location, $fq_code ];
    }

    return @not_allowed;
}

sub routes {
}

1;
