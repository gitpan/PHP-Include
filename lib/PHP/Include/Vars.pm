package PHP::Include::Vars;
use warnings;
use strict;
use Filter::Simple;
use Parse::RecDescent;
use Data::Dumper;

our $perl = '';
our $lvalue = '';
our $rvalue = '';
my $grammar = 

<<'GRAMMAR';

php_vars:	php_start assignment(s) php_end

php_start:	/<\?php\s*/

php_end:	/\?>/

assignment:	variable | constant

variable:	lvalue /=/ rvalue /;/
		{ 
		    $PHP::Include::Vars::perl .= 
			"my $PHP::Include::Vars::lvalue = " .
			"$PHP::Include::Vars::rvalue;\n"; 
		}

constant:	/define\s*\(/ rvalue /,/ rvalue /\)/ /;/
		{ 
		    $PHP::Include::Vars::perl .= 
			"use constant $item[2] => $item[4];\n";
		}

lvalue:		/\$[a-zA-Z_][0-9a-zA-Z]*/ 
		{ 
		    $PHP::Include::Vars::lvalue = $item[1]; 
		}

rvalue:		number | string | list | bareword

number:		/-?[0-9.]+/
		{ 
		    $PHP::Include::Vars::rvalue = $item[1]; 
		}

string:		double_quoted | single_quoted
		{ 
		    $PHP::Include::Vars::rvalue = $item[1]; 
		}

double_quoted:	/".*?"/

single_quoted:	/'.*?'/

list:		/Array\s*\(/ element(s /,/) /\s*\)/
		{ 
		    $PHP::Include::Vars::rvalue = "(" .
			join( ',', @{$item[2]} ) . ")"; 
		}

element:	( associative | indexed )

associative:	rvalue /=>/ rvalue		
		{ 
		    $PHP::Include::Vars::lvalue =~ s/^\$/\%/; 
		    "$item[1]=>$item[3]";
		}

indexed:	rvalue
		{ 
		    $PHP::Include::Vars::lvalue =~ s/^\$/\@/; 
		    "$item[1]";
		}

bareword:	/[0-9a-zA-Z_]+/
		    

GRAMMAR

my $parser = Parse::RecDescent->new( $grammar );

FILTER {
    $perl = '';
    $parser->php_vars( $_ );
    print STDERR "\n\nGENERATED PERL:\n\n", $perl, "\n\n"
	if $PHP::Include::DEBUG; 
    $_ = $perl;
}

=head1 NAME

PHP::Include::Vars

=head1 SYNOPSIS

    use PHP::Include::Vars;
    <?php
    $x = Array( 1,2,3 );
    ?>
    no PHP::Include::Vars;

=head1 DESCRIPTION

Please see PHP::Include for details. PHP::Include::Vars is an implementation 
for the include_php_vars() macro.

=head1 SEE ALSO

=over 4 

=item * PHP::Include

=item * Filter::Simple

=item * Parse::RecDescent

=head1 AUTHORS

=over 4

=item * Ed Summers <ehs@pobox.com>

=cut

