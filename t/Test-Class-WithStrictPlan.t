use strict;
use warnings;

use Test::More tests => 9;

BEGIN {
	use_ok('Test::Class::WithStrictPlan');
};

my $less_out = qx("$^X" -Iblib/lib t/less.plx 2>&1);
is($?, 1 << 8, 'Exit code for less number of tests is correct');
like($less_out, qr/1\.\.1\nok 1 - First test passed\nok 2 - Second test passed\nnot ok 3 - expected 1 test.* 2 completed/, 'Output for less number of tests is correct');

my $more_out = qx("$^X" -Iblib/lib t/more.plx 2>&1);
is($?, 1 << 8, 'Exit code for more number of tests is correct');
like($more_out, qr/1\.\.3\nok 1 - First test passed\nok 2 - Second test passed\nnot ok 3 - \(.*returned before plan complete\)\n.*Looks like you failed 1 test of 3/s, 'Output for more number of tests is correct');

my $exact_out = qx("$^X" -Iblib/lib t/exact.plx 2>&1);
is($?, 0 << 8, 'Exit code for exact number of tests is correct');
like($exact_out, qr/1\.\.2\nok 1 - First test passed\nok 2 - Second test passed\n/, 'Output for exact number of tests is correct');

my $noplan_out = qx("$^X" -Iblib/lib t/noplan.plx 2>&1);
is($?, 1 << 8, 'Exit code for noplan is correct');
like($noplan_out, qr/ok 1 - First test passed\nok 2 - Second test passed\nnot ok 3 - expected 1 test.* 2 completed.*ok 4 - First test passed/s, 'Output for noplan is correct');
