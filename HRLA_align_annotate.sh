SAMPLE=$1
INDEX=/local/projects-t2/HRBV/reference/Homo_sapiens/UCSC/hg19/Sequence/Bowtie2Index/genome
FASTQ='/local/projects-t2/HRBV/HRLA/HRLA_'$SAMPLE'/HRLA_'$SAMPLE
OUT='/local/projects-t2/HRBV/HRLA/alignment/HRLA_'$SAMPLE"_aln_hg19"
THREADS=$2
/home/stsmith/bin/tophat-2.1.0.Linux_x86_64/tophat2 -o $OUT $INDEX $FASTQ"_R1_trimmed_paired.fastq" $FASTQ"_R2_trimmed_paired.fastq"
#/local/projects-t2/HRBV/HRLA/HRLA_format_alignment_stats.py $OUT"/align_summary.txt" $OUT"/align_summary_formatted.txt"

ANNOTATION=/local/projects-t2/HRBV/reference/Homo_sapiens/UCSC/hg19/Annotation/Genes/genes.gtf
BAM=$OUT"/accepted_hits.bam"
SORTED_BAM_PREFIX=$OUT"/"$SAMPLE".accepted.sort.name"
OUT_SAM=$OUT"/"$SAMPLE".hg_annotated.sam"
OUT_COUNTS=$OUT"/"$SAMPLE".hg_counts"

/usr/local/bin/samtools sort -n $BAM $SORTED_BAM_PREFIX 
/usr/local/bin/samtools index $SORTED_BAM_PREFIX".bam"
/usr/local/bin/samtools index $BAM
/usr/local/bin/samtools idxstats $SORTED_BAM_PREFIX".bam" > "/local/projects-t2/HRBV/HRLA/alignment/HRLA_"$SAMPLE".alignmentStats.txt"
samtools view -F 8 $SORTED_BAM_PREFIX".bam" > $SORTED_BAM_PREFIX".paired.sam"

export PYTHONPATH=/usr/local/packages/HTSeq/lib/python2.6/site-packages:$PYTHONPATH
/usr/local/packages/Python-2.7/bin/python -m HTSeq.scripts.count -o $OUT_SAM -s reverse $SORTED_BAM_PREFIX".paired.sam" $ANNOTATION > $OUT_COUNTS

sort -nrk 2 $OUT_COUNTS > $OUT_COUNTS".sorted" 

head $OUT_COUNTS".sorted"
