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

    my $home = $^O =~ m/^MSWin/ ? $ENV{'USERPROFILE'} : $ENV{HOME};

    unless (opendir my $DIR, "$home/.checkin") {
        mkdir "$home/.checkin";
    }

    my $schema = App::Checkin::Schema->connect(
        "dbi:SQLite:$home/.checkin/hours.db"
    );

    eval {
        $schema->resultset('Hours')->search->all;
    };
    $schema->deploy if $@;

    return $schema;
}

sub checkin {
    my $self = shift;
    return if $self->checkin_not_checkout->all;
    $self->schema->resultset('Hours')->create({
        checkin => DateTime->now->epoch,
    });
}

sub update_checkin {
    my $self = shift;
    $self->checkin_in_last_24_hours->update({
        checkin => DateTime->now->epoch,
    });
}

sub checkin_in_last_24_hours {
    my $self = shift;
    my $duration =  DateTime->now->subtract(days => 1)->epoch;
    return $self->schema->resultset('Hours')->search({
        checkin => { '>', [ $duration ] },
        checkout => undef,
    });
}

sub checkin_not_checkout {
    my $self = shift;
    return $self->schema->resultset('Hours')->search({
        checkout => undef,
    });
}

sub checkout {
    my ($self, $checkin) = @_;
    $checkin->update({
        checkout => DateTime->now->epoch,
    }) or die "Error in checkout\n";
}

sub month_total {
    my $self = shift;
    return $self->schema->resultset('Hours')->month_total;
}

sub get_duration {
    my ($self, @checkin) = @_;
    return DateTime->now->epoch - $checkin[0]->checkin;
}

1;
