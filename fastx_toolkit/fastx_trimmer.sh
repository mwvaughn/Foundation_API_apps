# Implement FASTQ trimmer

# fastx_trimmer (-Q33) -i <input.fq> -f <first> -l <last> -o <output.fq>

EXE=fastx_trimmer

# Optional command string, added at run-time
OPTS=""

#input
INPUT=${input}

# First and last
FIRST=${firstBase}
if [ -n $FIRST ]; then OPTS="${OPTS} -f ${FIRST} "; fi
LAST=${lastBase}
if [ -n $LAST ]; then OPTS="${OPTS} -l ${LAST} "; fi

# Boolean -Q33
Q33=${q33}
if [ $Q33 == 1 ]; then OPTS="${OPTS} -Q33 "; fi

# iRODS fetch input
iget -fT $INPUT .
INPUT_F=$(basename ${INPUT})
OUTPUT="${EXE}_${INPUT_F}"

# Unpack bin directory and extend PATH
tar -zxf bin.tgz
export PATH="${PATH}:${PWD}/bin"

# Run command
set -x
${EXE} ${OPTS} -i ${INPUT_F} -o ${OUTPUT}
set +x

# Delete bin directory
rm -rf bin
