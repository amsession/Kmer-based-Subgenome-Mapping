open (IN, "$ARGV[0]") || die "nope\n";
while (<IN>)
{
    chomp;
    my @fields = split /\t/;
    $acc = 0;
    foreach (@fields){
	$acc += $_;
    }
    if ($acc >= $ARGV[1])
    {
	print "$_\n";
    }
}
