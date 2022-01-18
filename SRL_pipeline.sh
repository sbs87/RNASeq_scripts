######################
## 0. Copy the sequencing delivery table email recieved from GRC into file called "GRC.txt" within the Config directory. Remove the header row. Should look like this:
######################
#1	Small RNA Sequencing of UAB066_W5D4_Small	UAB066_W5D4_Small	MS100072941	small RNA	148	IL100073001	110,499,374
#16,685,405,474
#/local/projects/CSSSR/UAB066_W5D4_Small/ILLUMINA_DATA
#2	Small RNA Sequencing of UAB066_W5D7_Small	UAB066_W5D7_Small	MS100072942	small RNA	144	IL100073002	136,169,864
#20,561,649,464

## The script should be run from /local/projects-t2/HRBV/. Once the GRC delivery table is created, the script will take it form there: it will ID IL-Sample mappings, then copy/rename files to local

######################
## 1. Copy/rename files from GRC location to local according to manifest. 
######################
DELIVERY=$1 #'/local/sequence/illumina/data/2016/160121_K00134_0045_AH5VMFBBXX/Unaligned_smallRNA/Project_CSSSR/'
ANALYSIS="/local/projects-t2/HRBV/"
WORKORDER=$2 #W100064407
READ_N=$3 #R1 or R2 if 75bp PE
cd $ANALYSIS
#ls $DELIVERY/*/*R1_001.fastq.gz | sed 's/.*Sample_.*\///g' | sed 's/_/\t/g' | cut -f1-3 | sed 's/\tL/\t/g' | sed 's/S//g' > ../Config/IL_S_L.map 
ls $DELIVERY/Sample_IL*/*_R1_001_trimmed.fastq.gz | sed 's/.*Sample_.*\///g' | sed 's/_R1.*//g' | sed 's/_/\t/g'> Config/IL_S_L.map
python Scripts/SRL_create_manifest.py $WORKORDER $READ_N
cp -ri $DELIVERY"/Sample_IL"* SRL/
python Scripts/rename_GRC_files.py $ANALYSIS SRL $ANALYSIS"/Config/"$WORKORDER".renameMap"
######################
## 2. Trim
######################
######################
## 3. Align
######################
#Scripts/qsub_batch.sh Config/SRL_trimmomatic.config 
#Scripts/qsub_batch.sh Config/SRL_align_annotate.config
#for i in HH; do echo UAB093_W6D7; Scripts/fastqc.sh SRL/SRL_UAB093_W6D7/SRL_UAB093_W6D7_R1_trimmed_gt16.fastq; done
#for i in HH; do Scripts/get_trimmomatic_stats.sh UAB093_W6D7 trim.tmp; done
