
package Net::IP::ACL::Exception;

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

