export BLASTDB=/local/db/repository/ncbi/blast/latest/taxdb/
FASTQ="/local/projects-t2/HRBV/SRL/alignment/hg19_n2/SRL_"$1"_R1_trimmed_gt16.aln_hg19_n2.unmapped.collapsed.fasta"
OUT="/local/projects-t2/HRBV/SRL/alignment/hg19_n2/SRL_"$1"_R1_trimmed_gt16.aln_hg19_n2.unmapped.collapsed.BlastResults"
THREADS=$2
head -n 75 $FASTQ | /home/stsmith/bin/ncbi-blast-2.2.31+-src/c++/ReleaseMT/bin/blastn -db /local/db/ncbi/blast/db/nt -query - -outfmt '6 qseqid sseqid evalue bitscore sgi sacc staxids sscinames scomnames stitle qstart qend sstart send length pident mismatch' -num_threads $THREADS -out $OUT
