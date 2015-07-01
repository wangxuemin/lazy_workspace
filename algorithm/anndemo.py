import os,sys,math
import copy
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

def diff_output_target(output,target):
    _output = np.matrix(output)
    _target = np.matrix(target)

    return _target - _output

class Layer:
    def __init__(self,unit_num):
        self._unit_num = unit_num

    def Init(self,W,b,Func):
        self._W = copy.deepcopy( W )
        self._b = copy.deepcopy( b )
        self._Func = Func

        self._delta_W = copy.deepcopy( W )
        self._delta_b = copy.deepcopy( b )

    def dump(self):
        pass

class NeuralNet:
    def __init__(self,layer_unit_num_array,learn_rate=0.01, lambda_r = 0.01):

        self._learn_rate = learn_rate
        self._lambda = lambda_r
        self._layers = []
        self._layer_unit_num_array = layer_unit_num_array
        self._parameter_num = 0

        print 'Construct Human Neural Net with %d layers' % (len(layer_unit_num_array) - 1)
        print 'Initialize Random Weight and bias Matrix , also Active Function...'
        for i in range(1,len(self._layer_unit_num_array)):

            col = self._layer_unit_num_array[i-1]
            row = self._layer_unit_num_array[i]

            self._parameter_num += row * col

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

        print 'parameter_num is %d' %self._parameter_num

    def ForwardPropagation(self,Input):
        _output = None
        _input = Input

        for layer in self._layers:
            w = layer._W
            b = layer._b

            _output = w * _input.T + b
            _input = map(sigmod,_output)
            _input = np.matrix( _input )

        return _output

    def BackWardPropagation(self, error):

        _output_idx = len(self._layers) - 1
        _output_layer = self._layers[_output_idx]
        _output_error = error - _output_layer._b
        _back_input = _output_layer._W.T * _output_error

        for i in range(_output_idx - 1, 0, -1):
            layer = self._layers[i]
            w = layer._W
            b = layer._b

            _delta_w = layer._delta_W
            _delta_b = layer._delta_b

            _output_error = w.T * _back_input - b
            _back_input = _output_error

    def UpdateWeightMatrix(self):
        pass

    def train(self,train_data):
        print 'Begin Train NeuralNet...'

        # Get a sample like (x0,y0) or (feature,lable) as (Input, Output)
        for sample in train_data:
            _input = sample[0]
            _target = sample[1]

            #print 'Forward Propagation...'
            _output = self.ForwardPropagation(_input)

            #print 'Calculate residual error...'
            error = diff_output_target( _output, np.matrix(_target).T )

            #print 'BackWard Propagation...'
            self.BackWardPropagation( error )

            #print 'Wait for Util Convergese...'

    def train_iterator(self):
        pass

    def dumpLaers(self):
        for layer in self._layers:
            layer.dump()

    def test(self):
        pass

if __name__ == '__main__':
    input_unit_num = 4
    hidden_layer0_unit_num = 32
    hidden_layer1_unit_num = 32
    hidden_layer2_unit_num = 32
    hidden_layer3_unit_num = 16
    hidden_layer4_unit_num = 16
    hidden_layer5_unit_num = 16
    hidden_layer6_unit_num = 16
    hidden_layer7_unit_num = 16
    hidden_layer8_unit_num = 16
    hidden_layer9_unit_num = 16
    output_unit_num = 4

    layer_unit_num_array = []
    layer_unit_num_array.append( input_unit_num )
    layer_unit_num_array.append( hidden_layer0_unit_num )
    layer_unit_num_array.append( hidden_layer1_unit_num )
    #layer_unit_num_array.append( hidden_layer2_unit_num )
    #layer_unit_num_array.append( hidden_layer3_unit_num )
    #layer_unit_num_array.append( hidden_layer4_unit_num )
    #layer_unit_num_array.append( hidden_layer5_unit_num )
    #layer_unit_num_array.append( hidden_layer6_unit_num )
    #layer_unit_num_array.append( hidden_layer7_unit_num )
    #layer_unit_num_array.append( hidden_layer8_unit_num )
    #layer_unit_num_array.append( hidden_layer9_unit_num )
    layer_unit_num_array.append( output_unit_num )

    train_data = []

    for i in range(0,10):
        Input = np.matrix(np.random.random( (1,input_unit_num) ))
        train_data.append([Input,Input])

    dnn = NeuralNet( layer_unit_num_array )
    dnn.train(train_data)

