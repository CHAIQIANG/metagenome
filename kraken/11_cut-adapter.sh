samples=`cat sample_info2.txt | cut -f1`
for sample in $samples
do
trim_galore -q 20 --phred33 --stringency 5 --length 50 \
            --paired ./raw_data2/${sample}_1.fq.gz ./raw_data2/${sample}_2.fq.gz  \
            --gzip -o ./clean_data
done

