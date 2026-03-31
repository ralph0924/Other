cd <working_directory>
wrk_dir=$(pwd)
sif=/home/main-SSD04/0.software/sif-images_apptainer
ref="/mnt/storage-HDD01/1.scrach/bioinfo-ralph/CRAM_1kg_30x/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa"
bed=/mnt/storage-HDD01/1.scrach/bioinfo-ralph/2.projects/PRS313/CRAM2BAM/script/PRS_SNPs_hg38_zero_base.bed
dbsnp=/mnt/storage-HDD05a/2.SNParrayDBs/dbsnp_vcf_build156/GRCh38/GCF_000001405.40.annotated.chrnames-with-chr.gz

mkdir -p BAM
mkdir -p GVCF
mkdir -p VCF
cd BAM

###################################################################################################

# Convert BAM to GVCF
cd BAM

for i in *.bam; do

    apptainer exec --bind /mnt:/mnt --bind /home:/home \
        ${sif}/gatk_4.6.2.0.sif \
        gatk HaplotypeCaller \
            -R ${ref} \
            -I ${i} \
            -L ${bed} \
            -O "${wrk_dir}/GVCF/${i%.bam}.g.vcf.gz" \
            -ERC GVCF \
            --dbsnp ${dbsnp} \
            --standard-min-confidence-threshold-for-calling 30.0 \
            --mapping-quality-threshold-for-genotyping 20 \
            --base-quality-score-threshold 18
    
done

###################################################################################################

# Sort GVCF
cd ${wrk_dir}/GVCF

for i in *.g.vcf.gz; do
    bcftools sort \
        -Oz \
        -o "${i%.g.vcf.gz}_sorted.g.vcf.gz" \
        "${i}"

    tabix "${i%.g.vcf.gz}_sorted.g.vcf.gz"

    rm ${i}*
done

###################################################################################################

# Merge GVCF
GVCF_LIST=""
for counts_file in *_sorted.g.vcf.gz; do
    GVCF_LIST+="-V ${counts_file} "
done

apptainer exec --bind /mnt:/mnt --bind /home:/home \
    ${sif}/gatk_4.6.2.0.sif \
    gatk CombineGVCFs \
        -R "${ref}" \
        ${GVCF_LIST} \
        -O "${wrk_dir}/VCF/cohort_sorted.g.vcf.gz"

tabix ${wrk_dir}/VCF/cohort_sorted.g.vcf.gz

###################################################################################################

# Joint Genotyping
cd ${wrk_dir}/VCF

apptainer exec --bind /mnt:/mnt --bind /home:/home \
    ${sif}/gatk_4.6.2.0.sif \
    gatk GenotypeGVCFs \
        -R "${ref}" \
        --dbsnp "${dbsnp}" \
        -V "${out_dir}/2.output-combine/cohort_sorted.g.vcf.gz" \
        -O "${out_dir}/3.output-vcf/cohort_sorted.vcf.gz"
