package Net::IP::ACL::Entry;

use Moose;
use Net::IP;
use Net::IP::ACL::Exception;
use Math::BigInt;
use Data::Dumper;

has 'address' => ( isa => 'Net::IP',    is => 'ro', required => 1 );
has 'name'    => ( isa => 'Maybe[Str]', is => 'ro' );
has 'value'   => ( isa => 'Any',        is => 'rw' );

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;
    my $args  = $class->$orig( @_ );

    if ( ! exists( $args->{address} ) ) {
	Net::IP::ACL::ArugmentError->throw(
	    error_message => "new Net::IP::ACL::Entry must be specified address.",
	);
    }

    if ( ! defined( blessed( $args->{address} ) ) ) {
	$args->{address} = new Net::IP( $args->{address} );
	if ( ! $args->{address} ) {
	    Net::IP::ACL::ArugmentError->throw(
		error_message => q{address must be Net::IP instance or "network/netmask" string},
	    );
	}
    }

    return $args;
};


=head1 NAME

Net::IP::ACL::Entry - Network ACL entry.

=head1 SYNOPSIS

Quick summary of what the module does.

    # log server
    use Net::IP::ACL::Entry;

    my $my_network = new Net::IP::ACL::Entry(
        address => '172.16.10.0/24',
        name    => 'my network',
        value   => 1,
    );


=head1 EXPORT

=head1 SUBROUTINES/METHODS

=head2 network

return IPv4 or IPv6 address by binary form.

=cut

sub network {
    my $this = shift;
    return new Math::BigInt( $this->address()->intip() );
}

=head2 netmask

return IPv4 or IPv6 netmask by binary form.

=cut

sub netmask {
    my $this = shift;

    my $bit_length = $this->version() == 4 ? 32 : 128;
    return bit_n( $bit_length ) - bit_n( $bit_length - $this->address()->prefixlen() );
}


=head2 bit_n( $n )

return 0x01 << $n (bit shift operator) by Math::BigInt. if $n < 0 return 0.

=cut

sub bit_n {
    my ( $n ) = @_;

    if ( $n >= 0 ) {
	return Math::BigInt->new( 1 )->blsft( $n );
    }
    else {
	return Math::BigInt->new( 0 );
    }
}

=head2 version

If network address is IPv4, return 4. If network address is IPv6, return 6.

=cut

sub version {
    my $this = shift;

    return $this->address->version();
}

=head2 check_ip_address( $str )

Check $str is IP address format string, and return Net::IP instance.
If $str is not IP address format, throw ArgumentError exception.

=cut

sub check_ip_address {
    my ( $str ) = @_;

    my $ip_addr = new Net::IP( $str );
    if ( ! defined( $ip_addr ) ) {
	Net::IP::ACL::ArgumentError->throw(
	    error_message => sprintf( q{Invalid network address "%s"(%s).}, $str, Net::IP::Error() ),
	);
    }
    return $ip_addr;
}


no Moose;
__PACKAGE__->meta->make_immutable;

1;
