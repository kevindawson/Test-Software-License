package Test::Software::License;

use 5.008004;
use warnings;
use strict;
use Carp;

use version;
our $VERSION = '0.001005';
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

use constant {FFR => 'File::Find::Rule', TRUE => 1, FALSE => 0,};

use Test::Builder 0.98;

@Test::Software::License::EXPORT = qw(
	all_software_license_ok
	all_software_license_from_perlmodule_ok
	all_software_license_from_meta_ok
	all_software_license_from_metayml_ok
	all_software_license_from_metajson_ok
);

my $passed_a_test = FALSE;


sub import {
	my $self = shift;
	my $pack = caller;
	my $Test = Test::Builder->new;

	$Test->exported_to($pack);
	$Test->plan(@_);

	$self->export_to_level(1, $self, @Test::Software::License::EXPORT);
	return;
}


sub all_software_license_ok {
	my $Test = Test::Builder->new;
	all_software_license_from_perlscript_ok();
	all_software_license_from_perlmodule_ok();
	all_software_license_from_metayml_ok();
	all_software_license_from_metajson_ok();
	all_software_license_from_LICENSE_ok();
	$Test->ok($passed_a_test,
		'This distribution appears to have a valid License');
	return;
}


sub all_software_license_from_meta_ok {
	my $Test = Test::Builder->new;
	all_software_license_from_metayml_ok();
	all_software_license_from_metajson_ok();
	$Test->ok($passed_a_test,
		'This distribution appears to have a valid License');
	return;
}


sub all_software_license_from_perlmodule_ok {
	my $Test = Test::Builder->new;

	my @files = FFR->perl_module->in('lib');

	if ($#files == -1) {
		$Test->skip('no perl_module found in lib');
	}
	else {


		my $found_perl_modules = $#files + 1;
		$Test->ok($files[0],
			'found (' . $found_perl_modules . ') perl modules to test');

		_guess_license(\@files);

	}
	return;
}


sub all_software_license_from_perlscript_ok {
	my $Test = Test::Builder->new;

	my @dirs = qw( script bin );
	foreach my $dir (@dirs) {
		my @files = FFR->perl_script->in($dir);

		if ($#files == -1) {
			$Test->skip('no perl_scripts found in ' . $dir);
		}
		else {
			my $found_perl_scripts = $#files + 1;
			$Test->ok($files[0],
				'found (' . $found_perl_scripts . ') perl script to test in ' . $dir);


			_guess_license(\@files);

		}
	}
	return;
}


#######
# composed method test for license
#######
sub _guess_license {
	my $files_ref = shift;
	my $Test      = Test::Builder->new;

	try {
		foreach my $file (@{$files_ref}) {
			my $ps_text = read_file($file);
			my @guesses = Software::LicenseUtils->guess_license_from_pod($ps_text);

			if ($#guesses >= 0) {
				$Test->ok(1, "$file -> @guesses");
				$passed_a_test = TRUE;
			}
			else {
				$Test->skip('no licence found in ' . $file);
			}
		}
	};
	return;
}


sub all_software_license_from_metayml_ok {
	my $Test = Test::Builder->new;

	if (-e 'META.yml') {
		try {
			my $meta_yml  = Parse::CPAN::Meta->load_file('META.yml');
			my @guess_yml = _hack_guess_license_from_meta($meta_yml->{license});
			if (@guess_yml) {
				$Test->ok(1, "META.yml -> @guess_yml");
				$passed_a_test = TRUE;
			}
			else {
				$Test->ok(0, 'META.yml -> license unknown');
				$passed_a_test = FALSE;
			}
		};
	}
	else {
		$Test->skip('no META.yml found');
	}
	return;
}


sub all_software_license_from_metajson_ok {
	my $Test = Test::Builder->new;

	if (-e 'META.json') {
		try {
			my $meta_json = Parse::CPAN::Meta->load_file('META.json');

			foreach my $json_license (@{$meta_json->{license}}) {
				my @guess_json = _hack_guess_license_from_meta($json_license);
				if (@guess_json) {
					$Test->ok(1, "META.json -> @guess_json");
					$passed_a_test = TRUE;
				}
				else {
					$Test->ok(0, 'META.json -> license unknown');
					$passed_a_test = FALSE;

				}
			}
		};
	}
	else {
		$Test->skip('no META.json found');
	}
	return;
}


sub all_software_license_from_LICENSE_ok {
	my $Test = Test::Builder->new;

	if (-e 'LICENSE') {
		$Test->ok(1, 'LICENSE file found');
		$passed_a_test = TRUE;
	}
	else {
		$Test->ok(0, 'LICENSE file not found');
		$passed_a_test = FALSE;
	}
	return;
}


#######
## override
#######
sub _hack_guess_license_from_meta {
	my $license_str = shift;

	my $hack = 'license : ' . $license_str;
	my @guess = Software::LicenseUtils->guess_license_from_meta($hack);
	return @guess;

}


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Test::Software::License - just another xt for Software::License

=head1 VERSION

This document describes Test::Software::License version 0.001005

=head1 SYNOPSIS

	use Test::More;
	use Test::Requires {
		'Test::Software::License' => 0.001,
	};

	all_software_license_ok();

	done_testing();

For an example of a compleat test file look in eg/test-software-license.t

=head1 DESCRIPTION

this should be treated as beta, as initial release


=head1 METHODS

=over 4

=item * all_software_license_from_meta_ok

If you just want to test the META files only you could use this method.


=item * all_software_license_from_metajson_ok

=item * all_software_license_from_metayml_ok

=item * all_software_license_from_perlmodule_ok

If you just want to test the contents of lib directories you could use this method.


=item * all_software_license_from_perlscript_ok

If you just want to test  the contents script and bin directories you could use this method.


=item * all_software_license_ok

This is the main method you should use, it uses all of the other methods to check your distributin for License information.


=item * all_software_license_from_LICENSE_ok

If you want to test for the presence of a LICENSE file you could use this method.


=item * import

=back

=head1 AUTHOR

Kevin Dawson E<lt>bowtie@cpan.orgE<gt>

=head2 CONTRIBUTORS

none at present

=head1 COPYRIGHT

Copyright E<copy> 2013 the Test::Software::License  L</AUTHOR> and L</CONTRIBUTORS>
as listed above.


=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Software::License>
L<XT::Manager>

=cut

