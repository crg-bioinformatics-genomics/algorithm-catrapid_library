#***************************************************************************
#                             catRAPID 
#                             -------------------
#    begin                : Nov 2010
#    copyright            : (C) 2010 by G.G.Tartaglia
#    author               : : Tartaglia
#    date                 : :2010-11-25
#    id                   : caRAPID protein-RNA interactions
#    email                : gian.tartaglia@crg.es
#**************************************************************************/
#/***************************************************************************
# *                                                                         *
# *   This program is free software; you can redistribute it and/or modify  *
# *   it under the terms of the GNU General Public License as published by  *
# *   the Free Software Foundation; either version 2 of the License, or     *
# *   (at your option) any later version.                                   *
# *                                                                         *
# ***************************************************************************/
#!/bin/bash

# reads the sets
for prot in `cat $1 | awk '{print $1}'` ; do 
grep $prot ./database/protein.txt | awk '{print $2}'> ./tmp/seq.txt; 

# uses the following physico-chemical properties
for scal in n.alpha.helix.roux.txt.sh n.alpha.helix.fasman.txt.sh n.beta.sheet.roux.txt.sh  n.beta.sheet.fasman.txt.sh n.beta.turn.roux.txt.sh n.beta.turn.fasman.txt.sh n.polarity.txt.sh  n.polarity.zimmerman.txt.sh n.hydropathicity.txt.sh n.hydrophobicity.2.txt.sh ; 
do 
sh $scal ./tmp/seq.txt | awk 'BEGIN{printf "%s\t", "'$prot'"; } {printf "%4.2f\t", $2} END{printf "\n"}'; done; 
done 
