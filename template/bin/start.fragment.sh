#!/bin/bash
echo $2 > tmp/out

span=200

RNALfold  -L $span < tmp/out | awk '{print $0, length($1)}' | awk '(NF>=4){print $(NF-2), $(NF-1), $NF}' | awk '($3>50)' > tmp/out.2

for u in `cat tmp/out.2 | awk '{print $2"-"$3}'`; do 
	
	pos=`echo $u | sed 's/-/ /g' | awk '{print $1}'`; 
	length=`echo $u | sed 's/-/ /g' | awk '{print $2}'`; 
	awk '{end='$pos'+'$length'; print "'$1'_'$pos'-"end, substr($1,"'$pos'", "'$length'")}' tmp/out; 

done > tmp/outx.txt

cat tmp/outx.txt | awk '(length($2)>'$span'-100)' > tmp/rna.frags

for f1 in `awk '{print $1}' tmp/rna.frags`; do

	sf1=`grep -w -m1 $f1 tmp/rna.frags | awk '{print $2}'`
	
	./bin/start.modified.sh $f1 $sf1

done