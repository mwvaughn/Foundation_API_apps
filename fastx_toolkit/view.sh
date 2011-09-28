
# Use SAMtools view to convert SAM (with header) to BAM

#input
INPUT=${sam}
#output
OUTPUT=${bam}

iget -fT $INPUT .
INPUT_F=$(basename ${INPUT})

bin/samtools view -bS $INPUT_F -o $OUTPUT
