# $Id: 00basic.t 4063 2008-09-13 16:49:41Z cfaerber $
use Test::More tests => 2;
use Test::NoWarnings;

BEGIN { 
  use_ok('DateTime::Format::DBI')
};
