#!/bin/bash

#example use ./proc_dataset.sh 4844 11276 1 >> 11276.out

#before running make sure to create directory biobank_download/
#put software folder with utilities in biobank_download directory
#make sure to create 3 separate key files-.key (full), _ED.key (only 2nd line),.ukb_key (first line and 24 characters of 2nd line)
#make sure to put encoding.ukb file for conv html to work
#1=app#
#2=dataset#
#3=1 for bulk, 0 for no bulk

#mkdir /home/alr79/scratch60/biobank_download/$1/$2/
cd /home/alr79/scratch60/biobank_download/$1/$2

#unpack/decrypt the encode file
../../software/ukbunpack ukb$2.enc k$1_$2.key #output ukb$2.enc_ukb


#convert dataset-csv, docs, then bulk if necessary*
../../software/ukbconv ukb$2.enc_ukb csv -oukb$2
mv ukb$2.log ukb$2_csv.log
mv fields.ukb $2_fields.ukb

../../software/ukbconv ukb$2.enc_ukb docs -oukb$2
mv ukb$2.log ukb$2_html.log
rm fields.ukb
#*if bulk files present convert them make a directory and move the bulk file and the log file into newly created directory.
if [ $3==1 ] ;
then
#	mkdir bulk_files
	../../software/ukbconv ukb$2.enc_ukb bulk -oukb$2
	mv ukb$2.log bulk_files/
	mv ukb$2.bulk bulk_files/
	#Go to bulk directory and separate bulk file by field IDs
	cd bulk_files
	awk -F' '  '{print > $2}' ukb$2.bulk
	echo "processing complete including bulk files-add bulk file descriptions to auth doc"
elif [ $3==0 ];
	then
	echo "no bulk files- processing complete"
else 
	echo "incorrect entry for argument 3- bulk file present 1=yes 0=no"
fi

#don't forget to note the number of fields and columns








