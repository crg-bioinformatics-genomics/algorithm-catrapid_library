#!/bin/bash

cd   tmp/$1

	rna=`cat $2 | awk -F "\t" 'BEGIN{s=0}{c=0;for(i=1;i<=length($2);i++){if(substr($2,i,1)~/A/ || substr($2,i,1)~/T/ || substr($2,i,1)~/U/ || substr($2,i,1)~/C/ || substr($2,i,1)~/G/){c++}} s+=c/length($2)}END{if(s/NR==1){print 1}else{print 0}}'`
	prot=`echo $rna | awk '{print 1-$1}'`

	if [[ "$rna" -ne 0 && "$prot" -ne 0 ]]; then
		exit 1;
	else
		if [[ "$rna" -eq 1 ]]; then 
			bash rungenerator.rna.sh "$2"
			echo "http://s.tartaglialab.com/prefills/catrapid_omics_protein/$1" > outputs/link.txt
		fi
	
		if [[ "$prot" -eq 1 ]]; then
			bash rungenerator.protein.sh "$2"
			echo "http://s.tartaglialab.com/prefills/catrapid_omics_transcript/$1" > outputs/link.txt
		fi
	fi
	
cd ..
