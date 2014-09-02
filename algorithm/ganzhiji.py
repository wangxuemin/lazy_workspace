#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  未命名.py
#  
#  Copyright 2013 t-dofan <t-dofan@T-DOFAN-PC>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#  

class Perceptron:
    #初始化
    def __init__(self,learnrate,w0,w1,b):
	self.learnrate = learnrate
	self.w0 = w0
	self.w1 = w1
	self.b = b

    #模型
    def model(self,x):
	result = x[2]*(self.w0*x[0] + self.w1*x[1] + self.b)
	return result

    #策略
    def iserror(self,x):
	result = self.model(x)
	if result <= 0:
	    return True
	else:
	    return False

    ##算法 ---> 这里的learnrate 代表。。。。。。。。。。。
    #调整策略： Wi = Wi + n*wixi
    def gradientdescent(self,x):
	self.w0 = self.w0 + self.learnrate * x[2] * x[0] #根据调整策略，此处是否需要*x[2] ? 
	self.w1 = self.w1 + self.learnrate * x[2] * x[1]
	self.b = self.b + self.learnrate * x[2]
	print self.w0,self.w1,self.b


    #训练
    def traindata(self,data):
	times = 0
	done = False
	while not done:
	    for i in range(0,6):
		if self.iserror(data[i]):
		    self.gradientdescent(data[i])
		    times += 1
		    done = False
		    break
		else:
		    done = True    
	print times
	print "rightParams:w0:%d,w1:%d,b:%d" %(self.w0 , self.w1 , self.b)

    def testmodel(self,x):
	result  = self.w0*x[0] + self.w1*x[1] + self.b
	if result > 0:
	    return 1
	else:
	    return -1

def main():
    p = Perceptron(1,0,0,0)
    data = [[3,3,1],[4,3,1],[1,1,-1],[2,2,-1],[5,4,1],[1,3,-1]] 
    testdata = [[4,4,-1],[1,2,-1],[1,4,-1],[3,2,-1],[5,5,1],[5,1,1],[5,2,1]]
    p.traindata(data)
    for i in testdata:
	print "%d  %d  %d" %(i[0],i[1],p.testmodel(i))
    return 0

if __name__ == '__main__':
    main()
