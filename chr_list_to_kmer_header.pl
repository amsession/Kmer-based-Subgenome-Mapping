open (IN, "$ARGV[0]") || die "nope\n";
$count = 0;
while (<IN>)
{
    chomp;
    my @fields = split /\t/;
    if ($count ==0)
    {
	print "Mer\t$fields[0]";
	$count++;
    }
    else
    {
	print "\t$fields[0]";
    }
}
close (IN);
print "\n";
