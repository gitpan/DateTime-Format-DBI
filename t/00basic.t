# $Id: 00basic.t 4449 2010-07-28 12:05:47Z cfaerber $
use Test::More tests => 2;
use Test::NoWarnings;

BEGIN { 
  use_ok('DateTime::Format::DBI')
};
