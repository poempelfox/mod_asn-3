#!/usr/bin/perl

my $lastprefix = undef;
my $lastasn = undef;
while (my $ll = <>) {
  $ll =~ s/[\r\n]//g;
  if ($ll =~ m!^([0-9a-fA-F:/]+) (\d+)$!) {
    my $prefix = $1;
    my $asn = $2;
    if ($prefix eq $lastprefix) {
      unless ($lastasn eq $asn) {
        # duplicate prefix with different AS number, that means this was
        # announced by more than one AS - mark as invalid.
        $asn = undef;
      }
    } else {
      if (defined($lastasn)) {
        print("$lastprefix $lastasn\n");
      }
      $lastprefix = $prefix;
      $lastasn = $asn;
    }
  }
}
if (defined($lastasn)) {
  print("$lastprefix $lastasn\n");
}

