package DateTime::Format::DBI;
# $Id: Pg.pm,v 1.6 2003/05/30 14:14:23 cfaerber Exp $

use strict;
use vars qw ($VERSION);

use Carp;
use DateTime 0.10;

$VERSION = '0.02';

$VERSION = eval $VERSION;

our %db_to_parser = (
  'mysql'	=> 'DateTime::Format::MySQL',
  'Pg'		=> 'DateTime::Format::Pg',
);

sub new {
  my ($name,$dbh) = @_;

  UNIVERSAL::isa($dbh,'DBI::db') || croak('Not a DBI handle.');
  my $dbtype = $dbh->{Driver}->{Name};

  my $pclass = $db_to_parser{$dbtype};
  $pclass || croak("Unsupported database driver 'DBD::".$dbtype."'");

  my $parser = eval "use $pclass; $pclass->new();";

  $parser || croak("Cannot load $pclass");

  return $parser;
}

=head1 NAME

DateTime::Format::DBI - Find a parser class for a database connection.

=head1 SYNOPSIS

  use DBI;
  use DateTime;
  use DateTime::Format::DBI;

  my $db = DBI->connect('dbi:...');
  my $db_parser = DateTime::Format::DBI->new($dbh);
  my $dt = DateTime->now();

  $db->do("UPDATE table SET dt=? WHERE foo='bar'",undef,
    $db_parser->format_datetime($dt);

=head1 DESCRIPTION

This module finds a C<DateTime::Format::*> class that is suitable for the use with
a given DBI connection (and C<DBD::*> driver).

It currently supports the following drivers: MySQL, PostgreSQL (Pg).

=head1 CLASS METHODS

=over 4

=item * new( $dbh )

Creates a new C<DateTime::Format::*> instance the exact class of which depends
on the driver used for the database connection referenced by $dbh. 

=head1 SUPPORT

Support for this module is provided via the datetime@perl.org email
list.  See http://lists.perl.org/ for more details.

=head1 AUTHOR

Claus A. Färber <perl@faerber.muc.de>

=head1 COPYRIGHT

Copyright © 2003 Claus A. Färber.  All rights reserved.  

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

The full text of the license can be found in the LICENSE file included with
this module.

=head1 SEE ALSO

L<DateTime::Format::MySQL>, L<DateTime::Format::Pg>

datetime@perl.org mailing list

http://datetime.perl.org/

=cut
