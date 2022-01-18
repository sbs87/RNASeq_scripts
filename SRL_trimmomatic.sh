sample=$1 #100058451/IL100058451_S4_L004
r='R1'
fastq_skeleton="/local/projects-t2/HRBV/SRL/SRL_"$sample'/SRL_'$sample"_"$r"_trimmed"
java_dir=/home/ksieber/bin/java
trimmomatic_dir=~/bin/Trimmomatic-0.33/trimmomatic-0.33.jar
adaptor_dir=~/bin/Trimmomatic-0.33/adapters/TruSeq3-SmallRNA.fa
/home/ksieber/bin/java -jar ~/bin/Trimmomatic-0.33/trimmomatic-0.33.jar SE -threads $2 -phred33 $fastq_skeleton".fastq.gz" $fastq_skeleton"_gt16.fastq.gz" ILLUMINACLIP:$adaptor_dir:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:16
