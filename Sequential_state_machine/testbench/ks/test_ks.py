import binascii
from datetime import datetime
import gmpy2
import time
import random
import array
import copy
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, ReadOnly
from cocotb.result import TestFailure, ReturnValue
from cocotb.binary import BinaryValue
import numpy as np


import binascii
import numpy as np
import gmpy2
import random
import array
import copy
import hashlib
import binascii
import numpy as np
import gmpy2
import random
import array
import copy
import hashlib
#import gmpy
np.set_printoptions(formatter={'int':lambda x:hex(int(x))})



class Binfield:
    def __init__(self, Polynomial):        
        Polynomial =  self.str2nparray(Polynomial)
        self.Polynomial = Polynomial
        #print self.Polynomial
        self.make_mul_lut()
        self.make_sqr_lut()
        self.gen_mod_table()
        
    def str2nparray(self, A):
        A = '0'*(8 - len(A)%8) + A
        A = binascii.unhexlify(A)
        A = np.fromstring(A[::-1], dtype='uint32') 
        return A

    def nparray2str(self, A):
        c = ''
        d = A.view('uint8')
        for i in d[::-1]:
           
            c+=binascii.hexlify(i)
        return c 
    
    def nparray2str2(self, A):
        c = ''
        d = A.view('uint8')
        for i in d:
    
            c+=binascii.hexlify(i)
        return c  
        
    def mul_2 (self,a, b):
        a1 = (a&2)>>1
        a0 = (a&1)
        b1 = (b&2)>>1
        b0 = (b&1)

        d2 = (a1 & b1)&1
        d0 = (a0 & b0)&1
        d1 = (((a1 ^ a0) & (b1 ^ b0)) ^ d0 ^ d2 )&1
        return d2<<2 ^ d1 <<1 ^ d0
    
    def mul_2 (self,a, b):
        a1 = (a&2)>>1
        a0 = (a&1)
        b1 = (b&2)>>1
        b0 = (b&1)

        d2 = (a1 & b1)&1
        d0 = (a0 & b0)&1
        d1 = (((a1 ^ a0) & (b1 ^ b0)) ^ d0 ^ d2 )&1
        return d2<<2 ^ d1 <<1 ^ d0
    
    def test_mul_2 (self):
        for i in range(4):
            for j in range(4):
                print bin(self.mul_2(i, j))
        return 0
    
    def mul_4 (self,a, b):
        a1 = (a&0xC)>>2
        a0 = (a&0x3)
        b1 = (b&0xc)>>2
        b0 = (b&0x3)

        d2 = self.mul_2(a1, b1)
        d0 = self.mul_2(a0, b0)
        d1 = self.mul_2((a1 ^ a0), (b1 ^ b0)) ^ d0 ^ d2
        
        return d2<<4 ^ d1 <<2 ^ d0
    
    def make_mul_lut(self):
        MUL_LUT = []
        for i in range(0,256):
            b = self.mul_4((i&0xf0)>>4,i&0x0f)
            MUL_LUT.append(b)
        self.MUL_LUT = np.array(MUL_LUT)
        return 0
        
    def mul_8 (self,a, b):
        a1 = (a&0xf0)>>4
        a0 = (a&0xf)
        b1 = (b&0xf0)>>4
        b0 = (b&0xf)

        d2 = self.mul_4(a1, b1)
        d0 = self.mul_4(a0, b0)
        d1 = self.mul_4((a1 ^ a0), (b1 ^ b0)) ^ d0 ^ d2
 
        return d2<<8 ^ d1 <<4 ^ d0
    
    
    def mul_8_lut (self,a, b):
        a1 = (a&0xf0)>>4
        a0 = (a&0xf)
        b1 = (b&0xf0)>>4
        b0 = (b&0xf)

        d2 = self.MUL_LUT[a1<<4 | b1]
        d0 = self.MUL_LUT[a0<<4 | b0]
        d1 = self.MUL_LUT[(a1 ^ a0)<<4 | (b1 ^ b0)] ^ d0 ^ d2
        return int(d2<<8 ^ d1 <<4 ^ d0)
    
    def mul_32 (self, a, b):
        a3 = (a&0xff000000)>>24
        a2 = (a&0xff0000)>>16
        a1 = (a&0xff00)>>8
        a0 = (a&0xff)
        b3 = (b&0xff000000)>>24
        b2 = (b&0xff0000)>>16
        b1 = (b&0xff00)>>8
        b0 = (b&0xff)
        
        d3 = self.mul_8_lut(a3, b3)
        d2 = self.mul_8_lut(a2, b2)
        d1 = self.mul_8_lut(a1, b1)
        d0 = self.mul_8_lut(a0, b0)
        
        f1 = d3 ^ d2
        f0 = d1 ^ d0
        f  = f1 ^ f0
        
        c6 = d3
        c5 = self.mul_8_lut(a3 ^ a2, b3 ^ b2) ^ f1
        c4 = self.mul_8_lut(a3 ^ a1, b3 ^ b1) ^ f1 ^ d1
        c2 = self.mul_8_lut(a2 ^ a0, b2 ^ b0) ^ f0 ^ d2
        c1 = self.mul_8_lut(a1 ^ a0, b1 ^ b0) ^ f0
        c0 = d0        
        c3 = self.mul_8_lut(a3 ^ a2 ^ a1 ^ a0 , b3 ^ b2 ^ b1 ^  b0) ^ c1 ^ c2 ^ c0 ^ c4 ^ c5 ^ c6
        r = np.array([(c3&0xFF)<<24 ^ c2<<16 ^ c1<<8 ^ c0 , c6<<16 ^ c5<<8 ^ c4 ^ (c3&0xFF00) >>8])
      
        return r 
    
        
    def mul_64 (self, a, b):
        a1 = a[1]
        a0 = a[0]
        b1 = b[1]
        b0 = b[0]

        d2 = self.mul_32(a1, b1)
        d0 = self.mul_32(a0, b0)
        d1 = (self.mul_32((a1^a0), (b1^b0)) ^ d0 ^ d2)
                
        r = np.array([d0[0], d0[1] ^ d1[0], d1[1] ^ d2[0], d2[1]])
        return r
    
    
    def mul_128 (self, a, b):
        a1 = a[1]
        a0 = a[0]
        b1 = b[1]
        b0 = b[0]

        d2 = self.mul_64(a1, b1)
        d0 = self.mul_64(a0, b0)
        d1 = (self.mul_64((a1^a0), (b1^b0)) ^ d0 ^ d2)
                
        r = np.array([d0[0], d0[1] ^ d1[0], d1[1] ^ d2[0], d2[1]])
        return r.view('uint8')
    
  
    
    def make_sqr_lut(self):
        LUT = np.array([0x00, 0x01, 0x4, 0x05, 0x10, 0x11, 0x14, 
                        0x15, 0x40, 0x41, 0x44, 0x45, 0x50, 0x51, 0x54, 0x55])
        a = np.arange(256)
        b = [ LUT[a & 0x0F], LUT[(a & 0xF0)>> 4]]
        c = []
        for i in range(0,256):
            a = (b[1][i] << 8) | b[0][i] 
            c.append(a)
        self.LUT8 = np.array(c, dtype='uint16')        
        
        
    def square (self, A):
      
        b = A.view('uint8')
        c = self.LUT8[b]
        d = c.view('uint32')
        while (d[-1] == 0):
            if (len(d) == 1):
                break
            d = d[:-1]   
        return d
    
    def bin_sqr (self, A):
        A = self.str2nparray(A)
  
        return self.square(A)
    
    def bin_mul_64 (self, A, B):
        A = binascii.unhexlify(A)
        A = np.fromstring(A, dtype='uint32') 
        print A
        B = binascii.unhexlify(B)
        B = np.fromstring(B, dtype='uint32') 
        print B
        return self.mul_64(A, B)
    
            
    
    def gen_mod_table(self):
        index = 0
        p = self.Polynomial.view('uint8')
        p = p[::-1]
        while (p[0] == 0):
            if (len(p) == 1):
                break
            p = p[1:]
            
        f_bit_pos = gmpy2.bit_length(int(p[0])) 
        
        self.Polly_byte_len = len(p)
        self.Polly_bit_len = f_bit_pos
    
      
        p = np.array(p)
      
        
        p1 = p >> (f_bit_pos-1)
        p2 = p << (9 - f_bit_pos)
       

        p1 = np.append(p1, 0)
        p2 = np.append(0, p2)   
        pr = p1 ^ p2 & 0xff


        p1 = pr >> 1
        p2 = pr << 7
      
        p1 = np.append(p1, 0)
        p2 = np.append(0, p2)        
        pl = (p1 ^ p2) & 0xff
        pl = pl[1:]
        
        pl[0] = pl[0] & 0x7F
        self.pr = pr
        poly_7 = []
        p3 = np.append(0, pr[1:])
        poly_7.append(p3)
        
                
        for i in range(7):
            p1 = p3 << (1)
            p2 = p3 >> (7)
            p2 = np.append(p2[1:], 0)
            p3 = (p1 ^ p2) & 0xff
       
            if not p3[0] == 0:
                p3 = p3 ^ pr
            poly_7.append(p3)            
        
  
        index = []
        
        for i in range(len(poly_7[0])):
            for j in poly_7:
                if j[i] != 0:
                    index.append(i)
                    break  
       
            
        Polly_table = []
        for i in range(256):
            val = np.zeros(len(poly_7[0]),  dtype='uint8')
            for j in range(8):
                if ((i >> j) & 0x1):
                    val = val ^ poly_7[j]
            indexed_val = []
            for k in index:
                indexed_val.append(val[k])                
            Polly_table.append(np.array(indexed_val))
      
        self.Polly_table = Polly_table
        self.Polly_index = index
        return 0
 
    
    def bin_mod (self, A):
        A =  self.str2nparray(A)
        return self.modulus(A)
            
    def bin_mul(self, A, B):

        A =  self.str2nparray(A)
        B =  self.str2nparray(B)
        return self.multiplication(A ,B)      
        
    def multiplication(self, A, B):
        #print A,B

        l1 = len(A)
        l2 = len(B)
        l = max(l1, l2)
        size = 1
        l3 = l
        while l3 != 1:
            l3 = l3/2
            size *=2
        if l > size:
            size *=2
        A = np.append(A, np.zeros(size-l1, dtype=np.int32))
        B = np.append(B, np.zeros(size-l2, dtype=np.int32))
        C =self.mul_recr(A ,B)
        while(C[-1]==0):
            if len(C) == 1:
                break
            C = C[:-1]
        
        C = np.array(C, dtype='uint32')
        #print "Result@@@@"
        #print (C)
        return C
    
    def mul_recr(self,A, B):   
        l = len(A)        
        if(l==1):
            if A[0] == 0 | B[0] == 0:
                d = np.array([0, 0], dtype="uint32")
            
                return d
            else:
                d = self.mul_32(A , B)
            
                return d
        else:
            d0 = self.mul_recr(A[0:l/2],B[0:l/2])
            d2 = self.mul_recr(A[l/2:l],B[l/2:l])
            d1 = self.mul_recr((A[l/2:l] ^ A[0:l/2]), (B[l/2:l] ^ B[0:(l/2)])) ^ d0 ^ d2
            
            l = len(d1)/2
       
            
            d0 = np.append(d0, np.zeros(2*l, dtype=np.int32))
            d1 = np.append(np.zeros(l, dtype=np.int32), d1)
            d1 = np.append(d1, np.zeros(l, dtype=np.int32))
            d2 = np.append(np.zeros(2*l, dtype=np.int32), d2)
        
            d2 = d2^d1^d0
            return d2
    
    
    
    
    def remove_0(self, A):
        while A[0] == 0:
            if len(A) == 1:
                break
            A = A[1:]
        return A





        
        

