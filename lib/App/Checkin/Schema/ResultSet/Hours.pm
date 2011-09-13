package App::Checkin::Schema::ResultSet::Hours;

use strict;
use warnings;

use DateTime;

use base qw/
               DBIx::Class::ResultSet
               DBIx::Class::InflateColumn::FS::ResultSet
           /;

sub from_last_24_hours {
    my $self = shift;
    my $dt = DateTime->now->subtract(days => 1);

    return $self->search({
        checkin => { '>' => $dt }
    });
}

sub month_total {
    my $self = shift;
    my $dt = DateTime->now->subtract(months => 1)->epoch;
    my @days = $self->search({
        checkin => { '>=' => $dt }
    })->all;
    my $total = 0;
    foreach my $day (@days) {
        $total +=  ($day->checkout - $day->checkin);
    }
    return @days * 9 - $total;
}

sub uncheckedout {
    my $self = shift;
    return $self->search({
        checkout => undef
    });
}

1;
