# cpanfile
requires 'perl', '5.008004';

requires 'Carp',                   '1.32';
requires 'Exporter',               '5.68';
requires 'File::Find::Rule',       '0.33';
requires 'File::Find::Rule::Perl', '1.13';
requires 'File::Slurp',            '9999.19';
requires 'Parse::CPAN::Meta',      '1.4409';
requires 'Software::LicenseUtils', '0.103006';
requires 'Test::Builder',          '0.99';
requires 'Try::Tiny',              '0.18';
requires 'constant',               '1.27';
requires 'parent',                 '0.228';
requires 'version',                '0.9904';

on test => sub {
	requires 'Test::More',     '0.99';
	requires 'Test::Requires', '0.07';

	suggests 'ExtUtils::MakeMaker',   '6.8';
	suggests 'File::Spec::Functions', '3.4';
	suggests 'List::Util',            '1.35';
	suggests 'Test::Pod',             '1.48';
	suggests 'Test::Pod::Coverage',   '1.08';
};
