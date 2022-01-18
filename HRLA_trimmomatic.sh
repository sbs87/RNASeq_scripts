sample=$1 #100058451/IL100058451_S4_L004
THREADS=$2
fastq_skeleton="/local/projects-t2/HRBV/HRLA/HRLA_"$sample'/HRLA_'$sample
java_dir=/home/ksieber/bin/java
trimmomatic_dir=~/bin/Trimmomatic-0.33/trimmomatic-0.33.jar
adaptor_dir=~/bin/Trimmomatic-0.33/adapters/TruSeq3-PE.fa
/home/ksieber/bin/java -jar ~/bin/Trimmomatic-0.33/trimmomatic-0.33.jar PE -threads $THREADS -phred33 -trimlog $fastq_skeleton"_trimmomatic.log" $fastq_skeleton"_R1_trimmed.fastq.gz" $fastq_skeleton"_R2_trimmed.fastq.gz" $fastq_skeleton"_R1_trimmed_paired.fastq" $fastq_skeleton"_R1_trimmed_unpaired.fastq" $fastq_skeleton"_R2_trimmed_paired.fastq" $fastq_skeleton"_R2_trimmed_unpaired.fastq" ILLUMINACLIP:$adaptor_dir:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
#fastx_collapser -Q 33 -i $fastq_skeleton"_gt16.fastq" > $fastq_skeleton"_gt16.collapsed.fastq"
#/local/projects-t2/HRBV/Scripts/get_trimmomatic_stats.sh 

