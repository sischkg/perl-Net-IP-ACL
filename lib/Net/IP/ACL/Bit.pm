
package Net::IP::ACL::Bit;

use Moose;

has 'bit'    => ( isa      => 'Int',
		  is       => 'ro',
		  required => 1 );
has 'next_0' => ( isa     => 'Maybe[Net::IP::ACL::Bit]',
		  is      => 'rw',
		  default => undef );
has 'next_1' => ( isa => 'Maybe[Net::IP::ACL::Bit]',
		  is  => 'rw',
		  default => undef );
has 'acl_entry' => ( isa     => 'Maybe[Net::IP::ACL::Entry]',
		     is      => 'rw',
		     default => undef );

=head1 NAME

Net::IP::ACL::Bit - Node of binary tree which represents ACL.

=head1 SYNOPSIS

Quick summary of what the module does.

    use Net::IP::ACL::Bit;

    # network 01100000 00000000 00000000 00000000 = 96.0.0.0/8
    # netmask 11111111 00000000 00000000 00000000
    my $top = new Net::IP::ACL::Bit( bit = 0 );
    my $bit_0th = new Net::IP::ACL::Bit( bit => 0 ); # 0
    my $bit_1st = new Net::IP::ACL::Bit( bit => 1 ); # 1
    my $bit_2nd = new Net::IP::ACL::Bit( bit => 1 ); # 1
    my $bit_3rd = new Net::IP::ACL::Bit( bit => 0 ); # 0
    my $bit_4th = new Net::IP::ACL::Bit( bit => 0 ); # 0
    my $bit_5th = new Net::IP::ACL::Bit( bit => 0 ); # 0
    my $bit_6th = new Net::IP::ACL::Bit( bit => 0 ); # 0
    my $bit_7th = new Net::IP::ACL::Bit( bit => 0 ); # 0

    $top->next_0( $bit_0th );     # 0
    $bit_0th->next_1( $bit_1st ); # 1
    $bit_1st->next_1( $bit_2nd ); # 1
    $bit_2nd->next_0( $bit_3rd ); # 0
    $bit_3rd->next_0( $bit_4th ); # 0
    $bit_4rd->next_0( $bit_5th ); # 0
    $bit_5rd->next_0( $bit_6th ); # 0
    $bit_6rd->next_0( $bit_7th ); # 0


=head1 SUBROUTINES/METHODS

=head2

=head2 new( bit => $bit )

=head2 next_0( $bit )

set 0-node child.

=head2 next_0()

get 0-node child.

=head2 next_1( $bit )

set 1-node child.

=head2 next_1()

get 1-node child.

=head2 print_acl_bit()

print debug message to STDERR.

=cut

sub print_acl_bit {
    my $this = shift;

    printf STDERR "bit %d, next_1: %d, next_0: %d, acl_entry: %s\n",
	$this->bit, $this->next_1 ? 1 : 0, $this->next_0 ? 1 : 0, $this->acl_entry ? $this->acl_entry->name : "none";
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

