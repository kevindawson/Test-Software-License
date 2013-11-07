#!perl

use strict;
use warnings FATAL => 'all';

use English qw( -no_match_vars );
local $OUTPUT_AUTOFLUSH = 1;

use Test::More tests => 14;

# Check dependencies that are not checked but  Test::Software::License.pm itself
BEGIN {
	use_ok('Test::Software::License', '0.002');
	use_ok('Exporter',                '5.68');
	use_ok('File::Find::Rule',        '0.33');
	use_ok('File::Find::Rule::Perl',  '1.13');
	use_ok('File::Slurp',             '9999.19');
	use_ok('Parse::CPAN::Meta',       '1.4409');
	use_ok('Software::LicenseUtils',  '0.103007');
	use_ok('Test::Builder',           '1.001002');
	use_ok('Try::Tiny',               '0.18');
	use_ok('constant',                '1.27');
	use_ok('parent',                  '0.228');
	use_ok('version',                 '0.9904');

	use_ok('Test::More',     '1.001002');
	use_ok('Test::Requires', '0.07');
}

diag(
	"Info: Testing Test::Software::License $Test::Software::License::VERSION");

done_testing();

__END__

