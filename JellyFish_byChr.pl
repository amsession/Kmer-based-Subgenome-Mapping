open (IN, "$ARGV[0]") || die "nope\n";
while (<IN>)
{
    chomp;
    my @fields = split /\t/;
    `blastdbcmd -dbtype nucl -db $ARGV[1] -entry $fields[0] -out $fields[0].fa`;
    `~/LOCAL.INSTALL/jellyfish/jellyfish-2.3.0/bin/jellyfish count -m $ARGV[3] -s $ARGV[2] -t 4 -o $fields[0]_k$ARGV[3] -C -L 1 $fields[0].fa`;
    `~/LOCAL.INSTALL/jellyfish/jellyfish-2.3.0/bin/jellyfish dump -c -t -o $fields[0].k$ARGV[3].dump $fields[0]_k$ARGV[3]`;
    `sort -k1,1 $fields[0].k$ARGV[3].dump > sorted.$fields[0].k$ARGV[3].dump`;
}
close (IN);
