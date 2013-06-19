#!/bin/bash
for rna in `cat $1 | awk '{print $1}'`; do 

grep $rna ./database/rna.txt | awk '{print $2}' > ./tmp/seq-rna.txt; 

# secondary structure
sh secondary.structures.sh ./tmp/seq-rna.txt 6 $rna; 
cp ./results/out ./results/$rna.ss.txt

#VdW and polar
sh vdw-h.sh ./tmp/seq-rna.txt $rna > ./tmp/vdw.txt
awk '{a[NR]=$2; b[NR]=$3} END{printf "%s\t", "'$rna'"; for(i=1;i<=NR;i++){printf "%4.2f\t",a[i]} 
printf "\n%s\t", "'$rna'"; for(i=1;i<=NR;i++){printf "%4.2f\t",b[i]} printf "\n";}' ./tmp/vdw.txt

sh vdw-h.2.sh ./tmp/seq-rna.txt $rna > ./tmp/vdw.txt
awk '{a[NR]=$2; b[NR]=$3} END{printf "%s\t", "'$rna'"; for(i=1;i<=NR;i++){printf "%4.2f\t",a[i]} 
printf "\n%s\t", "'$rna'"; for(i=1;i<=NR;i++){printf "%4.2f\t",b[i]} printf "\n";}' ./tmp/vdw.txt 
done
