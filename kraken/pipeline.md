脑脊液生物信息分析材料与方法：

**一、所用的软件**

1、**FASTQC**

首先，对测序数据进行质控，看是否质量过关、去除接头，一般来说公司给的测序数据是去除接头的并且质量合格的，但是我们还是需要进行检查。

```
fastqc -q -t $threads -f fastq ${path_to_fastq_1}/${sample}_1.fastq.gz ${path_to_fastq2}/${sample}_2.fastq.gz 
```

FASTQC结果详解：https://www.jianshu.com/p/a1eb03d63083

当然也可以使用multiQC【https://multiqc.info/】对多个样本质控结果进行查看。

**1、****kraken2**【https://www.ccb.jhu.edu/software/kraken2/】

   该工具使用k-mers将NCBI分类格式的分类标签分配给所需要查询的序列。 基于所查询的序列的相似k-mers与参考基因组序列的k-mers分配分类学标签。 结果是将所查询的序列分类为最可能的分类标签。 如果k-mer与所用数据库中的任何基因组序列不相似，则不会分配任何分类标签。

1.1 安装kraken2及 MINIKRAKEN2 数据库  

   通过conda进行软件kraken2的安装【https://genomics.sschmeier.com/ngs-taxonomic-investigation/index.html#kraken2】，并通过给定的网址下载分类所需的数据库【https://ccb.jhu.edu/software/kraken2/index.shtml?t=downloads】，该数据库中包括了人类、细菌、古生菌和病毒的k-mers参考序列，可以用于后面的分类。

1.1.1 按照kraken2的步骤进行kraken2的安装

![img](https://note.youdao.com/yws/public/resource/8f8ce4ca2e4a8a4f1f7ee9c7ef5dd495/xmlnote/810F98302E4D47BE9DF54FF7A7721358/12707)

1.1.2 下载kraken2所用的数据库用于后面的reads分类

![img](https://note.youdao.com/yws/public/resource/8f8ce4ca2e4a8a4f1f7ee9c7ef5dd495/xmlnote/7B30CE1290FF45738E730CD278846205/12721)

 

1.2  用法

   kraken2可以支持fastq以及fasta格式作为输入文件，可以通过下面的代码进行对单个样本进行分类。

```
/work/tools/kraken2/kraken2 --db minikraken2_v2_8GB --threads 20 --paired $data/${sample}_L001_R1_001.fastq.gz $data/${sample}_L001_R2_001.fastq.gz --output ${sample}_kraken2_map.out --report ${sample}_kraken2_report_raw.txt
option：
--db  用于分类的k-mer数据库
--threads  设置线程
--paired   双端测序的fastq文件
--output   map的结果
--report   从界门纲目科属种各个水平进行分类。
```

1.3 结果解读

 结果文件详解：

![](C:\Users\13516\Pictures\Saved Pictures\微信图片_20200710113243.png)

1.4 提取物种(species）的reads信息以及标准化【genome size】

1.4.1 提取物种的reads信息

上述的结果会产生两个文件${sample}_kraken2_map.out和${sample}_kraken2_report_raw.txt，物种的reads信息提取见代码：

```
awk -vOFS='\t' '{NF=10}1' ${sample}_kraken2_report_raw.txt|awk '$4=="S"'|sort -nrk 2,2 >${sample}_kraken2_report.txt
options：
-vOFS  指定输出文件的分隔符
NF  一条记录的字段的数目
$4  指的是提取第四列为“S”，也就是物种层面。
sort option：
-n  指的是按照大小排序
-r  指的是相反方向排序
-k  指的是按照什么标准， sort -nrk 2,2表示只按照第二列进行排序，如果是sort -nrk 2则表示从第二列到最后一列进行排序。
```

**1.4.2 标准化**

**从**${sample}_kraken2_report_raw.txt文件去除不同病原体的基因组大小对于reads含量的影响，代码如下：

```
awk -vOFS='\t' '{NF=10}1' ${sample}_kraken2_report_raw.txt|awk '$4=="S"'|perl $dir/join_size.pl|sort -nrk 1|sed 's/\t/ /6g'|awk '$5!="9606"'|awk '$2>29' >${sample}_kraken2_report_nor.txt
option：
join_size.pl  这个是对每个物种的reads除以其基因长度进行标准化的脚本
sed 's/\t/ /6g'  指的是对于第六列的分隔符有“\t"变为空格 
$5!="9606"   指的是去除human  reads 
$2>29  指的是reads数目大于29的物种保留
#### join_size.pl

my %size;
open IN,"</f/chaiqiang/projects/metagenomics/kraken_analysis/analysis_result/normallize_file/M3_taxid_size.table";
while(<IN>){
chomp;
my @row=split;
$size{$row[0]}=$row[1];
}

while(<>){
  chomp;
  my @row=split /\t/,$_;
  next unless($size{$row[4]});
  $row[0]=$row[1]/($size{$row[4]}*(10**3));
  $row[0]=sprintf "%.4f",$row[0];
  $row[2]=$size{$row[4]};
  $_=join "\t",@row;
  print "$_\n";
}

```

**2、****pavian【**[**https://fbreitwieser.shinyapps.io/pavian/**](https://fbreitwieser.shinyapps.io/pavian/)**】**

   该软件是用来对kraken2产生结果进行可视化以及分类reads含量统计的，该软件统计的结果可以用来在R中进行绘图。

2.1 输入文件

​    kraken2的标准输出【eg:${sample}_report_raw.txt】

2.2 输出文件

该网页软件的输出文件是html格式，里面包括了在reads层面的宿主、病原体以及未分类的reads数和reads占比统计，还有将各种病原体的reads数进行了统计，最后还对于每个样本进行了从界门纲目科属种的顺序进行了可视化。

**3、****R** **和****python**

   在进行下游的可视化分析时，用到了很多的**R package**，比如pheatmap、barplot以及ggplot2等，并使用Python的pandas和numpy进行数据的规整。

① reads_level classify的R脚本：01_barplot_reads_level_classify.R

② pathogen_level classify的R脚本： 02_barplot_pathogen_level_classify.R

③ 不同核酸提取方法和建库方法比较的脚本：compare.R

④ 绘制heatmap的脚本： heatmap.R

**二、分类过程**

   我们将脑脊液的测序数据【fastq文件】作为kraken2的输入，通过与我们之前已经下载好的MINIKRAKEN2 数据库进行比对来进行分类，最终得到输出文件：

输出文件中包括了未分类、宿主以及各种微生物按照【界门纲目科属种】进行分层reads含量以及占比的信息，并且含有NCBI Taxonomy的ID，该ID可以用来去NCBI中提取各种微生物（病原体）的基因组大小，用于后续的标准化。

三、标准化过程

​    从kraken2的输出结果中提取属于种（Species）的所有微生物（病原体），对于每个样本的每种微生物的reads数目可以通过kraken2得到，然后将每种微生物的reads数目除以其自身的基因组大小得到标准化的各种微生物（病原体）的标准化之后的reads，从而来进行消除基因组大小对物种丰富的影响，

四、比较

​    我们通过将实验组和对照组【水】标准化之后的reads数目进行比值计算，按照比值的分为六个等级，分别为sample < control、sample > control、sample > 10 control、sample > 100 control、sample > 1000 control、sample > 5000 control,分别对应1、2、3、4、5、6，来看不同浓度、不同核酸提取方法、不同建库方法以及不同裂解方法的对于微生物丰度的影响。