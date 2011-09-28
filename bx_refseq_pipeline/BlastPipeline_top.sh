#!/bin/sh

## This pipeline runs the following steps 
## 
##  1- preprocess the fasta file(s) to create job array input file 
##  2- run the blast alignments against a database 
##  3- postprocess the data by parsing the results 
##  4- cleanup interim files and concat the results 

JOBS=400
INFILEDIR="$PWD/query"
SPLITDIR="$PWD/query/split"
SCRIPTS="$PWD/scripts"
export CWD="$PWD"

echo "Creating job array input files"
$SCRIPTS/create_jobarray_fasta.pl -i $INFILEDIR -o $SPLITDIR -j $JOBS

#echo "zipping the blast db"
#tar -cf blastdir.tar reference
#gzip blastdir.tar

echo "Submitting a blast array job"
qsub -l virtual_free=3.5G -v CWD -t 1-$JOBS:1 -N MYBlast -S /bin/sh -cwd $SCRIPTS/run_blast_top_hit.sh

sleep 3

echo ""
echo "Submitting cleanup"
qsub -v CWD -N MYFinal -hold_jid MYBlast -S /bin/sh -cwd $SCRIPTS/run_postprocess.sh

echo ""
echo "All jobs submitted."

