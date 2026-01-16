#!/usr/bin/bash

#1 --- Add Working directory
echo
echo -n -e "${Cyan}  Add Working directory WITHOUT the project folder name (eg. /mnt/storage ):  ${NC}"
read work_dir
if [[ ! -d "${work_dir}/" ]] || [[ -z "${work_dir}" ]]
then
 echo
 echo -e "${BRed}  <> ERROR: Working directory - ${work_dir} - not found. Can not continue, exit. ${NC}"
 echo
 exit 1
fi
#2 --- Add project name/ID
echo
echo -n -e "${Cyan}  Add Project folder name (eg. NX01_22_02_Soil ):  ${NC}"
read prj
if [[ ! -d "${work_dir}/${prj}/" ]] || [[ -z "${work_dir}/${prj}" ]]
then
 echo
 echo -e "${BRed}  <> ERROR: Project - ${prj} - not found. Can not continue, exit. ${NC}"
 echo
 exit 1
fi

echo
date > ${work_dir}/${prj}/fastq2fasta_script-version.txt
echo "fastq2fasta_conversion_pipeline Version: xx.xx" >> ${work_dir}/${prj}/fastq2fasta_script-version.txt
echo

echo
echo "<<< -- STARTING FASTQ to FASTA Script -- >>>"
echo

awk --version >> ${work_dir}/${prj}/fastq2fasta_script-version.txt

cd ${work_dir}/${prj}/

ls -d */ | sed 's/\///g' > folder.list

while read i
do

#entry in the sample folder
cd ${i}
echo ">>> ${i} <<<"

mkdir -v "${i}_fasta"

for x in *.fastq.gz
do
 gunzip -c ${x} | awk '{if(NR%4==1) {printf(">%s\n",substr($0,2));} else if(NR%4==2) print;}' > ${i}_fasta/${x//.fastq.gz/}.fasta
done

cd ..

done < folder.list

echo
echo "<<< -- END FASTQ to FASTA Script -- >>>"
echo
