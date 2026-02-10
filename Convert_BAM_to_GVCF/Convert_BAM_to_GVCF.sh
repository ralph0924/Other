cd /mnt/storage-HDD01/1.scrach/bioinfo-ralph/2.projects/BAM2PRS_test/Ref_data/BAM

for i in *.bam; do
    sif=/home/main-SSD04/0.software/sif-images_apptainer
    ref=/home/main-SSD04/1.database/human/illumina_hg38/GRCh38_genome.fa
    bed=/home/main-SSD04/2.pipeline/BAM-2-PRS_BreastCancer77SNPs-1.5.0/resources/bca-77snps_zero-based_hg38_GCF_000001405.40.annotated.bed
    dbsnp=/home/main-SSD04/1.database/human/dbsnp/grch38/build156/GCF_000001405.40.annotated.chrnames-without-chr.gz
    
    apptainer exec --bind /mnt:/mnt --bind /home:/home \
        ${sif}/gatk_4.6.2.0.sif \
        gatk HaplotypeCaller \
            -R ${ref} \
            -I ${i} \
            -L ${bed} \
            -O "/mnt/storage-HDD01/1.scrach/bioinfo-ralph/2.projects/BAM2PRS_test/Ref_data/GVCF/${i%.bam}.g.vcf.gz" \
            -ERC GVCF \
            --dbsnp ${dbsnp} \
            --standard-min-confidence-threshold-for-calling 30.0 \
            --mapping-quality-threshold-for-genotyping 20 \
            --base-quality-score-threshold 18
    
done


for i in *.g.vcf.gz; do
    bcftools sort \
        -Oz \
        -o "${i%.g.vcf.gz}_sorted.g.vcf.gz" \
        "${i}"

    tabix "${i%.g.vcf.gz}_sorted.g.vcf.gz"

    rm ${i}*
done