class Fifo(object):

    def __init__(self, dut):
        self.dut=dut

    def str2nparray(self, A):
        A = '0'*(8 - len(A)%8) + A
        A = binascii.unhexlify(A)
        A = np.fromstring(A[::-1], dtype='uint32') 
        return A
    
    def nparray2str(self, A):
        c = ''
        d = A.view('uint8')
        for i in d:
            c+=binascii.hexlify(i)
        return c 
    
    
    
    @cocotb.coroutine
    def PUSH_Core2(self,dut, A,command):

        Ad = BinaryValue()
        Ad.assign(A)
        
        dut.Data_in_Core2_Inp.value = Ad
        #print "Verilog",Ad
        dut.wr_en_Core2_Inp.value=1
        dut.wr_en_Core2_Cmd.value  =1
        dut.Data_in_Core2_Cmd.value=command
        yield RisingEdge(self.dut.clk)
        
        dut.wr_en_Core2_Inp.value=0
        dut.wr_en_Core2_Cmd.value  =0
        
        yield ReadOnly()
        #raise ReturnValue(dut.d.value)
        
    
    
    @cocotb.coroutine
    def POP_A_Core2(self,dut):
        dut.rd_en_Core2_Output.value=1
        yield RisingEdge(self.dut.clk)
        yield ReadOnly()
        raise ReturnValue(dut.Data_Out_Core2_Output.value)
    
    
    
    @cocotb.coroutine
    def PUSH(self,dut, A,command):

        Ad = BinaryValue()
        Ad.assign(A)
    
        dut.Data_in_Core1_Inp.value = Ad
        dut.wr_en_Core1_Inp.value=1
    
        dut.wr_en_Core1_Cmd.value  =1
        dut.Data_in_Core1_Cmd.value=command
        yield RisingEdge(self.dut.clk)
       
        dut.wr_en_Core1_Inp.value=0
        dut.wr_en_Core1_Cmd.value  =0
        
        yield ReadOnly()
        #raise ReturnValue(dut.d.value)
        
    
    
    @cocotb.coroutine
    def POP_A(self,dut):
      
        
        dut.rd_en_Core1_Output.value=1
      
        yield RisingEdge(self.dut.clk)
        yield ReadOnly()
        raise ReturnValue(dut.Data_Out_Core1_Output.value)
        

    @cocotb.coroutine
    def wait(self,dut):
        yield RisingEdge(self.dut.clk)
     
        yield ReadOnly()

   
