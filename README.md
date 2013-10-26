# NAME

Test::Software::License - just another xt for Software::License

# VERSION

This document describes Test::Software::License version 0.001007

# SYNOPSIS

	use Test::More;
	use Test::Requires {
		'Test::Software::License' => 0.001,
	};

	all_software_license_ok();

	# the following is brutal, if it exists it must have a license
	# all_software_license_ok({ strict => 1 });

	done_testing();

For an example of a complete test file look in eg/test-software-license.t

# DESCRIPTION

this should be treated as beta, as initial release



# METHODS

- all\_software\_license\_ok

    This is the main method you should use, it uses all of the other methods to
    check your distribution for License information.

    	all_software_license_ok();

    If you want to check every perl file in your distribution has a valid license
    use the following, its brutal, good for finding CPANTS issues if that is your thing.

    	all_software_license_ok({ strict => 1 });

- import

# AUTHOR

Kevin Dawson <bowtie@cpan.org>

## CONTRIBUTORS

none at present

# COPYRIGHT

Copyright &copy; 2013 the Test::Software::License
["AUTHOR"](#AUTHOR) and ["CONTRIBUTORS"](#CONTRIBUTORS) as listed above.



# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[Software::License](http://search.cpan.org/perldoc?Software::License)
[XT::Manager](http://search.cpan.org/perldoc?XT::Manager)
