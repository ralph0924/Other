# https://gatk.broadinstitute.org/hc/en-us/articles/360051306971-BpmToNormalizationManifestCsv-Picard

java -jar /home/main-SSD04/0.software/picard.jar BpmToNormalizationManifestCsv \
      INPUT="DTCbooster_20033558_A2.bpm" \
      CLUSTER_FILE="Clusterfile-v1.5-20Jun23.egt" \
      OUTPUT=DTCbooster_20033558_A2.csv
