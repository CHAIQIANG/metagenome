samples=`cat sample.txt |cut -f1`
for sample in $samples
do
mkdir ${sample}
mv ${sample}_kraken2_report_nor.txt ${sample}_kraken2_report.txt ${sample}_kraken2_map.out ${sample}_kraken2_report_raw.txt ./${sample}
done