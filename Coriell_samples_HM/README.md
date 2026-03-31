## Instructions on how determine the GT for the desired Coriell samples from the IGSR website. This is to validate the the GT after sequencing the same Coriell samples in RCLS.

### Running the "1.CRAM2BAM.sh" script
This script downloads the Coriell sample from the 1000 genomes 30x project through the IGSR FTP as CRAM.
The CRAM is then converted to BAM using the reference file obtained from the IGSR website as well.
This script can be submitted as a slurm job as it takes long to run, especially with many samples. You just need to change the working direstory specified in the script.

### Running the "2.BAM_2_VCF.sh" script
This script converts BAM to GVCF using GATK Haplotypecaller then joint genotyping is performed to create a VCF.
This script is ran manually (i.e. copy and pasting each line to the terminal)

### VCF analysed
Once the VCF of all the desired Coriell samples is created, get all the GT of each sample and determine what combination of Coriell samples achieves the most ALT allele within the list of desired SNPs.
