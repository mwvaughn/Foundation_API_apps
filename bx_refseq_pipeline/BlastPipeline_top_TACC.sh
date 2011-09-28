#!/bin/bash

#$ -N bx_refseq_pipeline
#$ -pe 8way 16
#$ -q development
#$ -j y
#$ -o sge-log/bx_refseq_pipeline.o$JOB_ID
#$ -l h_rt=1:00:00
#$ -V
#$ -A TG-MCB110022
#$ -cwd

## This pipeline runs the following steps 
## 
##  1- preprocess the fasta file(s) to create job array input file 
##  2- run the blast alignments against a database 
##  3- postprocess the data by parsing the results 
##  4- cleanup interim files and concat the results 

module purge
module load TACC
module swap pgi gcc/4.4.5
module load BioPerl/1.6.1
module load launcher

JOBS=16
INFILEDIR="$PWD/query"
SPLITDIR="$PWD/query/split"
SCRIPTS="$PWD/scripts"
export CWD="$PWD"

# Copy query data into $INFILEDIR
# Replace in next iteration with the irods copy command
#cp /work/01770/steinj/rna_assembly/contig_annotation/test_data/SperuDNc5l100.fa ${INFILEDIR}

echo "Creating Launcher input files"
$SCRIPTS/create_jobarray_fasta.pl -i $INFILEDIR -o $SPLITDIR -j $JOBS

if [ -e paramlist.bx ];
then
rm -rf paramlist.bx
fi
for ((K=1;K<=${JOBS};K++));do

	echo "$SCRIPTS/run_blast_top_hit.sh $K" >> paramlist.bx

done

# Run the commands in paramlist.bx
EXECUTABLE=$TACC_LAUNCHER_DIR/launcher
$TACC_LAUNCHER_DIR/paramrun $EXECUTABLE paramlist.bx

# I assume this is to allow for filesystem latency
# Including for now
sleep 3

echo ""
echo "Submitting cleanup"
# Directly invoke the postprocess scripts
$SCRIPTS/run_postprocess.sh

# Clean up time
cd $CWD
rm -rf paramlist.bx
rm -rf tmp/blast*
rm -rf query/split/query*
