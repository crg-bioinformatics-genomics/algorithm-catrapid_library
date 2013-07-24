#!/bin/bash
set -o pipefail

mkdir ./tmp
mkdir ./results
mkdir ./database

touch not_calculated.txt
cc iupred.c -o iupred

# remembers path
PATH=$PATH\:./bin/ ; export PATH


# run cases one by one
for i2 in `cat $1 | grep -v "#" | awk '{print $1}' | head -1000 | sed 's/>//g'`; do 

	si2=`grep -w $i2 $1 | awk '(NF==2){print $2}'`

	echo ">"$i2 $si2 > input_sequence.oneline
	echo ">"$i2 > input_sequence.fasta
	echo $si2  >> input_sequence.fasta
	
	touch RNAdom.list DNAdom.list
	hmmscan --cut_ga --noali --domtblout fragmentation.log ../Pfam_hmm/Pfam-A.hmm input_sequence.fasta > hmm_log.txt
	grep -f "RNAfiltering.list" "fragmentation.log" | awk '{print $4}' | sort -u > RNAdom.list
	grep -v -f "RNAfiltering.list" "fragmentation.log" | grep -f "RNA-DNAfiltering.list" | awk '{print $4}' | sort -u > DNAdom.list
# 	./iupred input_sequence.fasta long | grep -v "#" | awk 'BEGIN{str=""}{str=sprintf("%s%c",str,$2);a[NR]=$2;b[NR]=$3;if($3>0.4){c++}}END{print c/NR}' | awk '($1>0.3){print "'$i2'"}' 
	
	if [[ -s "RNAdom.list" || -s "DNAdom.list" ]]; then

		name=`echo $1 | sed 's/\.txt//g;s/\.oneline//g' | awk '{print $1}'`

		bash start.protein.sh $i2 $si2 > out.tmp 

		entries=`wc -l out.tmp | awk '{print $1}'`

		if [[ "$entries" -eq 10 ]]; then
			cat out.tmp >> $name.prot.lib
			rm out.tmp
			echo "$i2" "$si2" >> sequences.txt
		else
			echo "$i2" >> not_calculated.txt
			rm out.tmp
		fi
	
	fi
	
	rm RNAdom.list DNAdom.list

done

if [[ -s "$name.prot.lib" ]]; then
	mv $name.prot.lib ./outputs/library.lib
	mv sequences.txt ./outputs/sequences.txt
else
	touch ./outputs/library.lib
	touch ./outputs/sequences.txt
fi

mv not_calculated.txt ./outputs/not_calculated.txt

rm -fr tmp
rm -fr database
rm -fr results
