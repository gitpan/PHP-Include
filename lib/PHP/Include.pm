package PHP::Include;

use strict;
use warnings;
use Filter::Simple;
use Carp qw( croak );

our $VERSION = .01;

FILTER {
    s/
	include_php_vars\s*\(\s*"(.+)"\s*\)\s*;
    /
	read_file( 'PHP::Include::Vars', $1)
    /gex;
};

sub read_file {
    my ($filter,$file) = @_;
    open( IN, $file ) || croak( "$file doesn't exist!" );
    return( 
	"use $filter;\n" .
	join( '', <IN> ) .
	"no $filter;\n"
    );
    close( IN );
}

1;

=head1 NAME

PHP::Include - Include PHP files in Perl 

=head1 SYNOPSIS

    use PHP::Include;

=head1 DESCRIPTION

PHP::Include builds on the shoulders of Filter::Simple and Parse::RecDescent to
provide a Perl utility for including very simple PHP Files from a Perl program.

When working with Perl and PHP it is often convenient to be able to share
configuration data between programs written in both languages.  One solution to
this would be to use a language independent configuration file (did I hear
someone say XML?). Another solution is to use Perl's flexibility to read PHP
and rewrite it as Perl. PHP::Include does the latter with the help of
Filter::Simple and Parse::RecDescent to rewrite very simple PHP as Perl.

Filter::Simple is used to enable macros (at the moment only one) which 
cause PHP to be interpolated into your Perl source code, which is then parsed
using a Parse::RecDescent grammar to generate the appropriate Perl.

PHP::Include was designed to allow the more adventurous to add grammars that 
extend the complexity of PHP that may be included. 

=head1 EXPORTS

=head2 import_php_vars( file )

This function is actually a macro that allows you to include PHP variable
declarations in much the same way that you might C<require> a file of Perl 
code. For example, given a file of PHP variable declarations:

    <?php

    $robot = 'Book Agent';
    $port = 80;
    $hosts = Array( 
	'www.amazon.com'	=> 'Amazon',
	'www.bn.com'		=> 'Barnes and Noble',
	'www.bookpool.com'	=> 'BookPool'
    );
    $times = Array( 10,12,14,16,18 );

    ?>

You can use this from your Perl program like so:

    use PHP::Include;
    include_php_vars( 'file.php' );

Behind the scenes the PHP is rewritten as this Perl:

    my $robot = 'Book Agent';
    my $port = 80;
    my %hosts = (
	'www.amazon.com'	=> 'Amazon',
	'www.bn.com'		=> 'Barnes & Noble',
	'www.bookpool.com'	=> 'BookPool'
    );
    my @times = Array( 10,12,14,16,18 );

Notice that the enclosing E<lt>php? and E<lt>? are removed, all variables are 
lexically scoped with 'my' and that the $ sigils are changed as appropriate to 
(@ and %). Apart from that PHP and Perl are very similar.

=head1 TODO

=over 4

=item * ability to cause 'my' not to be inserted 

=item * grammar additions to ignore comments

=item * assigning directly to array elements 

=item * diagnostics on STDERR 

=head1 SEE ALSO

=over 4

=item * PHP::Include::Vars

=item * Filter::Simple

=item * Parse::RecDescent

=head1 AUTHOR

Ed Summers, E<lt>ehs@pobox.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2002 by Ed Summers

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