@cocotb.test()
def test_ks(dut):
    tb=Fifo(dut)
    field=Binfield('100000000000000000000000000000001')
    count=0
    count1=0
    input_data=8
    Data={}
    Sqr_array={}
    Mul_array={}
    dut.rd_en_Core1_Output.value=0
    dut.rd_en_Core2_Output.value=0
    cocotb.fork(Clock(dut.clk, 10).start())
    A = np.ndarray(shape=(input_data,32),buffer= np.fromstring(np.random.bytes(256), dtype=np.uint8), dtype=np.uint8)

    
    B = np.ndarray(shape=(input_data,32),buffer= np.fromstring(np.random.bytes(256), dtype=np.uint8), dtype=np.uint8)
    command=1
    print "#######First test of Core2############################################################################### "
    yield tb.wait(dut)
    
    for i,j in zip(A,B):
        
        j=np.concatenate((i,j))
        C = yield tb.PUSH_Core2(dut, i.tostring()[::-1],command)
        #p=np.split(i,2)
        #print "Data"
        #print p[0]
        #print p[1]
        #D= field.mul_128(p[0],p[1])
        #print "Python"
        #print i
        #print D
   
        #Mul_array[count]=D.view('uint8')
        #count=count+1
    
    for i in range(0,input_data):
     
        D=yield tb.POP_A_Core2(dut)
        
        D = np.fromstring(D.buff[::-1], dtype=np.uint8)
        #if(np.array_equal(D,Mul_array[i])):
         #   print "Test Passed"
        print "Final_Res@@@@@@@@"
        print D
        #print Mul_array[i]
        #else:
         #   print "Test Failed"
    yield RisingEdge(dut.clk)
    dut.rd_en_Core2_Output.value=0
            
    A = np.ndarray(shape=(input_data,32),buffer= np.fromstring(np.random.bytes(256), dtype=np.uint8), dtype=np.uint8)
    
    B = np.ndarray(shape=(input_data,32),buffer= np.fromstring(np.random.bytes(256), dtype=np.uint8), dtype=np.uint8)
    command=1
    print "############################ First_test for Core1#############################"        
    for i,j in zip(A,B):
        j=np.concatenate((i,j))
        C = yield tb.PUSH(dut, i.tostring()[::-1],command)
        D= field.square(i)
   
        Sqr_array[count1]=D.view('uint8')
        count1=count1+1
    
    for i in range(0,input_data):
        
        D=yield tb.POP_A(dut)
        D = np.fromstring(D.buff[::-1], dtype=np.uint8)
        
        #if(np.array_equal(D,Sqr_array[i])):
        print "Test Passed"
        print D
        print Sqr_array[i]
            
        #else:
        #   print "Test Failed"
    yield RisingEdge(dut.clk)
    dut.rd_en_Core1_Output.value=0
            
            
            
    A = np.ndarray(shape=(input_data,32),buffer= np.fromstring(np.random.bytes(256), dtype=np.uint8), dtype=np.uint8)
    
    B = np.ndarray(shape=(input_data,32),buffer= np.fromstring(np.random.bytes(256), dtype=np.uint8), dtype=np.uint8)
    command=1
    count=0
    
    print "####################Second test of Core2 ################################# "
    #yield tb.wait(dut)
    for i,j in zip(A,B):
        i=np.concatenate((i,j))
        C = yield tb.PUSH_Core2(dut, i.tostring()[::-1],command)
        D= field.square(i)
       
        Mul_array[count]=D.view('uint8')
        count=count+1
    
    for i in range(0,input_data):
     
        D=yield tb.POP_A_Core2(dut)
        D = np.fromstring(D.buff[::-1], dtype=np.uint8)
        #if(np.array_equal(D,Mul_array[i])):
        print "Test Passed"
        print D
            #print Mul_array[i]
        #else:
        #   print "Test Failed"
    yield RisingEdge(dut.clk)
    dut.rd_en_Core2_Output.value=0
            
            
            
    A = np.ndarray(shape=(input_data,16),buffer= np.fromstring(np.random.bytes(256), dtype=np.uint8), dtype=np.uint8)
    
    B = np.ndarray(shape=(input_data,16),buffer= np.fromstring(np.random.bytes(256), dtype=np.uint8), dtype=np.uint8)
    command=1 
    count1=0
    print "############################ Second_test for Core1#############################"        
    for i,j in zip(A,B):
        i=np.concatenate((i,j))
        C = yield tb.PUSH(dut, i.tostring()[::-1],command)
        D= field.square(i)

        Sqr_array[count1]=D.view('uint8')
        count1=count1+1
  
    for i in range(0,input_data):
        
        D=yield tb.POP_A(dut)
        D = np.fromstring(D.buff[::-1], dtype=np.uint8)
        #if(np.array_equal(D,Sqr_array[i])):
        print "Test Passed"
        print D
        print Sqr_array[i]
        #else:
        #    print "Test Failed"
    yield RisingEdge(dut.clk)
    dut.rd_en_Core1_Output.value=0
            
        #print (A[i])'''
        
        