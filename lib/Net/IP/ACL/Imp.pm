
package Net::IP::ACL::Imp;

use Moose;
use Net::IP::ACL::Bit;
use Net::IP::ACL::Entry;
use Data::Dumper;

has '_top' => ( isa     => 'Net::IP::ACL::Bit',
		is      => 'ro',
		default => sub { new Net::IP::ACL::Bit( bit => 0 ) } );
has '_bit_length' => ( isa      => 'Int',
		       is       => 'ro',
		       required => 1 );

=head1 NAME

Net::IP::ACL::Imp - Implementation of Access Control List.

=head1 SYNOPSIS

Quick summary of what the module does.

    use Net::IP::ACL::Imp;

    my $my_network = new Net::IP::ACL::Entry(
        address => '172.16.10.0/24',
        name    => 'my network',
        value   => 1,
    );

    # make ACL for IPv4.
    my $_acl_v4 = new Net::IP::ACL::Imp( _bit_length => 32 );
    $_acl_v4->add( $my_network );
    $_acl_v4->add( $group_network );
    $_acl_v4->add( $my_host );

    $_acl_v4->match( '10.0.0.1' );                  # unmatched, return undef.

    $_acl_v4->match( '172.16.10.100' );             # matched, return $.

    print $acl_entry3->name;                        # "my host"

=head1 SUBROUTINES/METHODS

=head2 new( _bit_length => $bit_length )

Bit length of IP address, Bit length of IPv4 address length is 32, bit length of IPv6 address is 128.

=head2 add( $acl_entry )

add acl_entry, and return self.

=cut

sub add {
    my $this = shift;
    my ( $ac ) = @_;

    my $node = $this->_top();
    for ( my $i = 1 ; $i <= $this->_bit_length + 1; $i++ ) {
	my $bit = Net::IP::ACL::Entry::bit_n( $this->_bit_length - $i );
	if ( ! ( $ac->netmask & $bit ) ) {
	    $node->acl_entry( $ac );
	    last;
	}

	if ( $ac->network & $bit ) {
	    if ( ! defined( $node->next_1 ) ) {
		$node->next_1( new Net::IP::ACL::Bit( bit => 1 ) );
	    }
	    $node = $node->next_1;
	}
	else {
	    if ( ! defined( $node->next_0 ) ) {
		$node->next_0( new Net::IP::ACL::Bit( bit => 0 ) );
	    }
	    $node = $node->next_0;
	}
    }

    return $this;
}


=head2 match( $address )

whether IP address $address is matched or not.
If $address is matched, this method return matched Net::IP::ACL::Entry.
If not matched, this method return undef.

=cut

sub match {
    my $this = shift;
    my ( $address ) = @_;

    my $address_binary    = $address->intip();
    my $node              = $this->_top();
    my $matched_acl_entry = undef;
    my $i                 = 0;

    while ( $node ) {
	my $bit = Net::IP::ACL::Entry::bit_n( $this->_bit_length - 1 - $i );

	if ( $node->acl_entry ) {
	    $matched_acl_entry = $node->acl_entry;
	}
	if ( $bit & $address_binary ) {
	    $node = $node->next_1;
	}
	else {
	    $node = $node->next_0;
	}
	$i++;
    }

    return $matched_acl_entry;
}


=head2 print_bits

Print bit pattern to STDERR for debug.

=cut

sub print_bits {
    my $this = shift;
    my ( $num ) = @_;

    for ( my $i = 0 ; $i < $this->_bit_length ; $i++ ) {
	if ( $i % 8 == 0 ) {
	    print STDERR " ";
	}
	my $bit = Net::IP::ACL::Entry::bit_n( $this->_bit_length - $i - 1 );
	printf STDERR "%d", $bit & $num ? 1 : 0;
    }
    print STDERR "\n";
}

1;
