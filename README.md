# NAME

Test::Software::License - just another xt for Software::License

# VERSION

This document describes Test::Software::License version 0.002000

# SYNOPSIS

	use Test::More;
	use Test::Requires { 'Test::Software::License' => 0.002 };

	all_software_license_ok();

	# the following is brutal, if it exists it must have a valid license
	# all_software_license_ok({ strict => 1 });

	done_testing();

For an example of a complete test file look in eg/xt/software-license.t

# DESCRIPTION

This is the initial release of Test::Software::License it is intended to be
used as part of your xt test.



# METHODS

- all\_software\_license\_ok

    This is the main method you should use, it uses all of the internal methods to
    check your distribution for License information. It checks the contents of
    scripts/bin along with lib, it expects to find META.\[yml|json\],
    just for good measure it checks for the presence of a LICENSE file.

    	all_software_license_ok();

    If you want to check every perl file in your distribution has a valid license
    use the following, its brutal, good for finding CPANTS issues if that is your thing.

    	all_software_license_ok({ strict => 1 });

    If you are trying to track down a issue you will get the best results with prove -lv

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
