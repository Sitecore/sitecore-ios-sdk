#! /usr/bin/env python
#
####

f = open('CoverageDirectories.txt', 'r' )
uniqueLines = set( f )

g = open('CoverageDirectories-distinct.txt', 'w' )
g.writelines( uniqueLines )

