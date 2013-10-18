package Test::Software::LicenseUtils;

use strict;
use warnings;

use Software::License 0.103005;
# use Data::Printer {caller_info => 1, colored => 1,};
use version;
our $VERSION = '0.001003';

# ABSTRACT: little useful bits of code for licensey things

use File::Spec;
use IO::Dir;
use Module::Load;

my $_v = qr/(?:v(?:er(?:sion|\.))(?: |\.)?)/i;
my @phrases = (
  "under the same (?:terms|license) as perl $_v?6" => [],
  'under the same (?:terms|license) as (?:the )?perl'    => 'Perl_5',
  'affero g'                                    => 'AGPL_3',
  "GNU (?:general )?public license,? $_v?([123])" => sub { "GPL_$_[0]" },
  'GNU (?:general )?public license'             => [ map {"GPL_$_"} (1..3) ],
  "GNU (?:lesser|library) (?:general )?public license,? $_v?([23])\\D"  => sub {
    $_[0] == 2 ? 'LGPL_2_1' : $_[0] == 3 ? 'LGPL_3_0' : ()
  },
  'GNU (?:lesser|library) (?:general )?public license'  => [ qw(LGPL_2_1 LGPL_3_0) ],
  'BSD license'                => 'BSD',
  "Artistic license $_v?(\\d)" => sub { "Artistic_$_[0]_0" },
  'Artistic license'           => [ map { "Artistic_$_\_0" } (1..2) ],
  "LGPL,? $_v?(\\d)"             => sub {
    $_[0] == 2 ? 'LGPL_2_1' : $_[0] == 3 ? 'LGPL_3_0' : ()
  },
  'LGPL'                       => [ qw(LGPL_2_1 LGPL_3_0) ],
  "GPL,? $_v?(\\d)"              => sub { "GPL_$_[0]_0" },
  'GPL'                        => [ map { "GPL_$_\_0" } (1..3) ],
  'BSD'                        => 'BSD',
  'Artistic'                   => [ map { "Artistic_$_\_0" } (1..2) ],
  'MIT'                        => 'MIT',
);

# see https://github.com/rjbs/Software-License/pull/16/files
my %meta_keys = ();

# find all known Software::License::* modules and get identification data
for my $lib ( map { "$_/Software/License" } @INC ) {
    next unless -d $lib;
    for my $file ( IO::Dir->new($lib)->read ) {
        next unless $file =~ m{\.pm$};
        # if it fails, ignore it
        eval {
            (my $mod = $file ) =~ s{\.pm$}{};
            my $class = "Software::License::$mod";
            load $class;
            $meta_keys{ $class->meta_name  }{$mod} = undef;
            $meta_keys{ $class->meta2_name }{$mod} = undef;
            my $name = $class->name;
            unshift @phrases, qr/\Q$name\E/, [ $mod ];
        }
    }
}

sub guess_license_from_pod {
  my ($class, $pm_text) = @_;
  die "can't call guess_license_* in scalar context" unless wantarray;

	if (
		$pm_text =~ m/
      (
        =head \d \s+
        (?:licen[cs]e|licensing|copyright|legal)\b
        .*?
      )
      (=head\\d.*|=cut.*|)
      \z
    /ixms
  ) {
		my $license_text = $1;

    for (my $i = 0; $i < @phrases; $i += 2) {
      my ($pattern, $license) = @phrases[ $i .. $i+1 ];
			$pattern =~ s{\s+}{\\s+}g
				unless ref $pattern eq 'Regexp';
			if ( $license_text =~ /$pattern/i ) {
        my $match = $1;
				# if ( $osi and $license_text =~ /All rights reserved/i ) {
				# 	warn "LEGAL WARNING: 'All rights reserved' may invalidate Open Source licenses. Consider removing it.";
				# }
        my @result = (ref $license||'') eq 'CODE'  ? $license->($match)
                   : (ref $license||'') eq 'ARRAY' ? @$license
                   :                                 $license;

        return unless @result;
				return map { "Software::License::$_" } @result;
			}
		}
	}

	return;
}


sub guess_license_from_meta {
  my ($class, $meta_text) = @_;
  die "can't call guess_license_* in scalar context" unless wantarray;

# see https://github.com/rjbs/Software-License/pull/17/files
#  my ($license_text) = $meta_text =~ m{\b["']?license["']?\s*:\s*\[?\s*["']?([a-z_]+)["']?}gm or return;


  my ($license_text) = $meta_text =~ m{\b["']?license["']?\s*:\s*\[?\s*["']?([a-z_]+[\d]*)["']?}gm;

  return unless $license_text and my $license = $meta_keys{ $license_text };

  return map { "Software::License::$_" } sort keys %$license;
}

*guess_license_from_meta_yml = \&guess_license_from_meta;



1;

__END__

=pod

=encoding utf-8

=head1 NAME

Test::Software::LicenseUtils - add a hacked local LicenseUtils
  
=head1 DESCRIPTION

This is a hack of Software::LicenseUtils which includes #issue16 and #issue17


=head1 METHODS

=over 4

=item * guess_license_from_pod

  my @guesses = Software::LicenseUtils->guess_license_from_pod($pm_text);

Given text containing POD, like a .pm file, this method will attempt to guess
at the license under which the code is available.  This method will either
a list of Software::License classes (or instances) or false.

Calling this method in scalar context is a fatal error.

=item * guess_license_from_meta

  my @guesses = Software::LicenseUtils->guess_license_from_meta($meta_str);

Given the content of the META.(yml|json) file found in a CPAN distribution, this
method makes a guess as to which licenses may apply to the distribution.  It
will return a list of zero or more Software::License instances or classes.


=back


=head1 AUTHOR

See L<Test::Software::License>

=head2 CONTRIBUTORS

See L<Test::Software::License>

=head1 COPYRIGHT

See L<Test::Software::License>

=head1 LICENSE

See L<Test::Software::License>

=cut

