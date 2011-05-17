use strict;
use warnings;
package App::Checkin;

use App::Checkin::Schema;

my $schema = App::Checkin::Schema->connect('dbi:SQLite:/home/erez/foo.db');

my $new_album = $schema->resultset('Hours')->create({});


1;
