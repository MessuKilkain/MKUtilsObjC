#!/usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import print_function

import sys
import translationCheck

# translationCheck.processLocalization( "./Playzer" )

# keysInfos = translationCheck.getKeysInfos( "./Playzer/Languages/Base.lproj/Playzer.strings" )
# keysInfos = sorted( keysInfos, key=lambda keyInfos: keyInfos[1] ) # Does what I want : sorting by key
# keysInfos = sorted( keysInfos, key=lambda keyInfos: keyInfos[0] )
# keysInfos = translationCheck.getKeysInfos( "./Playzer/Languages/Base.lproj/Localizable.strings" )
# print()
# for (comment,key,value) in keysInfos:
# 	print( "c :", comment )
# 	print( "k :", key )
# 	print( "v :", value )
# 	print()

# >>> student_tuples = [
#         ('john', 'A', 15),
#         ('jane', 'B', 12),
#         ('dave', 'B', 10),
# ]
# >>> sorted(student_tuples, key=lambda student: student[2])   # sort by age
# [('dave', 'B', 10), ('jane', 'B', 12), ('john', 'A', 15)]

argc = len( sys.argv ) - 1

# INSTRUCTION NOTE : to use easily the localization tool, copy paste the following line and replace the projectFolderPath
# ./localizationTool.py projectFolderPath 1

if argc <= 0:
	print( "usage : scriptName projectFolderPath [shouldCompleteFiles]\n- shouldCompleteFiles : 1 for completing files with missing keys, anything else for no completion" )
	sys.exit()
if argc == 1:
	projectFolderPath = sys.argv[1]
	translationCheck.processLocalization( projectFolderPath )
elif argc == 2:
	projectFolderPath = sys.argv[1]
	completionArg = sys.argv[2]
	completion = False
	if completionArg == "1":
		completion = True
	translationCheck.processLocalization( projectFolderPath, withFileCompletion = completion )


