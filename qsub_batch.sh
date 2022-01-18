. $1
MANIFEST=$MANIFEST
BASE_NAME=$BASE_NAME
SCRIPT_NAME=$SCRIPT_NAME
THREADS=$THREADS
MEM_FREE=$MEM_FREE
SCRIPT_ARG_1=$SCRIPT_ARG_1
SCRIPT_ARG_2=$SCRIPT_ARG_2

sed 1d $MANIFEST | while  IFS=$'\t' read -r -a array; ### THe sed 1d removes headsers from $MANIFEST
  do

  SAMPLE_NAME=$(echo ${array[0]})
  SCRIPT_ARG_2=$(echo ${array[1]})
#  echo  $SAMPLE_NAME,$SCRIPT_ARG_2
#for SAMPLE_NAME in `cat $MANIFEST`;
echo "Config info for "$SCRIPT_NAME" "$SAMPLE_NAME  > "/home/stsmith/qsub_logs/"$BASE_NAME"."$SAMPLE_NAME".runinfo"
echo "Config file: "$1 >>  "/home/stsmith/qsub_logs/"$BASE_NAME"."$SAMPLE_NAME".runinfo"
echo "Manifest file: "$MANIFEST >> "/home/stsmith/qsub_logs/"$BASE_NAME"."$SAMPLE_NAME".runinfo"
echo "Threads: "$THREADS >> "/home/stsmith/qsub_logs/"$BASE_NAME"."$SAMPLE_NAME".runinfo"
echo "Mem_free: "$MEM_FREE >> "/home/stsmith/qsub_logs/"$BASE_NAME"."$SAMPLE_NAME".runinfo"
echo "Script arg 1: "$SCRIPT_ARG_1  >> "/home/stsmith/qsub_logs/"$BASE_NAME"."$SAMPLE_NAME".runinfo"

qsub -P jravel-lab -l mem_free=$MEM_FREE -v BLASTDB='/local/db/repository/ncbi/blast/latest/taxdb/' -q threaded.q -pe thread $THREADS -N $SAMPLE_NAME"."$BASE_NAME -o "/home/stsmith/qsub_logs/"$BASE_NAME"."$SAMPLE_NAME"."$SCRIPT_ARG_1".out" -e "/home/stsmith/qsub_logs/"$BASE_NAME"."$SAMPLE_NAME"."$SCRIPT_ARG_1".error" $SCRIPT_NAME $SAMPLE_NAME $SCRIPT_ARG_1 $SCRIPT_ARG_2;
done
