#Combine forward and reverse reads
cat forward_reads.fastq reverse_reads.fastq > combined_reads.fastq

# Quality Control with FastQC
module load fastqc
fastqc forward_reads.fastq 

module load seqtk
seqtk seq -A forward_reads.fastq | awk '{if(NR%2==0) total+=length($0)} END {print total}'
# Calculate coverage using the formula: Total length of reads/Genome size​	

# Index the Reference Genome
module load bwameme
bwa index reference_genome.fasta

# Align the Reads using bwa mem
bwa mem reference_genome.fasta forward_reads.fastq reverse_reads.fastq > aligned_reads.sam

# Convert SAM to BAM
module load samtools
samtools view -S -b aligned_reads.sam > aligned_reads.bam

# Sort the BAM File
samtools sort aligned_reads.bam -o sorted_reads.bam

# Index the BAM File
samtools index sorted_reads.bam

# Calculate Coverage
module load bedtools
bedtools genomecov -ibam sorted_reads.bam -g reference_genome.fasta > coverage.txt

