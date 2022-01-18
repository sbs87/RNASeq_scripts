INFILE=$1
OUTFILE=$2
/usr/local/bin/fastx_collapser -Q 33 -i $INFILE -o $OUTFILE
