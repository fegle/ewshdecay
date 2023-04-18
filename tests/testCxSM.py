import argparse
import sys
import os.path
import subprocess
sys.path.insert(0,os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'tools'))

from readEWsHDECAY import read

parser = argparse.ArgumentParser(description='Tests the broken phase of CxSM.',
                                formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('exe',type=str,help='Path to the EWsHDECAY executable.')
parser.add_argument('phase',type=int,help='sHDECAY Phase: 1 (broken), 2 (DSP), 3 (IDP), 4 (DSDP)')
args = parser.parse_args()


checkpath = 'check_output_phase{}/'.format(args.phase)
try:
    os.mkdir(checkpath)
except OSError:
    pass

subprocess.run(args=[args.exe, '-i', os.path.join(os.path.dirname(__file__),'phase{}.in'.format(args.phase)), '-o', checkpath])

check = read(checkpath)
reference = read(os.path.join(os.path.dirname(__file__),'out{}'.format(args.phase)))

if not check == reference:
    for key in check.keys():
        if check[key]!= reference[key]:
            print(key,check[key],reference[key])
    exit(1)
exit(0)
