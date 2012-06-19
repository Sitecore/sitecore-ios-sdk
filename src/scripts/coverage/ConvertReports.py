#! /usr/bin/env python
#
####

import sys
import os

def targetFromCoverageDirectory( coverageDir ):
    head = coverageDir
    dummy = ''
    target = ''  
    (head, tail ) = os.path.split( head )
    (head, tail ) = os.path.split( head )
    (head, tail ) = os.path.split( head )
    (target, dummy ) = os.path.splitext( tail )

    print head
    print target
    
    return target

srcRoot = sys.argv[1]
deploymentDir = sys.argv[2]

print srcRoot
print deploymentDir

f = open('CoverageDirectories-distinct.txt', 'r' )
for line in f:
    target = targetFromCoverageDirectory( line )
    cmd = '/bin/bash "$PWD/ConvertSingleReport.sh"' \
        + ' "' + line + '"' \
        + ' "' + target + '"' \
        + ' "' + deploymentDir + '"' \
        + ' "' + srcRoot + '"'
     
    print cmd
    os.system( cmd )
    
    #os.execl( './ConvertSingleReport.sh', line, target, deploymentDir, srcRoot )

    #execfile( '/usr/local/bin/gcovr', 
    
    
    
    
    
    