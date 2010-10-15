#!/usr/bin/perl

use 5.006;
use strict;
use utf8;

use Module::Build;

eval { require 'lib/DateTime/Format/DBI.pm' };
my $db = \%DateTime::Format::DBI::_db_to_parser;

my $b = Module::Build->new(
	'module_name'	=> 'DateTime::Format::DBI',
	'license'	=> 'perl',
	'dist_author'	=> 'Claus Färber <CFAERBER@cpan.org>',

	'sign'		=> 1,
	'create_license' => 1,
	'create_makefile_pl' => 'traditional',

    	'requires'	=> {
		'DateTime'	=> 0.10,
		'DBI'		=> 1.21,
	},
	'recommends'	=> {
	},
	'build_requires' => {
		'Test::More' => 0, 
		'Test::NoWarnings' => 0,
	},

	auto_features => { 
		map { make_feature($_) } 
			keys %{$db} 
	},
	'no_index' => {
		'directory' => 'eg'
	},
	'resources' => {
		'homepage' 	=> 'http://search.cpan.org/dist/DateTime-Format-DBI/',
		'repository'	=> 'https://perl-date-time.svn.sourceforge.net/svnroot/perl-date-time/modules/DateTime-Format-DBI/',
		'bugtracker'	=> 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=DateTime-Format-DBI',
	},
);

$b->create_build_script;

sub make_feature {
  my $dbname = $db->{shift};
  return ( (lc $dbname).'_support' => {
	'description'	=> 'support for DateTime::Format::'.$dbname,
	'requires'	=> { 'DateTime::Format::'.$dbname => shift || 0 }
    })
}