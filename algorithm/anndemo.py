import os,sys,math
import numpy as np

def sigmod(x):
    return 1/(1+math.exp(-x))

#f`(z) = f(z)(1-f(z))
def converseSigmod():
    pass

def tanh(x):
    return (math.exp(x)-math.exp(-x))/(math.exp(x)+math.exp(-x))

#f`(z) = 1-(f(z))^2
def converseTanh(x):
    pass

class Layer:
    def __init__(self,unit_num):
        self._unit_num = unit_num

    def Init(self,W,b,Func):
        self._W = W
        self._b = b
        self._Func = Func

    def dump(self):
        pass

class NeuralNet:
    def __init__(self,layer_unit_num_array,learn_rate=0.01, lambda_r = 0.01):

        self._learn_rate = learn_rate
        self._lambda = lambda_r
        self._layers = []
        self._layer_unit_num_array = layer_unit_num_array
        print 'Construct Human Neural Net with %d layers' % (len(layer_unit_num_array) - 1)
        print 'Initialize Random Weight and bias Matrix , also Active Function...'
        for i in range(1,len(self._layer_unit_num_array)):

            col = self._layer_unit_num_array[i-1]
            row = self._layer_unit_num_array[i]

            print 'Construct Layer %d' %(i-1)
            layer = Layer(row)

            w = np.matrix(np.random.random( (row,col) ))
            b = np.matrix(np.random.random( (row,1) ))

            # Construct activate function i.e. sigmod or tanh or ...
            # default sigmod
            active_func = []
            activate_func_num = row
            for i in range(0,activate_func_num):
                active_func.append(sigmod)

            layer.Init( w, b, active_func )
            self._layers.append( layer )

    def ForwardPropagation(self,Input):
        _output = None
        _input = Input

        for layer in self._layers:
            w = layer._W
            b = layer._b
            #print w
            #print b

            _output = w * _input.T + b
            _input = map(sigmod,_output)
            _input = np.matrix( _input )

        return _output

    def BackWardPropagation(self):
        pass

    def UpdateWeightMatrix(self):
        pass

    def train(self,train_data):
        print 'Begin Train NeuralNet...'

        # Get a sample like (x0,y0) or (feature,lable) as (Input, Output)
        for sample in train_data:
            _input = sample[0]
            _label = sample[1]

            #print 'Forward Propagation...'
            print self.ForwardPropagation(_input)
            #print 'Calculate residual error...'
            #print 'BackWard Propagation...'
            #print 'Wait for Util Convergese...'

    def train_iterator(self):
        pass

    def dumpLaers(self):
        for layer in self._layers:
            layer.dump()

    def test(self):
        pass

if __name__ == '__main__':
    input_unit_num = 64
    layer0_unit_num = 32
    layer1_unit_num = 32
    layer2_unit_num = 32
    layer3_unit_num = 16
    layer4_unit_num = 16
    layer5_unit_num = 16
    layer6_unit_num = 16
    layer7_unit_num = 16
    layer8_unit_num = 16
    layer9_unit_num = 16
    output_unit_num = 10

    layer_unit_num_array = []
    layer_unit_num_array.append( input_unit_num )
    layer_unit_num_array.append( layer0_unit_num )
    layer_unit_num_array.append( layer1_unit_num )
    layer_unit_num_array.append( layer2_unit_num )
    layer_unit_num_array.append( layer3_unit_num )
    layer_unit_num_array.append( layer4_unit_num )
    layer_unit_num_array.append( layer5_unit_num )
    layer_unit_num_array.append( layer6_unit_num )
    layer_unit_num_array.append( layer7_unit_num )
    layer_unit_num_array.append( layer8_unit_num )
    layer_unit_num_array.append( layer9_unit_num )
    layer_unit_num_array.append( output_unit_num )

    train_data = []

    Input = np.matrix(np.random.random( (1,input_unit_num) ))
    train_data.append([Input,[1,2,3,4,5]])

    dnn = NeuralNet( layer_unit_num_array )
    dnn.train(train_data)

