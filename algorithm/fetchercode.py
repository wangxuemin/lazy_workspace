#coding:utf-8
import sys,os
import random
import urllib2
from PIL import Image,ImageDraw,ImageFilter,ImageEnhance
# 二值判断,如果确认是噪声,用改点的上面一个点的灰度进行替换
# 该函数也可以改成RGB判断的,具体看需求如何

def splitPic(hist,exn,root=True):
	#print hist,exn,root
	beg=[]
	end=[]
	begin=True
	
	if not root:
		hist=[v-1 for v in hist]
	else:
		for i in range(len(hist)):
			print i,hist[i]
			
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

	j=0
	maxlen=0
	# 去噪
	length=len(beg)
	if len(beg)>len(end):
		end.append(len(hist)-1)
		
	while j < length:
		#print beg,end

		if end[j]-beg[j] < 5:
			del beg[j]
			del end[j]
			length-=1
			continue
		j+=1
		
	if len(beg) < exn:
		
		# 查找分割项
		for j in range(len(beg)):
			if end[j]-beg[j] > maxlen:
				maxlen = end[j]-beg[j]
				idx=j;
		#print idx,maxlen
		
		# 分割
		tmphist=[v for v in hist[beg[idx]:end[idx]+1]]
		tmpbeg,tmpend=splitPic(tmphist,exn-len(beg)+1,False)
		
		loop=0
		while True:
			loop=loop+1
			if len(tmpbeg) < exn-len(beg)+1:
				tmphist=[v-loop for v in hist[beg[idx]:end[idx]+1]]
				tmpbeg,tmpend=splitPic(tmphist,exn-len(beg)+1,False)
			else:
				break
			
		tmpbeg=[v+beg[idx] for v in tmpbeg ]
		tmpend=[v+beg[idx] for v in tmpend ]
		
		#print tmphist
		print "hist",tmphist
		print exn-len(beg)+1,tmpbeg,tmpend
		beg=beg[0:idx]+tmpbeg+beg[idx+1:exn-1]
		end=beg[0:idx]+tmpend+end[idx+1:exn-1]
		
	return (beg,end)

for i in range(0,1):
	randnum = random.random()
	URL="http://www.zz96269.com/membercode.aspx?%.17f" %randnum
	print URL
	img = urllib2.urlopen( URL ).read()
	
	srandnum='%.11f'%randnum
	srandnum=srandnum[2:]
	img_file = open( '%s.jpg'%srandnum, 'wb')
	img_file.write(img)
	img_file.close()	
	
	#img=Image.open('%s.jpg'%srandnum)
	img=Image.open('27058834214.jpg')
	#img=Image.open('76747074925.jpg')
	
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

	#						
	#		if (data[x,y][2] > 128):
	#			data[x,y]=(255,255,255,255)
	#			
	#		if (data[x,y][1] < 128 ):
	#			data[x,y]=(0,0,0,255)
	#		
	#img.show()
	
	#for j in range( len(col) ):
	#	#print j,col[j]
	#	if col[j] == 0 and begin:
	#		continue
	#	else:
	#		if begin == True:
	#			beg.append(j-1)
	#		begin=False
	#		
	#	if col[j] == 0 and not begin:
	#		end.append(j)
	#		begin=True
    #
	#	
	#	#elif col[j] == 0:
	#	#	print j
	
	beg,end=splitPic(col,4)
	print beg
	print end
	
	# 递归 分割函数 splitPic(img，beg，end，exn)
	# 分割主流程
	# if exn < actureExn:
	#	splitPic(img，beg，end，exn)
	
	# 直到获取到4个数字，停止递归，返回 分割结果
	
	#for j in range(len(beg)):
	#	img.crop((beg[j], 0,end[j], 20)).show()

	#print img
	#hist=img.histogram()
    #
	#for i in range( len(hist) ):
	#	print i,hist[i]
	#img.resize((136,51))

	#img.show()
	
	
	