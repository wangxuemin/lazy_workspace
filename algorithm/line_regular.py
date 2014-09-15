import os,sys,time,math

import numpy as np
import copy

#A=[[1,1],[-1,2]]
#A1=[[6,1],[8,2]]
#A2=[[1,6],[-1,8]]
#
#C=[6,8]
#AA=np.array([[1,1],[-1,2]])
#
#print AA,C
#print np.linalg.det(AA)
#
#A1=copy.copy(AA)
#A1[:,0]=C
#print A1
#print np.linalg.det(A1)
#
#A2=copy.copy(AA)
#A2[:,1]=C
#print A2
#print np.linalg.det(A2)
#
#x = np.linalg.solve(AA,C)
#
#print x
#
#x=np.random.random(1024)
#print x
#print np.fft.fft(x)
C=np.array([[1,0,0,0,2],[0,0,3,0,0],[0,0,0,0,0],[0,4,0,0,0]])
CCT=np.dot(C,C.T)
print CCT
CTC=np.dot(C.T,C)
print CTC

print np.linalg.eig(CCT)
print np.linalg.eig(CTC)

U=np.array([[0,0,1,0],[0,1,0,0],[0,0,0,1],[1,0,0,0]])
Vt=np.array([
[0,1,0,0,0],
[0,0,1,0,0],
[math.sqrt(0.2),0,0,0,math.sqrt(0.8)],
[0,0,0,1,0],
[math.sqrt(0.8),0,0,0,-math.sqrt(0.2)]
])

E=np.array([
[4,0,0,0,0],
[0,3,0,0,0],
[0,0,math.sqrt(5),0,0],
[0,0,0,0,0]
]
)
print np.dot(np.dot(U,E),Vt)
