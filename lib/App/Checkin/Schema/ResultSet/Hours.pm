package App::Checkin::Schema::ResultSet::Hours;

use Modern::Perl;

use DateTime;

use base qw/
               DBIx::Class::ResultSet
           /;

sub from_last_24_hours {
    my $self = shift;
    my $dt = DateTime->now->subtract(days => 1);

    return $self->search({
        checkin => { '>' => $dt }
    });
}

sub from_current_month {
    my $self = shift;
    my $dt = DateTime->now->subtract(months => 1)->epoch;
    return $self->search({
        checkin => { '>=' => $dt }
    })->all;
}

sub month_total {
    my $self = shift;
    my @days = $self->from_current_month();
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
