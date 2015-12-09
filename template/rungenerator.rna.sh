#!/bin/bash
mkdir ./tmp
mkdir ./results
mkdir ./database

myMAX=$2

touch not_calculated.txt sequences.txt
# remembers path
PATH=$PATH\:./bin/ ; export PATH

# run cases one by one
for i2 in `cat $1 | grep -v "#" | awk '{print $1}' | head -20000 | sed 's/>//g'`; do 

	si2=`grep -w $i2 $1 | awk '(NF==2){gsub(/[Uu]/, "T", $2); print toupper($2)}'`

	name=`echo $1 | sed 's/\.txt//g;s/\.oneline//g' | awk '{print $1}'`

	if [[ "${#si2}" -lt 50 || `wc -l sequences.txt | awk '{print $1}'` -gt "$myMAX" ]]; then 
		
		echo "$i2" >> not_calculated.txt

	elif [[ "${#si2}" -gt 1200 ]]; then 

		bash start.fragment.sh "$i2" "$si2" >> "$name".frag.rna.lib
		
		for fr in `awk '{print $1}' "$name.frag.rna.lib" | grep "$i2""_" | uniq`; do
			grep -m1 -w "$fr" tmp/rna.frags >> "$name".frag.txt
		done

	else
	
		bash start.rna.sh "$i2" "$si2" > out.tmp 

		if [[ -s "out.tmp" ]]; then

			entries=`wc -l out.tmp | awk '{print $1}'`

			if [[ "$entries" -eq 10 ]]; then
				cat out.tmp >> "$name".rna.lib
				rm out.tmp
				echo "$i2" "$si2" >> sequences.txt
			else
				echo "$i2" >> not_calculated.txt
				rm out.tmp
			fi
		else
			echo "$i2" >> not_calculated.txt
		fi
	fi

done

if [[ -s "$name.rna.lib" ]]; then
	mv "$name".rna.lib ./outputs/library.lib
	mv sequences.txt ./outputs/sequences.txt
fi
if [[ -s "$name.frag.rna.lib" ]]; then
		mv "$name".rna.lib ./outputs/library.frag.lib
		mv "$name".frag.txt ./outputs/sequences.frag.txt
fi
else
	touch ./outputs/library.lib
	touch ./outputs/sequences.txt
fi
mv not_calculated.txt ./outputs/not_calculated.txt

rm -fr tmp
rm -fr database
rm -fr results
