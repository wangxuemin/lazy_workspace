#coding:utf-8
import sys,os
import random
import urllib2
from PIL import Image,ImageDraw,ImageFilter,ImageEnhance
# 二值判断,如果确认是噪声,用改点的上面一个点的灰度进行替换
# 该函数也可以改成RGB判断的,具体看需求如何

def splitPic(hist,exn):
	beg=[]
	end=[]
	retbeg=[]
	retend=[]
	begin=True
	
	#	for i in range(len(hist)):
	#		print i,hist[i]
			
	for j in range( len(hist) ):
		if hist[j] <= 0 and begin:
			continue
		else:
			if begin == True:
				beg.append(j-1)
			begin=False
			
		if hist[j] <= 0 and not begin:
			end.append(j)
			begin=True

		#if len(beg) > exn:
		#	
		#	intval= len(hist) / exn
		#	beg=[]
		#	end=[]
		#	for k in range(0,exn):
		#		beg=beg+[k*intval]
		#		end=end+[k*intval+intval]
		#	
		#	return (beg,end)
	
	j=0
	maxlen=0
	# 去噪
	length=len(beg)
	if len(beg)>len(end):
		end.append(len(hist)-1)
		
	while j < length:
		if end[j]-beg[j] < 7:
			del beg[j]
			del end[j]
			length-=1
			continue
		j+=1
	
	idxs=[]
	#print "BEG",beg
	#print "END",end
	#print "EXN",exn
	if len(beg) > exn:
		
		intval= len(hist) / exn
		beg=[]
		end=[]
		for k in range(0,exn):
			beg=beg+[k*intval]
			end=end+[k*intval+intval]
		
		return (beg,end)
		
	if len(beg) < exn:
		
		# 查找分割项
		for j in range(len(beg)):
			if end[j] - beg[j] > 15:
				idxs.append(j)
				
		#print "IDXS",idxs
		# 分割
		#tmphist=[v for v in hist[beg[idx]:end[idx]+1]]
		#tmpbeg,tmpend=splitPic(tmphist,exn-len(beg)+1,False)
		for idx in idxs:
			
			loop=0
			while True:
				loop=loop+1
				
				tmphist=[v-loop for v in hist[beg[idx]:end[idx]+1]]
				#print "TMPLIST",tmphist
				if len(idxs)==2:
					expn= 2
				else:
					expn=exn-len(beg)+1
					
				tmpbeg,tmpend=splitPic(tmphist,expn)

				if len(tmpbeg) < expn and len(tmpbeg) !=0 and len(tmpend) !=0 :
					continue
				else:
					break
			
			tmpbeg=[ v+beg[idx] for v in tmpbeg ]
			tmpend=[ v+beg[idx] for v in tmpend ]
		
			#print tmpbeg
			#print tmpend
			retbeg=retbeg+tmpbeg
			retend=retend+tmpend
			
		if len( idxs ) == 2 :
			beg=retbeg
			end=retend
		elif len( idxs ) == 1 :
			beg=beg[0:idxs[0]]+tmpbeg+beg[idxs[0]+1:exn-1]
			end=end[0:idxs[0]]+tmpend+end[idxs[0]+1:exn-1]

		# 根据不同的分割策略，选择不同的返回 拼接方式
		# 1. 3:1 1:3 分割
		#beg=beg[0:idx]+retbeg+beg[idx+1:exn-1]
		#end=end[0:idx]+retend+end[idx+1:exn-1]
		
		# 2. 2：2 分割
		# 	retbeg=retbeg+tmpbeg
		#	retend=retend+tmpend
		
	return (beg,end)
	
for file in os.listdir("."):
	if len(file) != 8:
		continue
	
	if file == '9847.jpg':
		continue
	#randnum = random.random()
	#URL="http://www.zz96269.com/membercode.aspx?%.17f" %randnum
	#print URL
	#img = urllib2.urlopen( URL ).read()
	
	#srandnum='%.11f'%randnum
	#srandnum=srandnum[2:]
	#img_file = open( '%s.jpg'%srandnum, 'wb')
	#img_file.write(img)
	#img_file.close()	
	
	#img=Image.open('%s.jpg'%srandnum)
	#file='0120.jpg'
	file='37436927562.jpg'
	#print file
	code=file.split(".")
	code=code[0]
	img=Image.open(file)
	
	#img=Image.open('82620560163.jpg')
	img = img.convert("L")
	img = img.filter(ImageFilter.MedianFilter)
	#enhancer = ImageEnhance.Contrast(img)
	###for i in range(1):
	#factor = 2 / 4.0
	#enhancer.enhance(factor)
	#img = img.filter(ImageFilter.MinFilter())
	#img = img.filter(ImageFilter.EDGE_ENHANCE)
	#hist=img.histogram()
    
	#for i in range( len(hist) ):
	#	print i,hist[i]
	#img.show()
	#
	#img = img.convert("RGB")
	
	#img = img.filter(ImageFilter.FIND_EDGES)
	#img.resize((136,51))
	#img = img.filter(ImageFilter.EDGE_ENHANCE_MORE)
	
	data=img.load()
	
	# 二值化
	col=[0 for i in range(60)]
	for y in xrange( img.size[1]):
		for x in xrange(img.size[0]):
			if (data[x,y] < 150 ):
				data[x,y]=0
			else:
				data[x,y]=255
				col[x]+=1
	
	#img.show()
	beg,end=splitPic(col,4)
	#print "$$$$$BEG",beg
	#print "$$$$$END",end
	
	for j in range(len(beg)):
		
		str=""
		tmpimg=img.crop((beg[j], 0,end[j], 20)).resize((6,8))
		tmpdata=tmpimg.load()
		k=1
		for y in xrange( tmpimg.size[1]):
			for x in xrange(tmpimg.size[0]):
				if tmpdata[x,y] > 128 :
					tmp="%d:1 " %k
				else:
					tmp="%d:0 " %k
					
				str=str+tmp
				k=k+1
				
		print code[j:j+1],str
		#img.crop((beg[j], 0,end[j], 20)).resize((6,8)).show()
		#img.crop((beg[j], 0,end[j], 20)).show()
		
	break
	#img.show()
