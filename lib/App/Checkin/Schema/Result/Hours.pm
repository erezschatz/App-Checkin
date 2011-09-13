use strict;
use warnings;
package App::Checkin::Schema::Result::Hours;

use base qw/DBIx::Class::Core/;

__PACKAGE__->table('hours');

__PACKAGE__->add_columns(
    id  => {
        data_type => 'integer',
        is_nullable => 0,
        is_auto_increment => 1,
        default_value => '',
    },
    checkin => {
        data_type => 'integer',
        is_nullable=> 0,
    },
    checkout => {
        data_type => 'integer',
        is_nullable => 1,
    },
    total => {
        data_type => 'text',
        is_nullable => 1,
        is_duration => 1, #IC::DT::Duration
    },
);

__PACKAGE__->set_primary_key('id');

1;
