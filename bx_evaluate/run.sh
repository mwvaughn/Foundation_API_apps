# Declare local Perl module directory
# This is an example of how to carry 
# dependencies with you. We may move this
# into the default profile of the iplant user

export PERL5LIB=$PWD/perl5/lib/perl5/site_perl/5.8.5/:$PWD/perl5/lib64/perl5/site_perl/5.8.5/x86_64-linux-thread-multi/auto/

# Unpack perl5.tgz and bin.tgz
tar -zxf perl5.tgz
tar -zxf bin.tgz

#input
INPUT=${input}
#evalue
EVALUE=${evalue}
#assembly_name 
ASSEMBLY=${assembly_name}
#blastmode all|top
BLASTMODE=${blastmode}

iget -fT $INPUT .
INPUT_F=$(basename ${INPUT})

perl bin/evaluate_refseq_bx.pl --input=$INPUT_F --evalue=$EVALUE --assembly_name=$ASSEMBLY --blastmode=$BLASTMODE

# Clean up executable and dependencies. Alternative method is to
# append their names to .iplant.archive
echo "./bin" >> .iplant.archive
echo "./perl5" >> .iplant.archive
