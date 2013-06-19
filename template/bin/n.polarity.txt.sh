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
awk '(NR==1){T=1; N=1; P=1; for(i=1;i<=length($1);i++){
    aminoacid[i]=substr($1,i,1); 
if(aminoacid[i]=="A"){c=0.395062};
if(aminoacid[i]=="C"){c=0.0740741};
if(aminoacid[i]=="D"){c=1};
if(aminoacid[i]=="E"){c=0.91358};
if(aminoacid[i]=="F"){c=0.037037};
if(aminoacid[i]=="G"){c=0.506173};
if(aminoacid[i]=="H"){c=0.679012};
if(aminoacid[i]=="I"){c=0.037037};
if(aminoacid[i]=="K"){c=0.790123};
if(aminoacid[i]=="L"){c=0};
if(aminoacid[i]=="M"){c=0.0987654};
if(aminoacid[i]=="N"){c=0.82716};
if(aminoacid[i]=="P"){c=0.382716};
if(aminoacid[i]=="Q"){c=0.691358};
if(aminoacid[i]=="R"){c=0.691358};
if(aminoacid[i]=="S"){c=0.530864};
if(aminoacid[i]=="T"){c=0.45679};
if(aminoacid[i]=="V"){c=0.123457};
if(aminoacid[i]=="W"){c=0.0617284};
if(aminoacid[i]=="Y"){c=0.160494};
if(aminoacid[i]=="X"){c='0.422839'}
print aminoacid[i],c}}' $1 | awk '{a[NR]=$1; b[NR]=$2} END{
print 1,  b[1]
print 2, (b[1]+b[2]+b[3])/3;
print 3, (b[1]+b[2]+b[3]+b[4]+b[5])/5;
for(i=4;i<=NR-3;i++){A=(b[i-3]+b[i-2]+b[i-1]+b[i]+b[i+1]+b[i+2]+b[i+3])/7; print  i, A}
print NR-2, (b[NR]+b[NR-1]+b[NR-1]+b[NR-3]+b[NR-4])/5;
print NR-1, (b[NR]+b[NR-1]+b[NR-2])/3;
print NR,    b[NR]
 
}'
