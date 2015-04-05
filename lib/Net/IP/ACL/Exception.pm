
package Net::IP::ACL::Exception;

=head1 NAME

Net::IP::ACL::Expetion - Exepction classes for Net::IP::ACL.

=head1 SYNOPSIS

Quick summary of what the module does.

    use English;
    use Net::IP::ACL::Exeption;

    eval {
        Net::IP::ACL::ArgumentError->throw(
            error_message => "invalid argument.".
        );
    };
    if ( $err = $EVAL_ERROR ) {
       printf STDERR "error: %s\n", $err;
    }


=head1 SUBROUTINES/METHODS

=head2

=head2 throw( error_message => $error_message )

Throw exeption.

=head2 full_message

return error message.

=cut

use Exception::Class (
	'Net::IP::ACL::ArgumentError' => {
		fields => [ 'error_message' ],
	},
	);

sub Net::IP::ACL::ArguemntError::full_message {
    my ( $this ) = @_;
    return $this->error_message;
}

1;

