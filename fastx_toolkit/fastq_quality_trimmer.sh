# Implement FASTQ quality filter

EXE=fastq_quality_trimmer

# Optional command string, added at run-time
OPTS=

#input
INPUT=${input}
# Quality threshold
THRESHOLD=${threshold}

# Minimum length
MINLEN=${length}
if [ -z $MINLEN ]; then MINLEN=0; fi

# Boolean -Q33
Q33=${q33}
if [ $Q33 == 1 ]; then OPTS="-Q33 "; fi

# iRODS fetch input
iget -fT $INPUT .
INPUT_F=$(basename ${INPUT})
#output
OUTPUT="${EXE}_${INPUT_F}"

# Unpack bin directory and extend PATH
tar -zxf bin.tgz
export PATH="${PATH}:${PWD}/bin"

# Run command
set -x
$EXE ${OPTS} -i ${INPUT_F} -t $THRESHOLD -l ${MINLEN} -o ${OUTPUT}
set +x

# Delete bin directory
rm -rf bin
