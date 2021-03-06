#!/usr/bin/env python2
# -*- coding: utf-8 -*-

#import argparse
#import shutil
#import logging
import sys, os, re
import math

EXIT_SUCCESS = 0
EXIT_FAILURE = 1

def main():
    """Main routine."""

    deta_addr = 64 # 6 bits
    dphi_addr = 64 # 6 bits
    
    deta_len = 230 # number of calo delta eta bins
    deta_bin = 0.0435 # bin width calo delta eta
    dphi_len = 144 # number of calo delta phi bins
    dphi_bin = 2*math.pi/dphi_len # bin width calo delta phi
    dr_list = [0] * deta_addr * 4 * dphi_addr * 2
    prec = 5 # precision of delta R values (digits after comma, rounded)
    line_len = 16
    
    for k in range(0,4):
        for l in range(0,2):            
            print "writing to firmware/ngc/rom_lut_calo_inv_dr_sq_part{}.coe".format(k+1+l*4)
            coe_file_path = 'firmware/ngc/rom_lut_calo_inv_dr_sq_part%s.coe' % str(k+1+l*4)
            fout = open(coe_file_path,"w+")
            index = 1 
            fout.write("memory_initialization_radix=10;\n")
            fout.write("memory_initialization_vector=\n")
            for i in range(deta_addr*k, deta_addr*k+deta_addr):
                for j in range(dphi_addr*l, dphi_addr*l+dphi_addr):
                    if (i == 0 and j == 0) or i >= deta_len:
                        dr_list[i*j+j] = 0
                    else:
                        dr_list[i*j+j] = int(10**prec * round(1/(((i*deta_bin)**2)+((j*dphi_bin)**2)), prec))                        
                    fout.write('%s,' % dr_list[i*j+j])                    
                    if not (index % line_len):
                        fout.write("\n")                        
                    index += 1
                #fout.write("\n")                
            fout.write(";")
            fout.close()
    
    dr_list9 = [0] * 256 * 16
    print "writing to firmware/ngc/rom_lut_calo_inv_dr_sq_part9.coe"
    fout = open('firmware/ngc/rom_lut_calo_inv_dr_sq_part9.coe',"w+")
    index = 1 
    fout.write("memory_initialization_radix=10;\n")
    fout.write("memory_initialization_vector=\n")
    for i in range(0, 256):
        for j in range(0, 16):
            if i >= deta_len:
                dr_list9[i*j+j] = 0
            else:
                dr_list9[i*j+j] = int(10**prec * round(1/(((i*deta_bin)**2)+(((j+128)*dphi_bin)**2)), prec))                
            fout.write('%s,' % dr_list9[i*j+j])            
            if not (index % line_len):
                fout.write("\n")
            index += 1
        #fout.write("\n")
    fout.write(";")
    fout.close()

if __name__ == '__main__':
    try:
        main()
    except RuntimeError, message:
        logging.error(message)
        sys.exit(EXIT_FAILURE)
    sys.exit(EXIT_SUCCESS)
