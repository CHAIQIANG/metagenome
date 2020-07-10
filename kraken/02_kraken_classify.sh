dir=`pwd`
data='/home/chaiq/metagenome/2019_12_CSF_V1/data/qu-WTA/clean_data'

while read sample
do

#kraken2 --db /home/chaiq/metagenome/ref_database/minikraken2_v2_8GB/ --threads 30 --paired ${data}/${sample}_1_val_1.fq.gz ${data}/${sample}_2_val_2.fq.gz --output ${sample}_kraken2_map.out --report ${sample}_kraken2_report_raw.txt

awk -vOFS='\t' '{NF=10}1' ${sample}_kraken2_report_raw.txt|awk '$4=="S"'|sort -nrk 2,2 >${sample}_kraken2_report.txt

awk -vOFS='\t' '{NF=10}1' ${sample}_kraken2_report_raw.txt|awk '$4=="S"'|perl join_size.pl|sort -nrk 1|sed 's/\t/ /6g'|awk '$5!="9606"'|awk '$2>29' >${sample}_kraken2_report_nor.txt


done< sample.txt
