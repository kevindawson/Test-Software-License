#!perl

use strict;
use warnings FATAL => 'all';

use Test::More tests => 10;

######
# let's check our subs/methods.
######

BEGIN {
	use_ok('Test::Software::License');
}

my @subs = qw(
	import
	all_software_license_ok
	_from_perlmodule_ok
	_from_perlscript_ok
	_guess_license
	_from_metayml_ok
	_from_metajson_ok
	_check_for_license_file
	_hack_guess_license_from_meta
);

foreach my $subs (@subs) {
	can_ok('Test::Software::License', $subs);
}

done_testing();

__END__

