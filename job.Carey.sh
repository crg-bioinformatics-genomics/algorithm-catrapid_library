SEQs=105
for ((i=1;i<=$SEQs;i++)); do 

seqline=$(expr $i \* 2 );
head -$seqline /home/processor/Fernando/UTRaa.txt | tail -2 > /home/processor/Fernando/Pquery.fasta;
head -$seqline /home/processor/Fernando/UTRnt.txt | tail -2 > /home/processor/Fernando/Rquery.fasta;
name=$(head -1 /home/processor/Fernando/Pquery.fasta);

pseq=$(tail -1 /home/processor/Fernando/Pquery.fasta);
rseq=$(tail -1 /home/processor/Fernando/Rquery.fasta);

#mkdir /home/processor/Fernando/"$name"

bash runcatrapid.graphic.sh Carey fernando.cid@crg.es $name $pseq $rseq

cp -r ./tmp/Carey/* /home/processor/Fernando/"$name"

#sed -i 's/\r$//' job.Carey.sh

done;
