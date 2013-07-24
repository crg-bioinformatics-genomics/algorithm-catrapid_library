#!/bin/bash
set -o pipefail

mkdir ./tmp
mkdir ./results
mkdir ./database

touch not_calculated.txt
# remembers path
PATH=$PATH\:./bin/ ; export PATH

# run cases one by one
for i2 in `cat $1 | grep -v "#" | awk '{print $1}' | head -1000 | sed 's/>//g'`; do 

	si2=`grep -w $i2 $1 | awk '(NF==2){print $2}'`

	name=`echo $1 | sed 's/\.txt//g;s/\.oneline//g' | awk '{print $1}'`

	bash start.rna.sh $i2 $si2 > out.tmp 

	if [[ -s "out.tmp" ]]; then

		entries=`wc -l out.tmp | awk '{print $1}'`

		if [[ "$entries" -eq 10 ]]; then
			cat out.tmp >> $name.rna.lib
			rm out.tmp
			echo "$i2" "$si2" >> sequences.txt
		else
			echo "$i2" >> not_calculated.txt
			rm out.tmp
		fi

	fi

done

if [[ -s "$name.rna.lib" ]]; then
	mv $name.rna.lib ./outputs/library.lib
	mv sequences.txt ./outputs/sequences.txt
else
	touch ./outputs/library.lib
	touch ./outputs/sequences.txt
fi
mv not_calculated.txt ./outputs/not_calculated.txt

rm -fr tmp
rm -fr database
rm -fr results
