package BaseLib;

## $Id: BaseLib.pm,v 1.4 2001/02/27 14:11:05 hasant Exp $
## Manipulate @INC dynamically for independent installation path
##
## Hasanuddin Tamir <hasant@trabas.com>
## Copyright (C) 2000 Trabas.  All rights reserved.
##
## This software is freeware.  You may redistribute it
## and/or modify it under the same terms as Perl itself.

use strict;

$BaseLib::VERSION = '0.03';

sub import {
	my $package = shift;

	# FindBin provides full path to directory the script is run from
	require FindBin;

	# untaint the path supplied by FindBin module
	croak("Invalid characters in `$FindBin::Bin'")
		unless ($BaseLib::BaseDir = $FindBin::Bin) =~ s{^([\w/.,-]+)$}{$1};

	# the base directory name is now mandatory
	my $base = shift;
	croak('No base directory supplied')
		unless defined $base && $base ne '';

	# Save the path up to basedir name and forget the rest
	croak("Couldn't find the base `$base' in `$BaseLib::BaseDir'")
		unless $BaseLib::BaseDir =~ s{^(.*/$base/).*}{$1}; # find the longest

	my $libdir = "$BaseLib::BaseDir/" . (shift || 'lib');

	# ask lib.pm to finish the job :-)
	# well, assummed it's not loaded yet
	# XXX: is it necessary to check this?
	my %inc = map { $_ => 1 } @INC;
	unless ($inc{$libdir}) {
		require lib;
		lib::import('lib', $libdir);
	}
}

# private routine
sub croak {
	require Carp;
	Carp::croak(__PACKAGE__, ": @_");
}

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;


=head1 NAME

BaseLib - manipulate @INC dynamically for independent installation path

=head1 SYNOPSIS

  use BaseLib qw(BASEDIR LIBDIR);

or just,

  use BaseLib;


=head1 DESCRIPTION

If you have a set of application with certain file structure under a
base directory, e.g. C<pim>, and it has a private modules directory
called C<lib-perl>, and it's intalled under C</usr/local>. For the
application to work, the scripts may need to say:

   use lib '/usr/local/pim/lib-perl';

Someday, you need to move the application to, say,
C</vhost/www.some.host.com>, so you need to change the use statement
all over the scripts to:

   use lib '/vhost/www.some.host.com/pim/lib-perl';

If you do this a lot and get tired of changing the line for every
different installation path, or, you don't want to bother people
using your application to cange the line to meet their conditions,
then you might need this module.

Now your scripts can say:

   use BaseLib qw(pim lib-perl);

where C<pim> and C<lib-perl> are the BASEDIR and LIBDIR arguments respectively.

So there's no need to worry about different installation layout,
wherever the C<pim> base directory is put under. The BASEDIR
argument is required while LIBDIR is optional (defaults to C<lib>).

As addition, you can use B<BaseLib>'s global package variable,
B<$BaseDir> to refer to the full path to C<pim>. For example,
assuming the application is installed under C</usr/local>, then

   print "Data dir: $BaseLib::BaseDir/data\n";

will print,

   Data dir: /usr/local/pim/data

Yes, you must qualify it with the package name since the variable is not
exportable. This may change in the future.

=head1 NOTE

Please consider this module, the code and its interface, as in ALPHA stage.
Expect any change in the future versions.

=head1 CAVEATS

I only tested it in the following environment:

   * Perl 5.005_03
   * Linux

It's unlikely to work on systems don't recognize B</> as path separator.

B<BaseLib> will find the last occurence of I<BASEDIR> string. If you mean
the base directory as C</usr/local/myapp>, while the script uses the module
locates in C</usr/local/myapp/bin/sample/myapp/test/script.pl>, then the
full path to the application base directory ends in
C</usr/local/myapp/bin/sample/myapp>.

In mod_perl environment there's a high risk for conflict on the
C<$BaseLib::BaseDir> if B<BaseLib> is used by more than one application in
the same host.

But any improvements/suggestions for wider support are welcome. A simple
comment on this module will do as well.

=head1 AUTHOR

This module is written by Hasanuddin Tamir E<lt>hasant@trabas.comE<gt>.

Copyright (C) 2000 B<Trabas>.  All rights reserved.

This software is freeware.  You may redistribute it
and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<lib>, L<FindBin>

=cut
