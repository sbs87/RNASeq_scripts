import sys
workorder=sys.argv[1]
READ_N=sys.argv[2]
f=open("/local/projects-t2/HRBV/Config/GRC.txt",'r').readlines()
map_f=open("/local/projects-t2/HRBV/Config/IL_S_L.map",'r').readlines()
il=''
grc_deliver=dict()
for lnumber_raw,line_raw in enumerate(f):
	lnumber=lnumber_raw#-1
	line=line_raw.rstrip().split("\t")

	##	Study	Sample	LIMS Sample ID	Library Type	Insert Size	LIMS Library ID	Total Reads	Bases	Data Path
	if lnumber%3==0:
		print line[2]
		sample=line[2]
		il=line[6]
		grc_deliver[il]={"name":sample,"nbases":'',"path":'',"S":'',"L":''}
		#print grc_deliver[il]
	elif lnumber%3==1:
		grc_deliver[il]["nbases"]=line[0]
		##store as nbases
	elif lnumber%3==2:
		grc_deliver[il]["path"]=line[0]
		#print grc_deliver[il]["path"]
		##store as path
	else:
		print "ERROR"
for line in map_f:
	line=line.rstrip().split("\t")
	il=line[0]
	S=line[1][1:]
	L=line[2][1:]
	grc_deliver[il]["S"]=S
	grc_deliver[il]["L"]=L
rename_files_os=open("/local/projects-t2/HRBV/Config/"+workorder+".renameMap",'w')
manifest_os=open("/local/projects-t2/HRBV/Config/"+workorder+".manifest",'w')
manifest_os.write("Pre_QC_ID\tR\n")
ils=grc_deliver.keys()
for il,value in sorted(grc_deliver.iteritems(), key=lambda (k,v): (v,k)):
	#print il,value
	name=grc_deliver[il]["name"].replace("_Small","")
	lane=grc_deliver[il]["L"]
	sample=grc_deliver[il]["S"]
	#print(name,il,sample,lane,grc_deliver[il]["path"])
	rename_files_ostring="%s\t"*5 % (name,il,sample,lane,grc_deliver[il]["path"]) +"\n"
	#print rename_files_ostring
	rename_files_os.write(rename_files_ostring)
	manifest_os.write(name+"\t"+READ_N+"\n")

