# NAME

Test::Software::License - just another xt for Software::License

# VERSION

This document describes Test::Software::License version 0.001005

# SYNOPSIS

	use Test::More;
	use Test::Requires {
		'Test::Software::License' => 0.001,
	};

	all_software_license_ok();

	done_testing();

see eg/ for a compleat test files

# DESCRIPTION

this should be treated as beta, as initial release



# METHODS

- all\_software\_license\_from\_meta\_ok

    If you just want to test the META files only

- all\_software\_license\_from\_metajson\_ok
- all\_software\_license\_from\_metayml\_ok
- all\_software\_license\_from\_perlmodule\_ok

    If you just want to test the contents of lib directories

- all\_software\_license\_from\_perlscript\_ok

    If you just want to test  the contents script and bin directories

- all\_software\_license\_ok

    This is the main method you should use.

- import

# AUTHOR

Kevin Dawson <bowtie@cpan.org>

## CONTRIBUTORS

none at present

# COPYRIGHT

Copyright &copy; 2013 the Test::Software::License  ["AUTHOR"](#AUTHOR) and ["CONTRIBUTORS"](#CONTRIBUTORS)
as listed above.



# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[Software::License](http://search.cpan.org/perldoc?Software::License)
[XT::Manager](http://search.cpan.org/perldoc?XT::Manager)
