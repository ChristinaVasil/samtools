#!/usr/bin/env nextflow

// enable dsl2
nextflow.enable.dsl = 2

params.results = '/home/christina/'

params.ref = '/home/christina/reference/Oryzias_latipes.ASM223467v1.dna.toplevel.fa'

params.inputdir = '/mnt/codon/christina/cram_files/*.cram'

process samtools {
   
    memory '60.GB'
    publishDir "${params.results}/fastq_nextflow_test/", mode: 'copy'
    label 'samtools'

    input:
      path(cram)

    output:
      path "*.R1.fastq.gz", emit: R1fastq
      path "*.R2.fastq.gz", emit: R2fastq
      
    shell:
    '''
    samtools fastq --reference !{params.ref}  -1 !{cram.baseName}.R1.fastq.gz -2 !{cram.baseName}.R2.fastq.gz !{cram}
    '''
}

workflow {
    Channel
      .fromPath(params.inputdir, checkIfExists: true)
      .set{ ch_cram }
   
   samtools(ch_cram)   
    
}
