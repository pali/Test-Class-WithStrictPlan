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

  use Test::More;

  sub test1 : Test(2) {
    is(10 + 20, 30, 'addition works');
    is(20 + 10, 30, 'both ways');
  }

  __PACKAGE__->runtests;

=head1 DESCRIPTION

I<Test::Class::WithStrictPlan> is an extension of the
L<I<Test::Class>|Test::Class> module. It has exactly same API, methods
and behavior with just one difference in what the plan number specified
in L<C<Test>|Test::Class/1) Test methods> attribute means. In
L<I<Test::Class>|Test::Class> it means the maximal number of tests for
a correspondent method. And in I<Test::Class::WithStrictPlan> it means
the strictly exact number of tests (not more, not less).

The best demonstration is on the following example which uses
L<I<Test::Class>|Test::Class> but contains B<incorrect pattern> in the
test code.

  package Example1;
  use parent 'Test::Class';

  use Test::More;

  sub test1 : Test(3) {
    is(1 + 1, 2);
    is(2 + 2, 4);
  }

  __PACKAGE__->runtests;

Plan has specified 3 tests, but only 2 are defined. When this test
is run it passes without any error.

  1..3
  ok 1 - test1
  ok 2 - test1
  ok 3 # skip 1

Why? Because the plan means the maximal number of tests which can be
run and number of tests which were run is not more then 3.

And if you are interested what C<1> means after the C<# skip> output
string then it is the return value of C<test> method. When less number
of tests is run as specified in L<I<Test::Class>|Test::Class> then
return value of the test method is used as skip reason. In this case
it is return value of the last statement (return value of the C<is>
call). To provide no skip reason it is needed to return undef from the
test method.

In most cases it is needed to specify exact strict number of tests
and not maximal number of tests. Also to prevent problems as in above
B<incorrect> example. And for this purposes there is
I<Test::Class::WithStrictPlan> module in which plan means exact
number of specified tests.

See above module rewritten to use I<Test::Class::WithStrictPlan>.

  package Example2;
  use parent 'Test::Class::WithStrictPlan';

  use Test::More;

  sub test1 : Test(3) {
    is(1 + 1, 2);
    is(2 + 2, 4);
  }

  __PACKAGE__->runtests;

When it is run then it fails and show error as people would expect.

  1..3
  ok 1 - test1
  ok 2 - test1
  not ok 3 - (Example2::test1 returned before plan complete)
  #   Failed test '(Example2::test1 returned before plan complete)'
  #   at ??/Test/Class.pm line ??.
  #   (in Example2->test1)
  # Looks like you failed 1 test of 3.

Basically this module is just syntactic sugar for
L<returning early from I<Test::Class>|Test::Class/RETURNING EARLY>.

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
