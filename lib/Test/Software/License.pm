package Test::Software::License;

use v5.10;
use warnings;
use strict;
use Carp;

use version;
our $VERSION = '0.001002';
use English qw( -no_match_vars );    # Avoids reg-ex performance penalty
local $OUTPUT_AUTOFLUSH = 1;

use parent 0.225 qw(Exporter);

use Data::Printer {caller_info => 1, colored => 1,};
# use Software::LicenseUtils 0.103005;
use Test::Software::LicenseUtils;
use File::Slurp;
use File::Find::Rule       ();
use File::Find::Rule::Perl ();
use Try::Tiny;

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
			my @guesses = Test::Software::LicenseUtils->guess_license_from_pod($ps_text);

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
			my $meta_yml = read_file('META.yml');
			my @guess_yml
				= Test::Software::LicenseUtils->guess_license_from_meta($meta_yml);
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
			my $meta_json = read_file('META.json');
			my @guess_json
				= Test::Software::LicenseUtils->guess_license_from_meta($meta_json);

			if (@guess_json) {
				$Test->ok(1, "META.json -> @guess_json");
				$passed_a_test = TRUE;
			}
			else {
				$Test->ok(0, 'META.json -> license unknown');
				$passed_a_test = FALSE;

			}
		};
	}
	else {
		$Test->skip('no META.json found');
	}
	return;
}

1;    # Magic true value required at end of module

__END__

=pod

=encoding utf-8

=head1 NAME

Test::Software::License - just another xt for Software::License


=head1 VERSION

This document describes Test::Software::License version 0.001002


=head1 SYNOPSIS

	use Test::More;
	use Test::Requires {
		'Test::Software::License' => 0.001002,
	};

	all_software_license_ok();

	done_testing();

  
=head1 DESCRIPTION

this should be treated as beta, as initial release


=head1 METHODS

=over 4

=item * all_software_license_from_meta_ok

If you just want to test the META files only

=item * all_software_license_from_metajson_ok

=item * all_software_license_from_metayml_ok

=item * all_software_license_from_perlmodule_ok

If you just want to test the contents of lib directories

=item * all_software_license_from_perlscript_ok

If you just want to test  the contents script and bin directories

=item * all_software_license_ok

This is the main method you should use.

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

=cut

