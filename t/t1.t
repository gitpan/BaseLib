# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

use vars '$lib_dir';
BEGIN {
    use FindBin '$Bin';
    $lib_dir = "$Bin/../lib";
    mkdir $lib_dir, 0755
        or die "failed to create $lib_dir: $!";
    open LIB, ">$lib_dir/Empty.pm"
        or die "Failed to create $lib_dir/Empty.pm: $!";
    print LIB "package Empty;\n1\n";
    close LIB;
}

BEGIN { $| = 1; print "1..3\n"; }
END {print "not ok 1\n" unless $loaded;}
use BaseLib ("BaseLib-$BaseLib::VERSION", 'lib');
use Empty;
$loaded = 1;
print "ok 1\n";

print 'not ' unless "$BaseLib::BaseDir/lib" eq $INC[0];
print "ok 2\n";

system 'perl', "$Bin/s/s.pl";
print 'not ' if $?;
print "ok 3\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

END {
unlink "$lib_dir/Empty.pm";
rmdir $lib_dir;
}
