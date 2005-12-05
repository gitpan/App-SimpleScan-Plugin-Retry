use Test::More;
use Test::Differences;

my $simple_scan = `which simple_scan`;
chomp $simple_scan;

my %test_pairs = (
  "-retry 0" => <<EOS,
use Test::More tests=>1;
use Test::WWW::Simple;
use strict;

my \@accent;
mech->retry("0");
page_like "http://perl.org/",
          qr/Perl/,
          "branding [http://perl.org/] [/Perl/ should match]";

EOS
  "-retry 11.5" => <<EOS,
use Test::More tests=>1;
use Test::WWW::Simple;
use strict;

my \@accent;
mech->retry("11");
page_like "http://perl.org/",
          qr/Perl/,
          "branding [http://perl.org/] [/Perl/ should match]";

EOS
  "-retry 4" => <<EOS,
use Test::More tests=>1;
use Test::WWW::Simple;
use strict;

my \@accent;
mech->retry("4");
page_like "http://perl.org/",
          qr/Perl/,
          "branding [http://perl.org/] [/Perl/ should match]";

EOS
  "-retry zonk" => <<EOS,
use Test::More tests=>2;
use Test::WWW::Simple;
use strict;

my \@accent;
fail "retry count 'zonk' is not a number";
page_like "http://perl.org/",
          qr/Perl/,
          "branding [http://perl.org/] [/Perl/ should match]";

EOS
);

plan tests=>(int keys %test_pairs);

for my $test_input (keys %test_pairs) {
  my $cmd = qq(perl -Iblib/lib $simple_scan --gen $test_input <t/neither.in);
  my $results = `$cmd`;
  eq_or_diff $results, $test_pairs{$test_input}, "expected output";
}
