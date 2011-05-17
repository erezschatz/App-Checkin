use strict;
use warnings;
package App::Checkin::Schema::Result::Hours;

use base qw/DBIx::Class::Core/;

__PACKAGE__->table('hours');
__PACKAGE__->load_components(qw/
                                   TimeStamp
                                   InflateColumn::DateTime::Duration
                               /);

__PACKAGE__->add_columns(
    id  => {
        data_type => 'integer',
        is_nullable => 0,
        is_auto_increment => 1,
        default_value => '',
    },
    checkin => {
        data_type => 'datetime',
        set_on_create => 1,
    },
    checkout => {
        data_type => 'datetime',
        set_on_update => 1,
    },
    total => {
        data_type => 'text',
        is_duration => 1
    },
);

__PACKAGE__->set_primary_key('id');

1;
