#!/bin/bash
mkdir ./tmp
mkdir ./results
mkdir ./database

myMAX=$2

touch not_calculated.txt sequences.txt
cc iupred.c -o iupred

# remembers path
PATH=$PATH\:./bin/ ; export PATH

opt=$3

# run cases one by one
for i2 in `cat $1 | grep -v "#" | awk '{print $1}' | head -20000 | sed 's/>//g'`; do

	si2=`grep -w -m1 "$i2" $1 | awk '(NF==2){print $2}'`

	if [[ "${#si2}" -ge 50 && "${#si2}" -lt 750 && `wc -l sequences.txt | awk '{print $1}'` -le "$myMAX" ]]; then

# 		echo ">"$i2 $si2 > input_sequence.oneline
# 		echo ">"$i2 > input_sequence.fasta
# 		echo $si2  >> input_sequence.fasta

# 		touch RNAdom.list DNAdom.list
# 		hmmscan --cut_ga --noali --domtblout fragmentation.log ../Pfam_hmm/Pfam-A.hmm input_sequence.fasta > hmm_log.txt
# 		grep -f "RNAfiltering.list" "fragmentation.log" | awk '{print $4}' | sort -u > RNAdom.list
# 		grep -v -f "RNAfiltering.list" "fragmentation.log" | grep -f "RNA-DNAfiltering.list" | awk '{print $4}' | sort -u > DNAdom.list
# #	 	./iupred input_sequence.fasta long | grep -v "#" | awk 'BEGIN{str=""}{str=sprintf("%s%c",str,$2);a[NR]=$2;b[NR]=$3;if($3>0.4){c++}}END{print c/NR}' | awk '($1>0.3){print "'$i2'"}' 

# 		if [[ -s "RNAdom.list" || -s "DNAdom.list" ]]; then

			name=`echo $1 | sed 's/\.txt//g;s/\.oneline//g' | awk '{print $1}'`

			bash start.protein.sh $i2 $si2 > out.tmp

			if [[ -s "out.tmp" ]]; then
				entries=`wc -l out.tmp | awk '{print $1}'`

				if [[ "$entries" -eq 10 ]]; then
					cat out.tmp >> $name.prot.lib
					rm out.tmp
					echo "$i2" "$si2" >> sequences.txt
				else
					echo "$i2" >> not_calculated.txt
					rm out.tmp
				fi
			else
				echo "$i2" >> not_calculated.txt
			fi
			
#			rm RNAdom.list DNAdom.list
			
		# else
		# 	echo "$i2" >> not_calculated.txt
		# fi

	else
		if [[ "$opt" -eq "uniform" ]]; then
			echo "$i2" "$si2" > outfile
			pr=`cat outfile | awk '(NR==1){s=length($2)/50; if(s<=25){s=25}  if(s>=375){s=375} print int(s)}'`
			bash bin/cutter.sh outfile $pr > outfile.fr
			for fi2 in `cat outfile.fr | grep -v "#" | awk '{print $1}'`; do 
				si2=`grep -w $fi2 outfile.fr | awk '(NF==2){print $2}'`
				le2=`grep -w $fi2 outfile.fr | awk '(NF==2){print length($2)}'`
				bash start.protein.sh "$i2"_"$fi2" "$si2" >> "$name".frag.prot.lib
			done
		fi

	fi

done

if [[ -s "$name.prot.lib" ]]; then
	cat $name.prot.lib >> ./outputs/library.lib
	cat sequences.txt >> ./outputs/sequences.txt
fi
if [[ -s "$name.frag.prot.lib" ]]; then
	cat "$name".frag.prot.lib >> ./outputs/library.lib
	cat sequences.txt >> ./outputs/sequences.txt
fi

mv not_calculated.txt ./outputs/not_calculated.txt

#rm -fr tmp
rm -fr database
rm -fr results
