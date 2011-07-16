use Modern::Perl;

package App::Checkin;

use App::Checkin::Schema;

use Moose;
use DateTime;

has schema => (
    is => 'ro',
    isa => 'DBIx::Class::Schema',
    lazy_build => 1,
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
    return if $self->checkin_in_last_24_hours->all;
    $self->schema->resultset('Hours')->create({});
}

sub update_checkin {
    my $self = shift;
    $self->checkin_in_last_24_hours->update({
        checkin => DateTime->now,
    });
}

sub checkin_in_last_24_hours {
    my $self = shift;
    my $duration =  DateTime->now->subtract(days => 1);
    return $self->schema->resultset('Hours')->search({
        checkin => { '>', [ $duration ] },
        checkout => undef,
    });
}

sub checkout {
    my $self = shift;
    $self->checkin_in_last_24_hours->update({
        checkout => DateTime->now,
    }) or return;
    return $self->schema->resultset('Hours')->month_total;
}

1;
