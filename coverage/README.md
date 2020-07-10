#### coverage步骤

- 在NCBI下载要做的微生物或者病毒的参考序列【fasta或者fna格式】；
- 用bowtie2进行构建索引 ``bowtie2-build ./Ecoli_ref.fa Ecoli_index --threads 10``

- 用bowtie2进行比对得到BAM文件``bowtie2 -p 10 -x /path_to_index/Ecoli_index -1 fastq1 -2 fastq2 | samtools sort -O bam -@ 10 -o - > $sample.bam``
- samtools进行提取深度coverage，代码如下：

``samtools depth $sample.bam > $sample_depth.txt``

- 绘图【R脚本】