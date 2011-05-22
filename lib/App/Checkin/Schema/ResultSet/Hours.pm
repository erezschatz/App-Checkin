package App::Checkin::Schema::ResultSet::Hours;

use strict;
use warnings;

use base qw/DBIx::Class::ResultSet
            DBIx::Class::InflateColumn::FS::ResultSet/;

sub active {
    my $self = shift;
    return $self
        ->unblocked
        ->have_completed_signup;
}
