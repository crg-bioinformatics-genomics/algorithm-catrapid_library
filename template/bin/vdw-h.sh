#!/bin/bash
awk ' {for(i=1;i<=length($1);i++){r[i]=substr($1,i,1)}} END{
for(i=1;i<=length($1);i++){if(r[i]=="A"){vdw=79+98+69+40+53+37+84+62+49+28;    h=24+17+40+10;} 
                           if(r[i]=="G"){vdw=26+74+24+37+22+21+19+67+48+44+21; h=21+86+17+41+29;} 
			   if(r[i]=="C"){vdw=14+44+98+42+30+50+39+19;          h=49+21+26;} 
			   if(r[i]=="U"){vdw=25+42+74+53+43+67+44+24;          h=24+17+22} print i, vdw/600, h/100}}' $1 > ./tmp/vdw.1.tmp
			   
			   
awk '{a[NR]=$2; b[NR]=$3} END{
			   print 1, a[1]/1.5, b[1]/1.5; print 2, (a[1]+a[2]+a[3])/3.5, (b[1]+b[2]+b[3])/3,5 ;  print 3, (a[1]+a[2]+a[3]+a[4]+a[5])/5.5, (b[1]+b[2]+b[3]+b[4]+b[5])/5.5 ; 
			   for(i=1+3;i<=NR-3;i++){print i,(a[i-3]+a[i-2]+a[i-1]+a[i]+a[i+1]+a[i+2]+a[i+3])/7, (b[i-3]+b[i-2]+b[i-1]+b[i]+b[i+1]+b[i+2]+b[i+3])/7;} 
			   print NR-2, (a[NR-2]+a[NR-3]+a[NR-4]+a[NR-1]+a[NR])/5.5,  (b[NR-2]+b[NR-3]+b[NR-4]+b[NR-1]+b[NR])/5.5; print NR-1,  (a[NR-1]+a[NR-2]+a[NR])/3.5, (b[NR-1]+b[NR-2]+b[NR])/3.5;
			   print NR, a[NR]/1.5, b[NR]/1.5}' ./tmp/vdw.1.tmp
