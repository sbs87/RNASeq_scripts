#! /usr/bin/python
import os
import sys
from datetime import date, time, datetime
script_name=sys.argv[0]
arguments=sys.argv[1:]
SAMPLE=arguments[0]
N=arguments[1]
index_map={(4,'Gvag_n'+N):'/local/projects-t2/HRBV/reference/Gardnerella_vaignalis_ATTC_14019/Gardnerella_vaignalis_ATTC_14019.fa',
(5,'Liners_n'+N):'/local/projects-t2/HRBV/reference/Lactobacillus_iners_ATCC_55195/Lactobacillus_iners_ATCC_55195.fna',
(6,'hg19_n'+N):'/local/projects-t2/HRBV/reference/Homo_sapiens/UCSC/hg19/Sequence/BWAIndex/version0.5.x/genome.fa',
(1,'tRNA_n'+N):'/local/projects-t2/HRBV/reference/tRNA/GtRNAdb-all-tRNAs.fa',
(3,'HumRibosomal_n'+N):'/local/projects-t2/HRBV/reference/Homo_sapiens/UCSC/hg19/Sequence/AbundantSequences/humRibosomal.fa',
(2,'hum5SrDNA_n'+N):'/local/projects-t2/HRBV/reference/Homo_sapiens/UCSC/hg19/Sequence/AbundantSequences/hum5SrDNA.fa'
}
print "Alignment started for "+SAMPLE+" on "+str(datetime.now())+" using the following index mapping hash:\n"+str(index_map)+"\n-"+"-"*10
FASTQ="/local/projects-t2/HRBV/SRL/SRL_"+SAMPLE+"/SRL_"+SAMPLE
FASTQ_SUFFIX='_R2_trimmed_gt16'
INFILE=FASTQ+FASTQ_SUFFIX+".fastq"
os.system("gunzip "+INFILE+".gz") 
os.system("cat "+INFILE+" /local/projects-t2/HRBV/reference/Spike_In.fastq | sed 's/TG$//g' > "+INFILE+".spike.tmp")
INFILE=INFILE+".spike.tmp"
for ORDER,INDEX in sorted(index_map,key=lambda x:(int(x[0]))):
	INDEX_DIR=index_map[(ORDER,INDEX)]
	OUT='/local/projects-t2/HRBV/SRL/alignment/'+INDEX+'/SRL_'+SAMPLE+'_R2_trimmed_gt16.aln_'+INDEX
	print "Starting alignment of "+SAMPLE+" to "+INDEX
	os.system("/usr/local/bin/bwa aln -n "+N+" "+ INDEX_DIR+" "+INFILE+"| bwa samse "+INDEX_DIR+" - "+INFILE+" | samtools view -bS - | samtools sort - "+OUT) 
	os.system("/usr/local/bin/samtools index "+OUT+".bam")
	os.system("/usr/local/bin/samtools idxstats "+OUT+".bam > "+OUT+".stats.txt")
	print "Creating unmapped fastq file for next alignment..."	
	os.system("/local/projects-t2/HRBV/SRL/SRL_create_unmapped_fastq.sh "+OUT+".bam "+OUT+".unmapped.fastq")	
	INFILE=OUT+".unmapped.fastq"
	os.system("/local/projects-t2/HRBV/SRL/fastx_collapser.sh "+INFILE+" "+OUT+".unmapped.collapsed.fasta")
	if INDEX=="hg19_n"+N:
		os.system("/usr/local/bin/samtools sort -n "+OUT+".bam "+OUT+".sortname")
		os.system("/usr/local/bin/samtools view -F 4 "+OUT+".sortname.bam > "+OUT+".sam")
		ANNOTATION='/local/projects-t2/HRBV/reference/hsa.gff3'#'/local/projects-t2/HRBV/reference/Homo_sapiens/UCSC/hg19/Annotation/Genes/genes.gtf'
		OUT_ANN='/local/projects-t2/HRBV/SRL/annotation/SRL_'+SAMPLE+'_R2_trimmed_gt16.'+INDEX+'.hg19SRNA_annotation'
		print "Annotating hg19..."
		os.system("/local/projects-t2/HRBV/SRL/SRL_annotate.R2.sh "+OUT+" "+ANNOTATION+" "+OUT_ANN)
		os.system("rm "+OUT+".sortname.bam")
os.system("rm "+FASTQ+FASTQ_SUFFIX+"*.tmp")
