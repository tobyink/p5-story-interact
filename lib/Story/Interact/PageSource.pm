use 5.010001;
use strict;
use warnings;

package Story::Interact::PageSource;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.001002';

use Story::Interact::Page ();
use Story::Interact::Syntax ();

use Moo::Role;
use Types::Common -types;
use Carp qw( croak );
use Safe ();
use namespace::clean;

requires 'get_source_code';

sub get_page {
	my ( $self, $state, $page_id ) = @_;
	my $code = $self->get_source_code( $page_id );

	return Story::Interact::Page->new( id => ':end' ) unless $code;

	Story::Interact::Syntax::START( $state, $page_id );
	eval( "package Story::Interact::Syntax; use strict; use warnings; no warnings qw( numeric uninitialized ); $code; 1" )
		or croak( "Died on page '$page_id': $@" );
	return Story::Interact::Syntax::FINISH( $state );
}

1;
