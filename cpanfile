# cpanfile
requires 'perl', '5.010000';

requires 'Carp',                   '1.32';
requires 'Data::Printer',          '0.35';
requires 'English',                '0';
requires 'Exporter',               '5.68';
requires 'File::Find::Rule',       '0.33';
requires 'File::Find::Rule::Perl', '1.13';
requires 'File::Slurp',            '9999.19';
requires 'Software::LicenseUtils', '0.103005';
requires 'Test::Builder',          '0.98';
requires 'Try::Tiny',              '0.18';
requires 'constant',               '1.27';
requires 'parent',                 '0.228';
requires 'strict',                 '0';
requires 'version',                '0.9904';
requires 'warnings',               '0';

on test => sub {
	requires 'Test::More', '0.98';

	suggests 'Test::Pod',           '1.48';
	suggests 'Test::Pod::Coverage', '1.08';
};

on develop => sub {
};
