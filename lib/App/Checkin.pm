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
    mkdir "$ENV{HOME}/.checkin"
        unless opendir my $DIR, "$ENV{HOME}/.checkin";
}

sub _build_schema {
    my $self = shift;
    my $schema = App::Checkin::Schema->connect(
        "dbi:SQLite:$ENV{HOME}/.checkin/hours.db"
    );
    $schema->deploy({add_drop_table => 1 });
    return $schema;
}

sub checkin {
    my $self = shift;
    print 'foo' if $self->schema->resultset('Hours')->has_entry;
    $self->commit_checkin;
}

sub commit_checkin {
    my $self = shift;
    $self->schema->resultset('Hours')->create({});
}

sub checkout {
    my $self = shift;
    $self->schema->resultset('Hours')->update({}) or
        return;
    return $self->schema->resultset('Hours')->month_total;
}

1;
