use 5.006;
use strict;
use warnings FATAL => 'all';
use inc::Module::Install;

name     'Test-Software-License';
all_from 'lib/Test/Software/License.pm';
author   q{kevin dawson <bowtie@cpan.org>};
license  'perl';

perl_version 5.006;

tests_recursive('t');

resources (
   #homepage   => 'http://yourwebsitehere.com',
   #IRC        => 'irc://irc.perl.org/#Test-Software-License',
   license    => 'http://dev.perl.org/licenses/',
   #repository => 'git://github.com/kevin dawson/Test-Software-License.git',
   bugtracker => 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Test-Software-License',
);

configure_requires (
   'Module::Install' => 0,
);

build_requires (
   'Test::More' => 0,
);

requires (
   #'ABC'              => 1.6,
   #'Foo::Bar::Module' => 5.0401,
);

install_as_cpan;
auto_install;
WriteAll;
