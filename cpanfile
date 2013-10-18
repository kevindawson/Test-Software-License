# cpanfile
requires 'perl', '5.008009';

requires 'Carp',                   '1.32';
requires 'Exporter',               '5.68';
requires 'File::Find::Rule',       '0.33';
requires 'File::Find::Rule::Perl', '1.13';
requires 'File::Slurp',            '9999.19';
requires 'File::Spec',             '3.4';
requires 'IO::Dir',                '1.07';
requires 'Module::Load',           '0.24';
requires 'Parse::CPAN::Meta',      '1.4409';
requires 'Software::License',      '0.103005';
requires 'Test::Builder',          '0.99';
requires 'Try::Tiny',              '0.18';
requires 'constant',               '1.27';
requires 'parent',                 '0.228';
requires 'version',                '0.9904';

on test => sub {
	requires 'Test::More',     '0.99';
	requires 'Test::Requires', '0.07';

	suggests 'Test::Pod',           '1.48';
	suggests 'Test::Pod::Coverage', '1.08';
};
