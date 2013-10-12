package Test::Software::License;

use v5.10;
use warnings;
use strict;
use Carp;

use version;
our $VERSION = '0.001000';
use English qw( -no_match_vars );    # Avoids reg-ex performance penalty
local $OUTPUT_AUTOFLUSH = 1;

use parent 0.225 qw(Exporter);

use Data::Printer {caller_info => 1, colored => 1,};
use Software::LicenseUtils 0.103005;
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
	my ($self) = shift;
	my $pack = caller;

	my $Test = Test::Builder->new;

	$Test->exported_to($pack);
	$Test->plan(@_);

	$self->export_to_level(1, $self, @Test::Software::License::EXPORT);
}

sub all_software_license_ok {
	my $self = shift;
	my $Test = Test::Builder->new;
	all_software_license_from_perlmodule_ok();
	all_software_license_from_metayml_ok();
	all_software_license_from_metajson_ok();
	$Test->ok($passed_a_test, 'This distribution apers to have a valid License');
}

sub all_software_license_from_meta_ok {
	my $self = shift;
	my $Test = Test::Builder->new;
	all_software_license_from_metayml_ok();
	all_software_license_from_metajson_ok();
	$Test->ok($passed_a_test, 'This distribution appiers to have a valid License');
}

sub all_software_license_from_perlmodule_ok {
	my $self = shift;
	my $Test = Test::Builder->new;

	my @files              = FFR->perl_module->in('lib');
	my $found_perl_modules = $#files + 1;
	$Test->ok($files[0],
		'found (' . $found_perl_modules . ') perl modules to test');

	try {
		foreach my $file (@files) {
			my $pm_text = read_file($file);
			my @guesses = Software::LicenseUtils->guess_license_from_pod($pm_text);
			if (@guesses) {

				# say $file . " -> @guesses";
				$Test->ok(1, "$file -> @guesses");
				$passed_a_test = TRUE;
			}
		}
	}
	catch {
		$Test->skip('no perl_modules found');
	};
}


sub all_software_license_from_metayml_ok {
	my $self = shift;
	my $Test = Test::Builder->new;

	if (-e 'META.yml') {
		try {
			my $meta_yml = read_file('META.yml');
			my @guess_yml
				= Software::LicenseUtils->guess_license_from_meta($meta_yml);

			# p @guess_yml;
			# say "META.yml -> @guess_yml";
			if (@guess_yml) {
				$Test->ok(1, "META.yml -> @guess_yml");
				$passed_a_test = TRUE;
			}
			else {
				# $Test->skip('META.yml license unknown');
				$Test->ok(0, 'META.yml -> license unknown');
				$passed_a_test = FALSE;
			}
		};
	}
	else {
		$Test->skip('no META.yml found');
	}
}

sub all_software_license_from_metajson_ok {
	my $self = shift;
	my $Test = Test::Builder->new;

# try{
	if (-e 'META.json') {
	try {
		my $meta_json = read_file('META.json');
		my @guess_json
			= Software::LicenseUtils->guess_license_from_meta($meta_json);

		# say "META.json -> @guess_json";
		if (@guess_json) {
			$Test->ok(1, "META.json -> @guess_json");
			$passed_a_test = TRUE;
		}
		else {
			# $Test->skip('META.json license unknown');
			$Test->ok(0, 'META.json -> license unknown');
			$passed_a_test = FALSE;
			
		}
	};
	}
	else {
		$Test->skip('no META.json found');
	}
# };
}

1;    # Magic true value required at end of module

__END__

=pod

=encoding utf-8

=head1 NAME

Test::Software::License - [One line description of module's purpose here]


=head1 VERSION

This document describes Test::Software::License version 0.001000


=head1 SYNOPSIS

    use Test::Software::License;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.
  
  
=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE 

=for author to fill in:
    Write a separate section listing the public components of the modules
    interface. These normally consist of either subroutines that may be
    exported, or methods that may be called on objects belonging to the
    classes provided by the module.


=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.
  
Test::Software::License requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.


=head1 INCOMPATIBILITIES

=for author to fill in:
    A list of any modules that this module cannot be used in conjunction
    with. This may be due to name conflicts in the interface, or
    competition for system or program resources, or due to internal
    limitations of Perl (for example, many modules that use source code
    filters are mutually incompatible).

None reported.


=head1 BUGS AND LIMITATIONS

=for author to fill in:
    A list of known problems with the module, together with some
    indication Whether they are likely to be fixed in an upcoming
    release. Also a list of restrictions on the features the module
    does provide: data types that cannot be handled, performance issues
    and the circumstances in which they may arise, practical
    limitations on the size of data sets, special cases that are not
    (yet) handled, etc.

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-test-software-license@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

kevin dawson E<lt>bowtie@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2013- Kevin Dawson

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

