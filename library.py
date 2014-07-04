#!/usr/bin/env python
import argparse
import yaml
import os
import subprocess
import shutil, errno
import re
import sys
import stat

# we want to be agnostic to where the script is ran
SCRIPT_PATH = os.path.dirname(os.path.realpath(__file__))
WORKER_PATH = os.path.realpath(os.curdir)

# Function to copy the output directory content
def copyfolder(src, dst):
    try:
        shutil.copytree(src, dst)
    except OSError as exc: # python >2.5
        if exc.errno == errno.ENOTDIR:
            shutil.copy(src, dst)
        else: raise
        
# read the task definition yaml file
with open(os.path.join(SCRIPT_PATH, "catrapid_library.yaml"), "r") as task_f:
    task_definition = yaml.load(task_f)

parser = argparse.ArgumentParser(
   description='Launches catRAPID omics with properly parset parameters')

parser.add_argument(
   '-fileA', type=str, default=["none"], nargs=1, help='Fasta sequence')

parser.add_argument(
   '-output_dir', type=str, nargs=1,
   help='Directory where the output is going to be stored')

# accept form fields
for item in task_definition['form_fields']:
   nargs = 1 if item['required'] else "?"
   parser.add_argument(
       '-FORM%s'%item['name'], type=str, default="none", nargs=nargs,
       help='Form argument: %s' % item)

# this parse_args stops if any unexpected arguments is passed
args = parser.parse_args()

OUTPUT_PATH = os.path.join(WORKER_PATH, args.output_dir[0])
random_number = (""" "{}" """.format(args.output_dir[0])).split("/")[3]

TMP_PATH = SCRIPT_PATH+"/tmp/"+random_number
if os.path.exists(TMP_PATH) == True:
    shutil.rmtree(TMP_PATH)
copyfolder(SCRIPT_PATH+"/template", TMP_PATH)

import StringIO
from Bio import SeqIO


rna = set("ACGTU")
protein = set("ACDEFGHIKLMNPQRSTVWY")
def validate_rna(seq, alphabet=rna):
    "Checks that a sequence only contains values from an alphabet"
    leftover = set(seq.upper()) - alphabet
    return not leftover
def validate_prot(seq, alphabet=protein):
    "Checks that a sequence only contains values from an alphabet"
    leftover = set(seq.upper()) - alphabet
    return not leftover

input_handle = open(args.fileA[0], "rU")
fastaSeq = (record for record in SeqIO.parse(input_handle, "fasta"))
onelineFile = TMP_PATH+"/sequences.oneline"
output_handle1 = open(onelineFile, "w")
numPos = SeqIO.write(fastaSeq, output_handle1, "tab")
output_handle1.close()

os.chdir(SCRIPT_PATH)

args.FORMtitle = "".join([t.replace(' ', '_') for t in args.FORMtitle])

command = """ bash runlibrary.sh "{}" "{}" "{}" """.format(random_number, onelineFile, args.FORMtitle)

p = subprocess.Popen(command, cwd=SCRIPT_PATH, shell=True)
p.communicate()

# import IPython
# IPython.embed()

if p.returncode == 0:
	TMP_PATH = SCRIPT_PATH+ "/tmp/"+ random_number+"/outputs/"
	with open(os.path.join(TMP_PATH,"link.txt"), 'r') as l:
  		myLink = l.readline()	
	dirList=os.listdir(TMP_PATH)
	for file in dirList:
		shutil.copyfile(TMP_PATH+file, OUTPUT_PATH+file)
	if os.path.exists(OUTPUT_PATH+"images") == False :
		copyfolder(SCRIPT_PATH+"/images", OUTPUT_PATH+"images")
	
	from django.template import Template
	from django.template import Context
	from django.conf import settings
	from django.template import Template
	
	settings.configure(TEMPLATE_DIRS=(os.path.join(SCRIPT_PATH,'./')), DEBUG=True, TEMPLATE_DEBUG=True)
	
	if os.stat(OUTPUT_PATH+"library.lib")[6]==0:
		myIndex="index.no_library.html"
	else:
		myIndex="index.library.html"
	
	# read the template file into a variable
	with open(os.path.join(SCRIPT_PATH, myIndex), "r") as template_file:
	   template_string = "".join(template_file.readlines())
	
	import datetime
	
	# create template from the string
	t = Template(template_string)
	
	myTitle = args.FORMtitle.replace('poweroverwhelming', 'po').replace('gold', 'G').replace('silver', 'S').replace('iron', 'I')

	# context contains variables to be replaced
	c = Context(
	   {
		   "title": myTitle,
		   "DatasetA": (""" "{}" """.format(args.fileA[0])).split("/")[5].split("\"")[0],
		   "randoms" : random_number,
		   "generated" : str(datetime.datetime.now()),
		   "link_to_omics" : myLink
	   }
	)
	
	# and this bit outputs it all into index.html
	with open(os.path.join(OUTPUT_PATH, "index.html"), "w") as output: 
	   output.write(t.render(c))
	   
else:
	sys.exit("The execution of the C code  failed.")
