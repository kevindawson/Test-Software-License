#!perl

use strict;
use warnings FATAL => 'all';
use Carp::Always::Color;

use Test::More;
use Test::Requires {
	'Test::Software::License' => 0.002,
};

my $path = "t/data/11A";
chdir($path) or die "Cant chdir to $path $!";

subtest 'meta.yml with failures', sub {
Test::Software::License::_from_metayml_ok();
};

#chdir($path) or die "Cant chdir to $path $!";
chdir("../11B");
subtest 'meta.yml which should pass', sub {
Test::Software::License::_from_metayml_ok();
};


done_testing();

__END__

