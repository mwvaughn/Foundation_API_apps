IRODS_IN=${queryFile}
JOBS=${IPLANT_CORES_REQUESTED}

INFILEDIR="$PWD/query"
SPLITDIR="$PWD/query/split"
SCRIPTS="$PWD/scripts"
export CWD="$PWD"

# unpack scripts and bin
tar -zxvf scripts.tgz
tar -zxvf bin.tgz

# Copy query data into $INFILEDIR using icommands
IRODS_FN=$(basename($IRODS_IN))
iget -fT $IRODS_IN $INFILEDIR

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
sleep 10

echo "Submitting cleanup"
# Directly invoke the postprocess scripts
$SCRIPTS/run_postprocess.sh

# Clean up time
cd $CWD
rm -rf paramlist.bx
rm -rf tmp/*
rm -rf parse-out/*
rm -rf blast-out/*
#rm -rf $INFILEDIR/$IRODS_FN
rm -rf $SPLITDIR/*

sleep 10
