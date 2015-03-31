package Net::IP::ACL;

use Moose;
use Net::IP;
use Net::IP::ACL::Exception;
use Net::IP::ACL::Entry;
use Net::IP::ACL::Imp;


has '_ipv4_acl' => ( isa     => 'Net::IP::ACL::Imp',
		     is      => 'rw',
		     default => sub { new Net::IP::ACL::Imp( _bit_length => 32 ) } );

has '_ipv6_acl' => ( isa     => 'Net::IP::ACL::Imp',
		     is      => 'rw',
		     default => sub { new Net::IP::ACL::Imp( _bit_length => 128 ) } );

=head1 NAME

Net::IP::ACL - ACL.

=head1 VERSION

=cut

our $VERSION = '0.0.1';

=head1 SYNOPSIS

Quick summary of what the module does.

    use Net::IP::ACL;

    my $my_network = new Net::IP::ACL::Entry(
        address => '172.16.10.0/24',
        name    => 'my network',
        value   => 1,
    );

    my $group_network = new Net::IP::ACL::Entry(
        address    => '172.16.10.0/16',
        name       => 'group network',
        value      => 2,
    );

    my $my_host = new Net::IP::ACL::Entry(
        address    => '172.16.10.101',
        name       => 'my host',
        value      => 0,
    );

    # make ACL.
    my $acl = new Net::IP::ACL;
    $acl->add( $my_network );
    $acl->add( $group_network );
    $acl->add( $my_host );

    $acl->match( '10.0.0.1' );                      # unmatched, return undef.

    my $acl_entry1 = $acl->match( '172.16.230.24' ) # matched $group_network, return $group_network.
    print $acl_entry1->name;                        # "group network"

    my $acl_entry2 = $acl->match( '172.16.10.24' )  # matched $my_network, return $my_network.
    print $acl_entry2->name;                        # "my network"

    my $acl_entry3 = $acl->match( '172.16.10.101' ) # matched $my_host, return $my_host.
    print $acl_entry3->name;                        # "my host"


=head1 SUBROUTINES/METHODS

=head2

=head2 add( $acl_entry )

add acl_entry.

=cut

sub add {
    my $this = shift;
    my ( $acl_entry ) = @_;

    my $acl = $this->_get_acl( $acl_entry->address() );
    $acl->add( $acl_entry );
}

=head2 match( $address )

whether IP address $address is matched or not.
If $address is matched, this method return matched ACLEntry.
If not matched, this method return undef.

=cut

sub match {
    my $this = shift;
    my ( $str ) = @_;

    my $address = Net::IP::ACL::Entry::check_ip_address( $str );
    my $acl     = $this->_get_acl( $address );
    return $acl->match( $address );
}


sub _get_acl {
    my $this = shift;
    my ( $address ) = @_;

    if ( $address->version() == 4 ) {
	return $this->_ipv4_acl;
    }
    elsif ( $address->version() == 6 ) {
	return $this->_ipv6_acl;
    }
    else {
	Net::IP::ACL::ArgumentError->throw(
	    error_message => sprintf( q{unknown protocol version "%d"}, $address->version ),
	);
    }
}

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::IP::ACL

=head1 LICENSE AND COPYRIGHT

Copyright 2015 Toshifumi Sakaguchi.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

1; # End of Net::IP::ACL

