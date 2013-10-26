package Test::Software::License;

use 5.008004;
use warnings;
use strict;
use Carp;

use version;
our $VERSION = '0.001007';
use English qw( -no_match_vars );    # Avoids reg-ex performance penalty
local $OUTPUT_AUTOFLUSH = 1;

use parent 0.225 qw(Exporter);

# use Data::Printer {caller_info => 1, colored => 1,};
use Software::LicenseUtils 0.103006;

use File::Slurp;
use File::Find::Rule       ();
use File::Find::Rule::Perl ();
use Try::Tiny;
use Parse::CPAN::Meta 1.4405;

use constant {FFR => 'File::Find::Rule', TRUE => 1, FALSE => 0, EMPTY => -1};

use Test::Builder 0.98;

@Test::Software::License::EXPORT = qw(
	all_software_license_ok
);

my $passed_a_test = FALSE;

#######
# import
#######
sub import {
	my ($self, @args) = @_;
	my $pack = caller;
	my $test = Test::Builder->new;

	$test->exported_to($pack);
	$test->plan(@args);

	$self->export_to_level(1, $self, @Test::Software::License::EXPORT);
	return 1;
}

#######
# all_software_license_ok
#######
sub all_software_license_ok {
	my $options = shift if ref $_[0] eq 'HASH';
	$options ||= {strict => FALSE};
	my $test = Test::Builder->new;
	_from_perlscript_ok($options);
	_from_perlmodule_ok($options);
	_from_metayml_ok($options);
	_from_metajson_ok($options);
	_check_for_license_file($options);

	if (not $options->{strict}) {
		$test->ok($passed_a_test,
			'This distribution appears to have a valid License');
	}
	return;
}

#######
# _from_perlmodule_ok
#######
sub _from_perlmodule_ok {
	my $options = shift;
	my $test    = Test::Builder->new;
	my @files   = FFR->perl_module->in('lib');

	if ($#files == EMPTY) {
		$test->skip('no perl_module found in lib');
	}
	else {
		if (not $options->{strict}) {
			my $found_perl_modules = $#files + 1;
			$test->ok($files[0],
				'found (' . $found_perl_modules . ') perl modules to test');
		}
		_guess_license($options, \@files);
	}
	return;
}

#######
# _from_perlscript_ok
#######
sub _from_perlscript_ok {
	my $options = shift;
	my $test    = Test::Builder->new;

	my @dirs = qw( script bin );
	foreach my $dir (@dirs) {
		my @files = FFR->perl_script->in($dir);
		if ($#files == EMPTY) {
			$test->skip('no perl_scripts found in ' . $dir);
		}
		else {
			if (not $options->{strict}) {
				my $found_perl_scripts = $#files + 1;
				$test->ok($files[0],
					"found ($found_perl_scripts) perl script to test in $dir");
			}
			_guess_license($options, \@files);
		}
	}
	return;
}

#######
# composed method test for license
#######
sub _guess_license {
	my $options   = shift;
	my $files_ref = shift;
	my $test      = Test::Builder->new;

	try {
		foreach my $file (@{$files_ref}) {
			my $ps_text = read_file($file);
			my @guesses = Software::LicenseUtils->guess_license_from_pod($ps_text);
			if ($options->{strict}) {
				$test->ok($guesses[0], "$file -> @guesses");
			}
			else {
				if ($#guesses >= 0) {
					$test->ok(1, "$file -> @guesses");
					$passed_a_test = TRUE;
				}
				else {
					$test->skip('no licence found in ' . $file);
				}
			}
		}
	};
	return;
}

#######
# _from_metayml_ok
#######
sub _from_metayml_ok {
	my $options = shift;
	my $test    = Test::Builder->new;

	if (-e 'META.yml') {
		try {
			my $meta_yml  = Parse::CPAN::Meta->load_file('META.yml');
			my @guess_yml = _hack_guess_license_from_meta($meta_yml->{license});
			if ($options->{strict}) {
				$test->ok($guess_yml[0], "META.yml -> @guess_yml");
			}
			else {
				if (@guess_yml) {
					$test->ok(1, "META.yml -> @guess_yml");
					$passed_a_test = TRUE;
				}
				else {
					$test->ok(0, 'META.yml -> license unknown');
					$passed_a_test = FALSE;
				}
			}
		};
	}
	else {
		$test->skip('no META.yml found');
	}
	return;
}

#######
# _from_metajson_ok
#######
sub _from_metajson_ok {
	my $options = shift;
	my $test    = Test::Builder->new;

	if (-e 'META.json') {
		try {
			my $meta_json = Parse::CPAN::Meta->load_file('META.json');
			foreach my $json_license (@{$meta_json->{license}}) {
				my @guess_json = _hack_guess_license_from_meta($json_license);
				if ($options->{strict}) {
					$test->ok($guess_json[0], "META.json -> @guess_json");
				}
				else {
					if (@guess_json) {
						$test->ok(1, "META.json -> @guess_json");
						$passed_a_test = TRUE;
					}
					else {
						$test->ok(0, 'META.json -> license unknown');
						$passed_a_test = FALSE;
					}
				}
			}
		};
	}
	else {
		$test->skip('no META.json found');
	}
	return;
}

#######
# _check_for_license_file
#######
sub _check_for_license_file {
	my $options = shift;
	my $test    = Test::Builder->new;

	if ($options->{strict}) {
		$test->ok(-e 'LICENSE', 'LICENSE file found');
	}
	else {
		if (-e 'LICENSE') {
			$test->ok(1, 'LICENSE file found');
		}
		else {
			$test->skip('no LICENSE file found');
		}
	}
	return;
}

#######
## hack to support meta license strings
#######
sub _hack_guess_license_from_meta {
	my $license_str = shift;
	my @guess;
	try {
		my $hack = 'license : ' . $license_str;
		@guess = Software::LicenseUtils->guess_license_from_meta($hack);
	};
	return @guess;
}


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Test::Software::License - just another xt for Software::License

=head1 VERSION

This document describes Test::Software::License version 0.001007

=head1 SYNOPSIS

	use Test::More;
	use Test::Requires {
		'Test::Software::License' => 0.001,
	};

	all_software_license_ok();

	# the following is brutal, if it exists it must have a license
	# all_software_license_ok({ strict => 1 });

	done_testing();

For an example of a complete test file look in eg/test-software-license.t

=head1 DESCRIPTION

this should be treated as beta, as initial release


=head1 METHODS

=over 4

=item * all_software_license_ok

This is the main method you should use, it uses all of the other methods to
check your distribution for License information.

	all_software_license_ok();

If you want to check every perl file in your distribution has a valid license
use the following, its brutal, good for finding CPANTS issues if that is your thing.

	all_software_license_ok({ strict => 1 });

=item * import

=back

=head1 AUTHOR

Kevin Dawson E<lt>bowtie@cpan.orgE<gt>

=head2 CONTRIBUTORS

none at present

=head1 COPYRIGHT

Copyright E<copy> 2013 the Test::Software::License
L</AUTHOR> and L</CONTRIBUTORS> as listed above.


=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Software::License>
L<XT::Manager>

=cut

