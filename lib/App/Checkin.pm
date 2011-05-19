use strict;
use warnings;
package App::Checkin;

use App::Checkin::Schema;

use Moose;

has schema => (
    is => 'ro',
    isa => 'DBIx::Class::Schema',
    lazy => 1,
    builder => '_build_schema',
);

BEGIN {
    mkdir "$ENV{HOME}/.checkin" unless opendir my $DIR, "$ENV{HOME}/.checkin";
}

sub _build_schema {
    my $self = shift;
    my $schema = App::Checkin::Schema->connect("dbi:SQLite:$ENV{HOME}/.checkin/hours.db");
    $schema->deploy({add_drop_table => 1 });
    return $schema;
}

sub checkin {
    my $self = shift;
    #is there already an entry for this date?
    $self->schema->resultset('Hours')->create({});
}

sub checkout {
    my $self = shift;
    #get today's entry.
    my $checkout = $self->schema->resultset('Hours')->update({});
    
}

1;
