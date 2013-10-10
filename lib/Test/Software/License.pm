package Test::Software::License;

use v5.10;
use warnings;
use strict;
use Carp;

use version;
our $VERSION = '0.001';
use English qw( -no_match_vars );    # Avoids reg-ex performance penalty
local $OUTPUT_AUTOFLUSH = 1;

use parent 0.225 qw(Exporter);

use Data::Printer {caller_info => 1, colored => 1,};
use Software::LicenseUtils 0.103005;
use File::Slurp;
use File::Find::Rule       ();
use File::Find::Rule::Perl ();
use constant FFR => 'File::Find::Rule';
use Try::Tiny;

use Test::Builder 0.98;
@Test::Software::License::EXPORT = qw(
  run_ok
);

sub import {
  my ($self) = shift;
  my $pack = caller;

  my $Test = Test::Builder->new;

  $Test->exported_to($pack);
  $Test->plan(@_);

  $self->export_to_level(1, $self, @Test::Software::License::EXPORT);
}

sub run_ok {
	my $self = shift;
	
my $Test = Test::Builder->new;

	my $arg ||= {};
	$arg->{paths} ||= [qw( script bin lib t )];

#  my $Test = Test::Builder->new;

#  $version = _objectify_version($version);

	# my @perl_files;
	# for my $path (@{$arg->{paths}}) {
	# if (-f $path and -s $path) {
	# push @perl_files, $path;
	# }
	# elsif (-d $path) {
	# push @perl_files, File::Find::Rule->perl_file->in($path);
	# }
	# }

# p @perl_files;

	# my @files = File::Find::Rule->perl_file->in('lib');
	# my @files = FFR->perl_module;

	my @files = FFR->perl_module->in('lib');

	# p @files;

	foreach my $file (@files) {
		my $pm_text = read_file($file);
		my @guesses = Software::LicenseUtils->guess_license_from_pod($pm_text);
		if (@guesses) {
			say $file . " -> @guesses";
			$Test->ok(1, $file);
			
		}
	}
	try {
		my $meta_yml = read_file('META.yml');
		my @guess_yml
			= Software::LicenseUtils->guess_license_from_meta($meta_yml);
		say "META.yml -> @guess_yml";
		$Test->ok(1, 'META.yml');
	} catch {
		$Test->skip('no META.yml found');
		};

	try {
		my $meta_json = read_file('META.json');
		my @guess_json
			= Software::LicenseUtils->guess_license_from_meta($meta_json);
		say "META.json -> @guess_json";
		$Test->ok(1, 'META.json');
	} catch {
		# my $Test = Test::Builder->new;
		# Test->plan(skip_all => 'no META.json found');
		$Test->skip('no META.json found');
		};

}


1;    # Magic true value required at end of module
__END__

=head1 NAME

Test::Software::License - [One line description of module's purpose here]


=head1 VERSION

This document describes Test::Software::License version 0.0.1


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

kevin dawson  C<< <bowtie@cpan.org> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2013, kevin dawson C<< <bowtie@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
