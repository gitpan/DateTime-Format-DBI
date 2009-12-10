use 5.003;
use ExtUtils::MakeMaker;
# $Id: Makefile.PL 4365 2009-12-10 18:11:51Z cfaerber $
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'DateTime::Format::DBI',
    'VERSION_FROM'	=> 'lib/DateTime/Format/DBI.pm', # finds $VERSION
    'PREREQ_PM'		=> {
		'DateTime' => 0.10,
		'DBI'	   => 1.21,
	},
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'lib/DateTime/Format/DBI.pm', # retrieve abstract from module
       AUTHOR     => 'Claus Faerber <CFAERBER@cpan.org>',
       LICENSE	  => 'perl'
    ) : ()),

    $ExtUtils::MakeMaker::VERSION < 6.18 ? () : (
	'SIGN'		=> 1,
    ),

    $ExtUtils::MakeMaker::VERSION < 6.45 ? () : (
	'META_MERGE'	=> { 
	    'requires'	    => { 'perl'	=> 5.003, },
#	    'recommends'    => { 'perl'	=> 5.008003, },
        },
    ),
);

sub MY::postamble {
return <<EOF
release: release-cpan

release-cpan:
	cpan-upload \$(DISTVNAME).tar\$(SUFFIX)

EOF
}
