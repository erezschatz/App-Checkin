use Modern::Perl;

package App::Checkin;

use App::Checkin::Schema;

use Moose;
use DateTime;


has schema => (
    is => 'ro',
    isa => 'DBIx::Class::Schema',
    lazy => 1,
    builder => '_build_schema',
);

sub _build_schema {
    my $self = shift;

    unless (opendir my $DIR, "$ENV{HOME}/.checkin") {
        mkdir "$ENV{HOME}/.checkin";
    }

    my $schema = App::Checkin::Schema->connect(
        "dbi:SQLite:$ENV{HOME}/.checkin/hours.db"
    );

    eval {
        $schema->resultset('Hours')->search({})->all;
    };
    $schema->deploy if $@;

    return $schema;
}

sub checkin {
    my $self = shift;
    my $duration =  DateTime->now->subtract(days => 1);
    return if $self->schema->resultset('Hours')->search({
        checkin => { '>', [ $duration ] }
    });

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
