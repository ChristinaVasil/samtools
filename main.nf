process samtools {
    cpus 8
    memory '60.GB'
    label 'samtools'

    input:
      path(cram)

    output:
      path "*.R1.fastq.gz", emit: R1fastq
      path "*.R2.fastq.gz", emit: R2fastq
      

    """
    samtools fastq --reference !{params.ref}  -1 !{cram.basename}.R1.fastq.gz -2 !{cram.basename}.R2.fastq.gz !{cram} \;
    """
}

workflow {
    Channel
      .fromPath("*.cram", checkIfExists: true) | samtools(fastq.out.R1fastq,fastq.out.R2fastq)
    
    
}
