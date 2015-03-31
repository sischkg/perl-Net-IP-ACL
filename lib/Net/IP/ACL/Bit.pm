
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

sub print_acl_bit {
    my $this = shift;

    printf STDERR "bit %d, next_1: %d, next_0: %d, acl_entry: %s\n",
	$this->bit, $this->next_1 ? 1 : 0, $this->next_0 ? 1 : 0, $this->acl_entry ? $this->acl_entry->name : "none";
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

