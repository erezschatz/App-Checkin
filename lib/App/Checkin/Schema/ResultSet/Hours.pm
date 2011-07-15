package App::Checkin::Schema::ResultSet::Hours;

use strict;
use warnings;

use DateTime;

use base qw/DBIx::Class::ResultSet
            DBIx::Class::InflateColumn::FS::ResultSet/;

sub has_entry {
    my $self = shift;
    #get today's date in epoch
    #search for anything>= todays date
    #with no checkout
    return $self->from_last_24_hours
                ->uncheckedout;
}

sub from_last_24_hours {
    my $self = shift;
    my $dt = DateTime->now->subtract(days => 1);;

    return $self->search({
        checkin => { '>' => $dt }
    });
}

sub uncheckedout {
    my $self = shift;
    return $self->search({
        checkout => undef
    });
}

1;
