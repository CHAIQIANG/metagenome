
my %size;
open IN,"</home/chaiq/metagenome/2019_12_CSF_V1/data/qu-WTA/normalize_file/M3_taxid_size.table";
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
