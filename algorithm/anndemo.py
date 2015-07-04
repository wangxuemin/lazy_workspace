#encoding: utf-8

import os,sys,math
import copy
import numpy as np

def sigmod(x):
    return 1/(1+math.exp(-x))

#f`(z) = f(z)(1-f(z))
def converseSigmod(z):
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
    def __init__(self,W,b,Func,_id):
        self._W = copy.deepcopy( W )
        self._b = copy.deepcopy( b )
        self._Func = Func

        self._delta_W = np.zeros(W.shape)
        self._delta_b = np.zeros(b.shape)
        self._a = np.zeros(b.shape)

        self._id = _id

    def dump(self):
        print self._W
        print "---------------"
        print self._b
        print '---------------'
        print self._delta_W
        print "---------------"
        print self._delta_b

class NeuralNet:
    def __init__(self,layer_unit_num_array, learn_rate=0.01, lambda_r = 0.005,
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

            w = ( np.matrix(np.random.random( (row,col) )) - 0.5 ) *2
            b = ( np.matrix(np.random.random( (row,1) )) - 0.5 ) *2

            # Construct activate function i.e. sigmod or tanh or ...

            print 'Construct Layer %d' %(i)
            layer = Layer(w, b, sigmod , i)
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
            _input = map(sigmod,_output)
            _input = np.matrix( _input ).T

            # 保留中间层 输出, BP 计算导数使用
            layer._a = _input

        if debug:
            print _input

        return _input

    def BackWardPropagation(self, _input, error):

        # 计算输出层 残差
        _output_layer = self._output_layer
        _output_error = - np.multiply( error , np.multiply( _output_layer._a , 1 - _output_layer._a) )

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

            back_error = np.multiply( w.T * _output_error, np.multiply( prev_layer._a , 1 - prev_layer._a) )
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
                prev_in = _input
                prev_out = _output

                #print 'Calculate residual error...'
                error = diff_output_target( _output, np.matrix(_target).T )
                #print "output: %f"%_output.T
                #print "target: %f"%_target
                #print "error: %f"%error.T
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

                print 'layer'
                print layer._delta_W
                print '------------'
                print layer._delta_b

                layer._delta_W = np.zeros(layer._W.shape)
                layer._delta_b = np.zeros(layer._b.shape)
            #self.dumpLayers()

            #print 'Wait for Util Convergese...'

    def predict(self,_input):
        #return self.ForwardPropagation(_input,True)
        return self.ForwardPropagation(_input)

    def dumpLayers(self):
        for layer in self._layers:
            print 'layer %d' %(layer._id)
            layer.dump()

    def test(self):
        pass

if __name__ == '__main__':
    input_unit_num = 1
    hidden_layer0_unit_num = 20
    hidden_layer1_unit_num = 2
    hidden_layer2_unit_num = 32
    hidden_layer3_unit_num = 16
    hidden_layer4_unit_num = 16
    hidden_layer5_unit_num = 16
    hidden_layer6_unit_num = 16
    hidden_layer7_unit_num = 16
    hidden_layer8_unit_num = 16
    hidden_layer9_unit_num = 16
    output_unit_num = 1

    layer_unit_num_array = []
    layer_unit_num_array.append( input_unit_num )
    layer_unit_num_array.append( hidden_layer0_unit_num )
    #layer_unit_num_array.append( hidden_layer1_unit_num )
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
    for i in range(0,600):
        Input = np.matrix(np.random.random( (1,input_unit_num) ))
        train_data.append([Input,math.pow(Input,2)])

    #def __init__(self,layer_unit_num_array, learn_rate=0.01, lambda_r = 0.005,
    #        max_iteration = 5000,  allow_error = 0.0005):
    dnn = NeuralNet( layer_unit_num_array ,
            learn_rate=0.1, lambda_r = 0.05, max_iteration = 10, allow_error = 0.01)
    dnn.train(train_data)
    #dnn.dumpLayers()

    x = []
    y = []
    r = []

    test_data = []
    for i in range(0,200):
        Input = np.matrix(np.random.random( (1,input_unit_num) )) 

        x.append( Input.item() )
        y.append( dnn.predict(Input).item() )
        r.append( math.pow(Input.item(),2)  )

    #dnn.dumpLayers()

    import matplotlib.pyplot as plt

    plt.plot(x, y, 'ro' )
    #plt.plot(x, r, 'go' )
    plt.show()

