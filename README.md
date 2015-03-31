# perl-Net-IP-ACL

## SYNOPSIS

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


## SUBROUTINES/METHODS

### add( $acl_entry )

add acl_entry.

### match( $address )

whether IP address $address is matched or not.
If $address is matched, this method return matched ACLEntry.
If not matched, this method return undef.

## SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::IP::ACL

## LICENSE AND COPYRIGHT

The MIT License (MIT)

Copyright (c) 2015 Toshifumi Sakaguchi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

