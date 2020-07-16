#### krakenUniq pipeline



## Installation

```
conda install krakenuniq
```

❗ Note that KrakenUniq requires JEllyfish v1 to be installed for database building step(krakenuniq-build).

## Database building

💥Note that KrakenUniq natively supports Kraken1 database(however not Kraken2).if you have existing Kraken databases,you may run KrakenUniq directly on them ,though for support of taxon nodes for genomes and sequences(see below)you will rebuild them with KrakenUniq. For building s cudtom database,there are three requirements:

1. Sequence files (FASTA format)
2. Mapping files (tab separated format,`sequence header<tab>taxID`)
3. NCBI taxonomy files (though a custom taxonomies may be used,too)

While you may supply this information yourself, `krakenuniq-download` supports a variety of data sources to download the taxonomy, sequence  and mapping files. Please find examples below on how to download  different sequence sets:

```
## Download the taxonomy
krakenuniq-download --db DBDIR taxonomy

## All complete bacterial and archaeal genomes genomes in RefSeq using 10 threads, and masking low-complexity sequences in the genomes
krakenuniq-download --db DBDIR --threads 10 --dust refseq/bacteria refseq/archaea

## Contaminant sequences from UniVec and EmVec, plus the human reference genome
krakenuniq-download --db DBDIR refseq/vertebrate_mammalian/Chromosome/species_taxid=9606

## All viral genomes from RefSeq plus viral 'neighbors' in NCBI Nucleotide
krakenuniq-download --db DBDIR refseq/viral/Any viral-neighbors

## All microbial (including eukaryotes) sequences in the NCBI nt database
krakenuniq-download --db DBDIR --dust microbial-nt
```

💥Note :small_database include bacterial 、archaeal and viral genomes.

To build the database indices on the downloaded files, run `krakenuniq-build --db DBDIR`.  To build a database with a *k*-mer length of 31 (the default), adding virtual taxonomy nodes for genomes and sequences (off by default), run `krakenuniq-build` with the following parameters:

`krakenuniq-build --db samll_database --kmer-len 31 --threads 10 --taxids-for-genomes --taxids-for-sequences`

## Classification

To run classification on a pair of FASTQ files, use `krakenuniq`

`krakenuniq --db small_database --threads 20 --report-file result.tsv --fastq-input --gzip-compressed --paired $sample.fq1.gz $sample.fq2.gz > result_classify.tsv`

💥Note: `result.csv`文件中包含了K-mer的物种分类，K-mer counts以及coverage等，文件如下：

![image-20200716112911546](C:\Users\13516\AppData\Roaming\Typora\typora-user-images\image-20200716112911546.png)

`result_classify.tsv`文件的结果是k-mer和reads的比对结果：

![image-20200716113038055](C:\Users\13516\AppData\Roaming\Typora\typora-user-images\image-20200716113038055.png)

## FAQ

### Memory requirements

KrakenUniq requires a lot of RAM - ideally 128GB - 512GB. For more memory efficient classification consider using [centrifuge](https://github.com/infphilo/centrifuge).