#!/bin/bash
# takes the sequences (label - sequence)
echo $2 | sed 's/T/U/g' | tr [a-z] [A-Z] | awk '{print "'$1'", $1}' > ./database/rna.50.3000.txt 
cp  ./database/rna.50.3000.txt  ./database/rna.txt
  
# computes 10 features (concatenated) secondary + polarity + hydro for rna and proteins
sh rna-feature.sh        ./database/rna.50.3000.txt       > ./database/rna.dat

# normalizes the lengths
sh adaptator.sh           ./database/rna.dat 3001         > ./database/rna.3000.dat

# computes fouriers' coefficients
sh fourier.line.fast.sh    ./database/rna.3000.dat   | awk '(NF==53)&&($2!=0)'

