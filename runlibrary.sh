#!/bin/bash

cd   tmp/$1

	rna=`cat $2 | awk 'BEGIN{c=0} ($1!~/[ACTGU]+/){c++}END{print c}'`
	prot=`cat $2 | awk 'BEGIN{c=0} ($1!~/[ACDEFGHIKLMNPQRSTVWY]+/){c++}END{print c}'`

	if [[ "$rna" -ne 0 && "$prot" -ne 0 ]]; then
		exit 1;
	else
		if [[ "$rna" -eq 0 ]]; then 
			bash rungenerator.rna.sh "$2"
			echo "http://s.tartaglialab.com/prefills/catrapid_omics_protein/$1" > link.txt
		fi
	
		if [[ "$prot" -eq 0 ]]; then
			bash rungenerator.protein.sh "$2"
			echo "http://s.tartaglialab.com/prefills/catrapid_omics_transcript/$1" > link.txt
		fi
	fi
		
cd ..
