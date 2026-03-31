#!/usr/bin/env bash

#SBATCH --job-name=CRAM2BAM
#SBATCH --time 2-00:00:00
#SBATCH --mem=66G
#SBATCH -c 6
#SBATCH -p high
#SBATCH --nodelist=ws3

pd=$PWD

echo ">>>>>>>>>> START $(date) <<<<<<<<<<"; echo

####################################################################################
####################################################################################

############
# Tools
gatk=/home/main-SSD04/0.software/gatk-4.6.1.0/gatk
dbsnp=/mnt/storage-HDD05a/2.SNParrayDBs/dbsnp_vcf_build156/GRCh38/GCF_000001405.40.annotated.chrnames-with-chr.gz

bed_file="${pd}/PRS_SNPs_hg38_zero_base.bed"

HM_Coriell_match_1kg30x_list="/mnt/storage-HDD01/1.scrach/bioinfo-ralph/2.projects/PRS313/CRAM2BAM/HM_Coriell_match_1kg30x_sample.list"
reference_GRCh38="/mnt/storage-HDD01/1.scrach/bioinfo-ralph/CRAM_1kg_30x/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa"

############
# Parameters
wrk_dir="/mnt/storage-HDD01/1.scrach/bioinfo-ralph/2.projects/PRS313/CRAM2BAM"
echo; echo "Working directory: ${wrk_dir}"

bam_folder="BAM"
echo; echo "BAM folder: ${bam_folder}"

thr=6
echo; echo "No. thr: ${thr}"
echo

cd ${wrk_dir}

mkdir -p ${bam_folder}

output_bam="${wrk_dir}/${bam_folder}"

###############
# Convert to BAM

while IFS= read -r sample; do
    ftp_download=$(grep -F -h -- "${sample}" \
      1000G_2504_high_coverage.sequence.index \
        1000G_698_related_high_coverage.sequence.index | \
          awk '{ if (match($0, /ftp:\/\//)) print substr($0, RSTART) }' | \
            awk '{print $1}')

    echo "Downloading FTP for ${sample}: ${ftp_download}"

    wget -q -P ${output_bam} ${ftp_download}

    echo "Converting CRAM to BAM for ${sample}"
#    samtools view -@ ${thr} -T ${reference_GRCh38} -O bam -L ${bed_file} -o ${output_bam}/${sample}.final.bam ${output_bam}/${sample}.final.cram
    samtools view -@ ${thr} -T ${reference_GRCh38} -O bam -L ${bed_file} -o ${output_bam}/${sample}.final.bam ${output_bam}/${sample}.final.cram
    samtools index ${output_bam}/${sample}.final.bam

    rm ${output_bam}/${sample}.final.cram

done < "${HM_Coriell_match_1kg30x_list}"

####################################################################################
####################################################################################

echo ">>>>>>>>>> END $(date) <<<<<<<<<<"; echo

###
##
#

