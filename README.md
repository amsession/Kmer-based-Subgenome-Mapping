# Kmer-based-Subgenome-Mapping
Necessary programs:

Perl (Bioperl), BLAST+, Jellyfish, R (matrixStats and gplots packages required), chromosome-scaled assembly fasta. Bedtools needed for posthoc analysis

1)	Generate a list of chromosome names for analysis: grep ‘Chr my.genome.fasta | sed ‘s/>//’ > chr.list’
2)	Make BLAST database with parse_seqids flag: makeblastdb -dbtype nucl -in my.genome.fasta -parse_seqids
3)	Use perl script to generate fasta file per chromosome and use Jellyfish to count k-mers: perl JellyFish_by_Chr.pl chr.list my.genome.fasta hash_size k-mer_size
a.	Hash size can be set to rough genome size estimate to make things simple
b.	The likelihood of any k-mer appearing by chance for this analysis is 2*(1/4)k where k is the k-mer length. We choose k=13 since this is long enough to capture rare variants, while being short enough we expect it to appear by chance on most chromosomes (1/33.5megabases). This makes the later statistics simpler, rather than having certain k-mers not appear on longer chromosomes 
4)	Use shell script to combine chromosome k-mer count files into a single table: multi_join.sh sorted.Chr*dump > joined.k13.dump
5)	Use perl script to filter low count k-mers (quicker than loading into R, typically require a count of 10 k-mers/chromosome in a subgenome): perl filter_JellyRows.pl joined.k13.dump 100 > filt.k13.dump
a.	This step is mostly necessary to reduce the amount of data that is loaded into/processed in R. The k-mers that are low count throughout the genome are unlikely to be informative in differentiating sets of chromosomes 
b.	We typically filter to 2 million k-mers or less at this step (use wc -l to check the k-mer count after filtering), however even this amount may be too much for computers with less memory. If this is the case for you, raise the minimum k-mer count.
6)	Use perl script to make a header for easier R analysis: perl chr_list_to_kmer_header.pl chr.list > kmer.header
7)	Concatenate the header and kmer matrix: cat kmer.header filt.k13.dump > filt.k13.tbl
8)	Identify homeologous chromosomes based on shared protein content. Use only chromosomes without rearrangements for the initial set (unless using custom scripts to separate chromosomes above). Generate tab-separated file with a chromosome set per line
9)	Generate table of chromosome lengths (column 1 = Chr name, column 2 = length in base pairs)
10)	Use Rscript to run the initial k-mer search analysis to identify k-mers and subgenomes. For higher ploidy genomes, use the alternate Rscript and specify the number of subgenomes expected: Rscript Kmap.2subgenome.identification.R filt.k13.tbl homeolog.pairs chr.lengths norm.tbl diff.kmer diff.kmer.tbl >&my.error.log1
a.	There are always a large number of k-mers that are enriched on single chromosomes, so the more homoeologous chromosome sets used in the initial search, the more exact the initial k-mer set will be. If there have been a number of rearrangements that makes using all chromosome sets inconvenient, such as Camelina, expect to filter out many of the k-mers identified in this initial search in the following steps
b.	This analysis normalizes the k-mer count per chromosome by dividing by chromosome length. 
c.	If there are chromosomes that are not well assembled (such as Goldfish Chr33), you should leave those pairs out of this initial analysis
d.	Output will be named based on the input options 4-6. norm.tbl will be the normalized k-mer count per chromosome. diff.kmer will be a list of k-mers that differentiate the chromosomes. diff.kmer.tbl is the normalized kmer table for the kmers that differentiate subgenomes. Chr.cluster.pdf will have a basic hierarchical clustering of the chromosomes based on the subgenome-enriched k-mers. This clustering will be important to provide the full list of subgenomes in the next step. Heatmap.pdf is 
11)	Now that we have a proposed clustering of chromosomes into subgenomes, we can assign statistical significance for the ability of each k-mer to differentiate between the proposed group of chromosomes. There is a separate script for describing 2,3, or 4 subgenomes: Rscript Kmap.2subgenome.ANOVA.R filt.k13.tbl homeolog.pairs tukey.out
a.	The output file will have pre-Bonferroni corrected p-values
b.	You can actually run this on the pre-filtered table as well, however it is unlikely that low count k-mers will be statistically significant across groups of chromosomes
c.	These scripts can be run on subsets of the complete table if you would like to run the analysis in parallel in order to increase speed
d.	The statistics of the ANOVA for each k-mer are included in the output, if you would prefer to filter based on F value or other cutoffs
12)	Finally, load the tukey.out table into R again, and use a Bonferroni correction on the p.value column(s).
13)	Visualize using your choice of plot. To create the plots from the paper: plot(my.tukey$Sub2-Sub1.diff,-log10(my.tukey$Sub2-Sub1.p)
14)	Subsequent mapping of the k-mers to the genome is done using BLASTN requiring exact matches (word size = k-mer size, evalue cutoff 10000)
15)	We use bedtools on the tabular BLAST output to generate density plots for visualization in R using karyoploteR.
