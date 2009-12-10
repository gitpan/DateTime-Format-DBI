package DateTime::Format::DBI;
# $Id: DBI.pm 4365 2009-12-10 18:11:51Z cfaerber $

use strict;
use vars qw ($VERSION);
use warnings;

use Carp;
use DBI 1.21;

$VERSION = '0.033';
$VERSION = eval { $VERSION };

our %db_to_parser = (
  # lowercase for case-insensitivity!
  'mysql'	=> 'DateTime::Format::MySQL',
  'pg'		=> 'DateTime::Format::Pg',
  'db2'		=> 'DateTime::Format::DB2',
  'oracle'	=> 'DateTime::Format::Oracle', # experimental
  'sqlite'	=> 'DateTime::Format::SQLite', # experimental
);

sub new {
  my ($name,$dbh) = @_;
  UNIVERSAL::isa($dbh,'DBI::db') || croak('Not a DBI handle.');

# my $dbtype = $dbh->{Driver}->{Name};
  my @dbtypes = eval { DBI::_dbtype_names($dbh) };
  my $dbtype = shift @dbtypes;

  my $pclass = $db_to_parser{lc $dbtype};
  $pclass || croak("Unsupported database driver '".$dbtype."'");

  my $parser = eval "use $pclass; $pclass->new();";

  $parser || croak("Cannot load $pclass");

  return $parser;
}

=encoding utf8

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

It currently supports the following format modules:
L<IBM DB2 (DB2)|DateTime::Format::DB2>,
L<MySQL|DateTime::Format::MySQL>, 
L<Oracle|DateTime::Format::Oracle>,
L<PostgreSQL (Pg)|DateTime::Format::Pg>,
L<SQLite|DateTime::Format::SQLite>.

B<NOTE:> This module provides a quick method to find the correct parser and
formatter class. However, this is usually not sufficient for full database
abstraction. You will also have to cater for differences in the syntax and
semantics of SQL datetime functions (and other SQL commands).

=head1 CLASS METHODS

=over 4

=item * new( $dbh )

Creates a new C<DateTime::Format::*> instance the exact class of which depends
on the driver used for the database connection referenced by C<$dbh>. 

=back

=head1 PARSER/FORMATTER INTERFACE

C<DateTime::Format::DBI> is just a front-end class factory that will return one
of the format classes based on the nature of your C<$dbh>.

For information on the interface of the returned parser object, please see the
documentation for the class pertaining to your particular C<$dbh>.

In general, parser classes for databases will implement the following methods.
For more information on the exact behaviour of these methods, see the
documentation of the parser class.

=over 4

=item * parse_datetime( $string )

Given a string containing a date and/or time representation from the database
used, this method will return a new C<DateTime> object.

If given an improperly formatted string, this method may die.

=item * format_datetime( $dt )

Given a C<DateTime> object, this method returns a string appropriate as input
for all or the most common date and date/time types of the database used. 

=item * parse_duration( $string )

Given a string containing a duration representation from the database used,
this method will return a new C<DateTime::Duration> object.

If given an improperly formatted string, this method may die.

Not all databases and format/formatter classes support durations; please use
L<UNIVERSAL::has|UNIVERSAL/has> to check for the availability of this method.

=item * format_duration( $du )

Given a C<DateTime::Duration> object, this method returns a string appropriate
as input for the duration or interval type of the database used.

Not all databases and parser/formatter classes support durations; please use
L<UNIVERSAL::has|UNIVERSAL/has> to check for the availability of this method.

=back

Parser/formatter classes may additionally define methods like parse_I<type> or
format_I<type> (where I<type> is derived from the SQL type); please see the
documentation of the individual format class for more information.

=head1 SUPPORT

Support for this module is provided via the datetime@perl.org email
list.  See http://lists.perl.org/ for more details.

=head1 AUTHOR

Claus Färber <CFAERBER@cpan.org>

=head1 LICENSE

Copyright © 2003-2009 Claus Färber.  All rights reserved.  

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

The full text of the license can be found in the LICENSE file included with
this module.

=head1 SEE ALSO

L<DateTime>, L<DBI>

datetime@perl.org mailing list

http://datetime.perl.org/

=cut
