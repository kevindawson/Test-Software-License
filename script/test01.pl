#!perl

use 5.010001;
use strict;
use warnings;

use version;
our $VERSION = '0.001';
use English qw( -no_match_vars ); # Avoids reg-ex performance penalty
local $OUTPUT_AUTOFLUSH = 1;

use Data::Printer { caller_info => 1, colored => 1, };

# we are doing this so we can run from git during development
# perl ~/GitHub/App-Midgen/script/midgen
use FindBin qw($Bin);
use lib map {"$Bin/$_"} qw( lib ../lib );


say 'Start';

use Test::More;
use Test::Requires {
	'Test::Software::License' => 0.001,
};


run_ok();

done_testing();
say 'END';

exit(0);