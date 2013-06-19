#!/bin/bash
awk '{
printf "%s\t",$1;
j=1; for(i=2;i<=NF;i++){s[j]=$i;j++}
#
s[1]=0;
s[j]=s[1];  
#
for(k=0;k<52;k++){
c=0;
for(i=0;i<j-1;i++){
c=c+sqrt(2/(j-1))*s[i+1]*cos( (3.14/(j-1))*(k+1/2)*(i+1/2))};
 printf "%4.2f\t",c
}
printf "\n"}' $1
#; done 
