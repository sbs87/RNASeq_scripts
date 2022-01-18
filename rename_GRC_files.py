#!/usr/bin/python

""" The purpose of this script is to rename the GRC's 'ILXXX' designation to an internal sample naming conventio
It will first rename directories, then the R1 and R2 file names. 

This script assumes that files have already been copied to the local directory, and that R1 and R2 files exist in a particualr format (see below). 

Assumes the suffix for SRL R1/R2 fastq is '_trimmed.fastq.gz'and TRL/MRL is '.fastq.gz' 

Input:
<base_directory> <library_type> <sample_name_mapping_file>

where base_dir is something like /local/projects-t2/HRBV/ -- note the last slash- REQUIRED!
library_type is SRL, TRL or MRL (and a directory off the base_dir must exist prior)
mapping_file- tab delimited file, with
<My name> <IL name> <S #> <Lane #>
<UABXXX_WXDY> <ILXXX> <1> <005>

Output:
Standard out- whether the files were successfully renamed. Also, renamed dirs/files. 

 """ 

import sys
import os
from datetime import date, time, datetime
import shutil

script_name=sys.argv[0]
arguments=sys.argv[1:]
lib_type=arguments[1]
base_name=arguments[0]+lib_type+"/"
sample_name_map_file=open(arguments[2],'r')
sample_name_map=dict()
#log_file_name=arguments[2]

if lib_type=="SRL":
	GRC_suffix='_trimmed.fastq.gz'
else:
	GRC_suffix='_trimmed.fastq.gz'

lines = sample_name_map_file.readlines() # reads in all lines, including retrns and tab delimits.
vectors = [line.rstrip().split("\t") for line in lines] # stores remaining values into array
for line in vectors:
	#print vectors
	IL_sample_name=line[1]
	my_sample_name=line[0]
	lane=line[3]
	GRC_sample=line[2]
	sample_name_map[IL_sample_name]={'sample':my_sample_name,'s':GRC_sample,'lane':lane}
sample_name_map_file.close()

#sample_name_map={'IL123':{'sample':'UAB001','s':'4','lane':'004'}}

#log=open(log_file_name,'a')
for GRC in sample_name_map:
	old_dir=base_name+"Sample_"+GRC
	new_dir=base_name+lib_type+"_"+sample_name_map[GRC]['sample']
	try:
		shutil.move(old_dir, new_dir)
		log_out="renamed "+old_dir+" to "+new_dir+" on "+str(datetime.now())
		print log_out
		#log.write(log_out+"\n")
 	except IOError:
 		print "ERROR!: \t{1}\tDIR name {0}\tERROR\tERROR\tERROR".format(e.filename, e.strerror)
 		pass
	GRC_sample=sample_name_map[GRC]['s']
	GRC_lane=sample_name_map[GRC]['lane']
	for R in ('1','2'):
		old_file=new_dir+"/"+GRC+"_S"+GRC_sample+"_L"+GRC_lane+"_R"+R+"_001"+GRC_suffix
		new_file=new_dir+"/"+lib_type+"_"+sample_name_map[GRC]['sample']+"_R"+R+GRC_suffix
		try:
			shutil.move(old_file,new_file)
			log_out="renamed "+old_file+" to "+new_file+" on "+str(datetime.now())
			print log_out
			#log.write(log_out+"\n")
		except IOError:
			print "ERROR!: \t{1}\tFILE name {0}\tERROR\tERROR\tERROR".format(e.filename, e.strerror)
			pass
#log.close()
