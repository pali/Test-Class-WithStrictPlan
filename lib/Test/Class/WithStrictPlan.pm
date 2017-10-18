# Copyright (c) 2017 by Pali <pali@cpan.org>

package Test::Class::WithStrictPlan;

use 5.006;
use strict;
use warnings;

our $VERSION = '0.1';

use parent 'Test::Class';
BEGIN { Test::Class->VERSION('0.37') }
sub fail_if_returned_early { 1 }

use Attribute::Handlers;

sub Test : ATTR(CODE, RAWDATA) {
	my ($class, $symbol, $code_ref, $attr, $args) = @_;
	no warnings 'redefine';
	*{$symbol} = sub {
		$code_ref->(@_);
		return;
	};
	Test::Class::Test($class, $symbol, $code_ref, $attr, $args);
}

1;
__END__

=head1 NAME

Test::Class::WithStrictPlan - Test::Class with exact strict plan

=head1 SYNOPSIS

  package Example::Test;
  use parent 'Test::Class::WithStrictPlan';

  sub test1 : Test(2) {
    is(10 + 20, 30, 'addition works');
    is(20 + 10, 30, 'both ways');
  }

  __PACKAGE__->runtests;

=head1 DESCRIPTION

TODO

=head1 SEE ALSO

L<Test::Class>

=head1 AUTHOR

Pali E<lt>pali@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2017 by Pali E<lt>pali@cpan.orgE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.6.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
