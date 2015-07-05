#encoding: utf-8

import os,sys
import copy,json

import math

import numpy as np
import matplotlib.pyplot as plt

def sigmod(x):
    return 1/(1+math.exp(-x))

#f`(z) = f(z)(1-f(z))
def inverse_sigmod(z):
    return np.multiply( z , 1-z )

def tanh(x):
    return (math.exp(x)-math.exp(-x))/(math.exp(x)+math.exp(-x))

#f`(z) = 1-(f(z))^2
def inverse_tanh(z):
    return 1 - np.multiply(z, z)

def liner(x):
    return x.item() * 1

def inverse_liner(z):
    return 1

def diff_output_target(output,target):
    _output = np.matrix(output)
    _target = np.matrix(target)

    return _target - _output

class Layer:
    def __init__(self,W,b,Func,_id):
        self._W = copy.deepcopy( W )
        self._b = copy.deepcopy( b )
        self._Func = Func
        self._inverse_func = eval("inverse_%s" %self._Func.__name__)

        self._delta_W = np.zeros(W.shape)
        self._delta_b = np.zeros(b.shape)
        self._a = np.zeros(b.shape)

        self._id = _id

    def dump(self):
        print self._W
        print "---------------"
        print self._b

class NeuralNet:
    def __init__(self,layer_unit_num_array, func_list, learn_rate=0.01, lambda_r = 0.005,
            max_iteration = 5000,  allow_error = 0.0005):

        self._learn_rate = learn_rate
        self._lambda = lambda_r
        self._layers = []
        self._layer_unit_num_array = layer_unit_num_array
        self._parameter_num = 0

        self._max_iteration = max_iteration
        self._allow_error = allow_error

        print 'Construct Human Neural Net with %d layers' % (len(layer_unit_num_array) - 1)
        print 'Initialize Random Weight and bias Matrix , also Active Function...'
        # 跳过输入层
        for i in range(1,len(self._layer_unit_num_array)):

            col = self._layer_unit_num_array[i-1]
            row = self._layer_unit_num_array[i]

            self._parameter_num += row * col + row

            # 随机初始化权值
            w = np.matrix(np.random.random( (row,col) )) - 0.5
            b = np.matrix(np.random.random( (row,1) )) - 0.5

            # Construct activate function i.e. sigmod or tanh or ...

            print 'Construct Layer %d' %(i)
            #if i == 1:
            #    layer = Layer(w, b, sigmod , i)
            #else:
            #    layer = Layer(w, b, liner , i)
            layer = Layer(w, b, func_list[i] , i)

            self._layers.append( layer )

        self._output_layer = self._layers[-1]
        print 'parameter_num is %d' %self._parameter_num

    def ForwardPropagation(self,Input,debug=False):

        _input = Input.T

        for layer in self._layers:

            w = layer._W
            b = layer._b

            if debug:
                print w
                print b
                print _input

            _output = w * _input + b
            #_input = map(sigmod ,_output)
            #print _input
            _input = map( layer._Func ,_output)
            _input = np.matrix( _input ).T

            # 保留中间层 输出, BP 计算导数使用
            layer._a = _input

        if debug:
            print _input

        return _input

    def BackWardPropagation(self, _input, error):

        # 计算输出层 残差
        _output_layer = self._output_layer
        Inverse_Func = _output_layer._inverse_func
        _output_error = - np.multiply( error , Inverse_Func( _output_layer._a ) )

        # 计算隐含层 残差
        _output_idx = len(self._layers) - 1
        for i in range(_output_idx , 0, -1):
            #print 'update hidden_layer%d' %i
            layer = self._layers[i]
            prev_layer = self._layers[i-1]

            w = layer._W
            b = layer._b

            delta_W = _output_error * prev_layer._a.T
            delta_b = _output_error

            layer._delta_W += delta_W
            layer._delta_b += delta_b

            Inverse_Func = prev_layer._inverse_func
            back_error = np.multiply( w.T * _output_error, Inverse_Func( prev_layer._a ) )
            _output_error = back_error

        # 更新第一隐层权值
        #print 'update hidden_layer0'
        hidden_layer0 = self._layers[0]
        delta_W = _output_error * _input.T
        delta_b = _output_error

        hidden_layer0._delta_W += delta_W
        hidden_layer0._delta_b += delta_b

    def train(self,train_data):
        print 'Begin Train NeuralNet...'
        m = len(train_data)
        max_iteration = self._max_iteration

        for i in range(0,max_iteration):
            sum_error = 0
            # Get a sample like (x0,y0) or (feature,lable) as (Input, Output)
            for sample in train_data:
                _input = sample[0]
                _target = sample[1]

                #print 'Forward Propagation...'
                _output = self.ForwardPropagation(_input)

                #print 'Calculate residual error...'
                error =  np.matrix(_target).T - _output
                sum_error += error.T * error

                #print 'BackWard Propagation...'
                self.BackWardPropagation( _input, error )

            error = math.sqrt(sum_error/m)
            print 'Interation %d, average error %f' %(i, error)
            if error < self._allow_error :
                # stop train loop
                break

            # Update Weight and bias Matrix
            for layer in self._layers:
                layer._W -= self._learn_rate * ( layer._delta_W / m + self._lambda * layer._W )
                layer._b -= self._learn_rate * ( layer._delta_b / m )

                #print 'layer %d' %layer._id
                #print layer._delta_W
                #print '------------'
                #print layer._delta_b

                layer._delta_W = np.zeros(layer._W.shape)
                layer._delta_b = np.zeros(layer._b.shape)

            if i+1 % 80000 == 0:
                self.plot()
            #self.dumpLayers()

            #print 'Wait for Util Convergese...'

    def predict(self,_input):
        #return self.ForwardPropagation(_input,True)
        return self.ForwardPropagation(_input)

    def dumpLayers(self):
        for layer in self._layers:
            print 'layer %d' %(layer._id)
            layer.dump()

    def plot(self):
        x = []
        y = []
        r = []

        for i in range(0,210):
            Input = np.matrix(np.random.random( (1,input_unit_num) )) 

            x.append( Input.item() )
            y.append( self.predict(Input).item() )
            r.append( math.pow(Input.item(),2)  )

        plt.plot(x, y, 'ro' )
        plt.plot(x, r, 'go' )
        plt.show()

if __name__ == '__main__':

    nnconfigfile = '%s.json' %(sys.argv[0][:-3])
    for i in range(1,len(sys.argv)):
        if sys.argv[i] == '-conf':
            nnconfigfile = sys.argv[i+1]

    func_list = []
    layer_unit_num_array = []

    print 'Construct NeuralNet by %s' %nnconfigfile
    NNConfig = json.load(file( nnconfigfile ))

    for layer_config in NNConfig:
        layer_unit_num_array.append( layer_config['unit_num'] )
        func_list.append( eval(layer_config['func']) )
    input_unit_num = layer_unit_num_array[0]

    train_data = []
    for i in range(0,10):
        Input = np.matrix(np.random.random( (1,input_unit_num) ))
        train_data.append([Input,math.pow(Input,2)])

    dnn = NeuralNet( layer_unit_num_array , func_list,
            learn_rate=0.9, lambda_r = 0, max_iteration = 3000, allow_error = 0.01)
    dnn.train(train_data)

    dnn.plot()

