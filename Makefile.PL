use 5.003;
use ExtUtils::MakeMaker;
# $Id: Makefile.PL,v 1.1 2003/06/16 15:06:05 cfaerber Exp $
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'DateTime::Format::DBI',
    'VERSION_FROM'	=> 'lib/DateTime/Format/DBI.pm', # finds $VERSION
    'PREREQ_PM'		=> {
		'DateTime' => 0.10,
	},
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'lib/DateTime/Format/DBI.pm', # retrieve abstract from module
       AUTHOR     => 'Claus Färber <perl@faerber.muc.de>') : ()),
);
