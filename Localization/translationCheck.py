#!/usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import print_function

import re
import sys
import os
import codecs
import subprocess
import shutil

########################################################
# functions Warning and errors
########################################################

def error(*objs):
	print("ERROR:", *objs, file=sys.stderr)
	return
def warning(*objs):
	print("WARNING:", *objs, file=sys.stderr)
	return

########################################################
# functions Keys extraction
########################################################

# return a strings file keys: list
def getKeys(filePath):
	r = '^ *"(.*)" *= *".*" *; *$'
	p = re.compile(r)
	
	keys = []
	# The following line seems too complicated as it can't read some files
	with codecs.open(filePath, "r", "utf-16") as stringsFile:
	# with open(filePath, "r") as stringsFile:
		lines = stringsFile.readlines()
		for l in lines:
			result = p.search(l)
			if (result != None):
				key = result.groups()[0]
				keys.append(key)
	return keys

# Return an array of ( comment, key, value ) triplet
def getKeysInfos(filePath):
	rComment = '^ */\*(.*)\*/ *$'
	pComment = re.compile(rComment)
	rCommentStart = '^ */\*(.*)$'
	pCommentStart = re.compile(rCommentStart)
	rCommentEnd = '(.*)\*/ *$'
	pCommentEnd = re.compile(rCommentEnd)
	rKeyValue = '^ *"(.*)" *= *"(.*)" *; *$'
	pKeyValue = re.compile(rKeyValue)
	
	hasError = False
	keysInfos = []
	# The following line seems too complicated as it can't read some files
	with codecs.open(filePath, "r", "utf-16") as stringsFile:
	# with open(filePath, "r") as stringsFile:
		lines = stringsFile.readlines()
		lineCount = 0
		hasComment = False
		hasCommentStarted = False
		cComment = ""
		for lRaw in lines:
			lineCount += 1
			l = lRaw.strip()
			if l != "":
				if not hasComment:
					if not hasCommentStarted:
						result = pComment.search(l)
						if result != None :
							cComment = result.groups()[0]
							hasComment = True
						else:
							result = pCommentStart.search(l)
							if result != None :
								cComment = result.groups()[0]
								hasCommentStarted = True
							else:
								print("cComment : " + cComment)
								print("hasComment : " + str(hasComment))
								print("hasCommentStarted : " + str(hasCommentStarted))
								error("Invalid comment format at line " + str( lineCount ) + " : " + lRaw )
								hasError = True
					else:
						result = pCommentEnd.search(l)
						if result != None :
							cComment += "\n" + result.groups()[0]
							hasComment = True
						else:
							cComment += "\n" + l
				else:
					result = pKeyValue.search(l)
					if (result != None):
						key = result.groups()[0]
						value = result.groups()[1]
						keysInfos.append( ( cComment.strip(), key, value ) )
						key = ""
						value = ""
						cComment = ""
					else:
						error("Invalid pair key/value format at line " + str( lineCount ) + " : " + lRaw )
						hasError = True
					hasComment = False
					hasCommentStarted = False
	if hasError:
		return None
	else:
		return keysInfos

# any duplicated items?
def isDuplicatedItems(l):
	n1 = len(l)
	n2 = len(set(l))
	return n1 != n2

# print a list's duplicated items
def printDuplicatedItems(l):
	for x in l:
		if l.count(x) > 1:
			print( x )
			l.remove(x)
	return

########################################################
# functions Keys Translation check
########################################################

# return a strings file keys equals to their values: list
def getUntranslatedKeys(filePath):
	r = '^ *"(.*)" *= *"(.*)" *; *$'
	p = re.compile(r)
	
	keys = []
	# The following line seems too complicated as it can't read some files
	with codecs.open(filePath, "r", "utf-16") as stringsFile:
	# with open(filePath, "r") as stringsFile:
		lines = stringsFile.readlines()
		for l in lines:
			result = p.search(l)
			if (result != None):
				key = result.groups()[0]
				value = result.groups()[1]
				if( key == value or value == "" ):
					keys.append(key)
	return keys

# return a strings file keys not equals to their values and without empty value: list
def getTranslatedKeys(filePath):
	r = '^ *"(.*)" *= *"(.*)" *; *$'
	p = re.compile(r)

	keys = []
	# The following line seems too complicated as it can't read some files
	with codecs.open(filePath, "r", "utf-16") as stringsFile:
	# with open(filePath, "r") as stringsFile:
		lines = stringsFile.readlines()
		for l in lines:
			result = p.search(l)
			if (result != None):
				key = result.groups()[0]
				value = result.groups()[1]
				if( key != value and value != "" ):
					keys.append(key)
	return keys

########################################################
# functions Localization process
########################################################

# return a strings file keys: list
def prepareLocalizationPaths(folderPath):
	baseLprojFolderName = "Base.lproj"
	baseLocalizationFolderPath = ""
	localizationFiles = []
	localizationFolders = []
	foundExacltyOneFolderBaseLproj = False
	numberOfFolderBaseLprojFound = 0
	for (dirpath, dirnames, filenames) in os.walk(folderPath):
		if dirpath.endswith(baseLprojFolderName) :
			if baseLocalizationFolderPath == "" :
				baseLocalizationFolderPath = dirpath
				foundExacltyOneFolderBaseLproj = True
				numberOfFolderBaseLprojFound += 1
			else :
				foundExacltyOneFolderBaseLproj = False
				numberOfFolderBaseLprojFound += 1
				warning("Base.lproj already found at " + baseLocalizationFolderPath + " but found another at " + dirpath)
	if not foundExacltyOneFolderBaseLproj :
		print("baseLocalizationFolderPath : " + baseLocalizationFolderPath)
		warning( str(numberOfFolderBaseLprojFound) + " Base.lproj folder found. Aborting prepareLocalizationForHuman.")
		return (None,None,None)
	else :
		# Continue execution
		print("baseLocalizationFolderPath : " + baseLocalizationFolderPath)
		localizationFiles = [
			lFile
			for lFile
			in os.listdir(baseLocalizationFolderPath)
			if lFile.endswith(".strings")
				and os.path.isfile(os.path.join(baseLocalizationFolderPath,lFile))
			]
		(head,tail) = os.path.split(baseLocalizationFolderPath)
		# print("head : " + head)
		# print("tail : " + tail)
		localizationFolders = [
			os.path.join(head,lFile)
			for lFile
			in os.listdir(head)
			if lFile.endswith(".lproj")
				and not os.path.isfile(os.path.join(head,lFile))
				and not lFile == baseLprojFolderName
			]
		# print("localizationFiles : ", localizationFiles)
		# print("localizationFolders : ", localizationFolders)
	return ( baseLocalizationFolderPath, localizationFiles, localizationFolders )

def writeLocalizationFiles( sourceFilesProjectRootFolderPath, outputLocalizationFolderPath ):
	# executionCommand = "find " + sourceFilesProjectRootFolderPath + " -name \*.m" + " | " + "xargs genstrings -o " + outputLocalizationFolderPath
	# print( executionCommand )
	# findFilesCommand = subprocess.Popen( ["ls","-l"], stdout = subprocess.PIPE )
	# genstringsCommand = subprocess.Popen( ["grep","Playzer"], stdin = findFilesCommand.stdout, stdout=subprocess.PIPE )
	# The \ before the * was not working well
	# findFilesCommand = subprocess.Popen( ["find",sourceFilesProjectRootFolderPath,"-name","\*.m"], stdout = subprocess.PIPE )
	# findFilesCommand = subprocess.Popen( ["find",sourceFilesProjectRootFolderPath,"-name","*.m"], stdout = subprocess.PIPE, stderr = subprocess.PIPE )
	# findFilesCommand = subprocess.Popen( ["find",sourceFilesProjectRootFolderPath,"-name","*.m","-exec","echo '{}' ;"], stdout = subprocess.PIPE, stderr = subprocess.PIPE )
	# NOTE : the final solution was to use find with -print0 and xargs with -0 to force the use of other separator
	findFilesCommand = subprocess.Popen( ["find",sourceFilesProjectRootFolderPath,"-name","*.m","-print0"], stdout = subprocess.PIPE, stderr = subprocess.PIPE )
	
	# (stdoutdata, stderrdata) = findFilesCommand.communicate()
	# print( "findFilesCommand stdout : ",stdoutdata )
	# print( "findFilesCommand stderr : ",stderrdata )
	
	# "stdin = findFilesCommand.stdout" is necessary to link subprocesses
	# genstringsCommand = subprocess.Popen( ["xargs","genstrings","-o",outputLocalizationFolderPath], stdin = findFilesCommand.stdout, stdout = subprocess.PIPE, stderr = subprocess.PIPE )
	# genstringsCommand = subprocess.Popen( ["xargs","genstrings","-skipTable","ProjectName","-o",outputLocalizationFolderPath], stdin = findFilesCommand.stdout, stdout = subprocess.PIPE, stderr = subprocess.PIPE )
	genstringsCommand = subprocess.Popen( ["xargs","-0","genstrings","-o",outputLocalizationFolderPath], stdin = findFilesCommand.stdout, stdout = subprocess.PIPE, stderr = subprocess.PIPE )
	findFilesCommand.stdout.close()
	(stdoutdata, stderrdata) = genstringsCommand.communicate()
	if stdoutdata != "":
		print( "stdoutdata :",stdoutdata )
	if stderrdata != "":
		print( "stderrdata :",stderrdata )
	return

def compareLocalizationFile( file1Path, file2Path ):
	keys1 = getKeys(file1Path)
	keys2 = getKeys(file2Path)
	# error if duplicated entries in either files
	if isDuplicatedItems(keys1):
		error("Duplicated entries in " + file1Path + ":" )
		printDuplicatedItems(keys1)
		return ( None, None )
	
	if isDuplicatedItems(keys2):
		error("Duplicated entries in " + file2Path + ":" )
		printDuplicatedItems(keys2)
		return ( None, None )
	
	# Keys in both
	keysInBoth = []
	# deleted keys
	keysIn1ButNotIn2 = []
	for x in keys1:
		if not(x in keys2):
			keysIn1ButNotIn2.append(x)
		else:
			keysInBoth.append(x)
	
	# added keys
	keysIn2ButNotIn1 = []
	for x in keys2:
		if not(x in keys1):
			keysIn2ButNotIn1.append(x)
	
	return ( keysIn1ButNotIn2, keysIn2ButNotIn1, keysInBoth )

def compareCommentsInLocalizationFileForSameKey( file1Path, file2Path ):
	keys1 = getKeys(file1Path)
	keys2 = getKeys(file2Path)
	
	# error if duplicated entries in either files
	if isDuplicatedItems(keys1):
		error("Duplicated entries in " + file1Path + ":" )
		printDuplicatedItems(keys1)
		return ( None, None )
	
	if isDuplicatedItems(keys2):
		error("Duplicated entries in " + file2Path + ":" )
		printDuplicatedItems(keys2)
		return ( None, None )
		
	keysInfos1 = getKeysInfos(file1Path)
	keysInfos2 = getKeysInfos(file2Path)
	
	keysInBothWithComments = []
	if keysInfos1 != None and keysInfos2 != None :
		for indexIn1, key in enumerate(keys1):
			# print indexIn1, key
			if (key in keys2):
				indexIn2 = keys2.index(key)
				(infoComment1, infoKey1, infoValue1) = keysInfos1[indexIn1]
				(infoComment2, infoKey2, infoValue2) = keysInfos2[indexIn2]
				keysInBothWithComments.append((key,infoComment1,infoComment2))
	
	return keysInBothWithComments

########################################################
# functions Localization process
########################################################

def checkMissingKeys( baseLocalizationFolderPath, localizationFiles, localizationFolders ):
	print( "================================================ Missing Keys" )
	# lFileBase = os.path.basename( baseLocalizationFolderPath )
	for lFolderPath in localizationFolders:
		lFolderName = os.path.basename( lFolderPath )
		print( "================================ Files for " + lFolderName )
		for lFileName in localizationFiles:
			print( "================ Keys for file " + os.path.join( lFolderName, lFileName ) )
			lFileBasePath = os.path.join( baseLocalizationFolderPath, lFileName )
			lFileLangPath = os.path.join( lFolderPath, lFileName )
			filesExist = True
			if not ( os.path.exists( lFileBasePath ) and os.path.isfile( lFileBasePath ) ):
				error( lFileBasePath + " does not exist" )
				filesExist = False
			if not ( os.path.exists( lFileLangPath ) and os.path.isfile( lFileLangPath ) ):
				warning( lFileLangPath + " does not exist. Copying the file from Base" )
				shutil.copy2( lFileBasePath, lFileLangPath )
				filesExist = False
			if filesExist:
				( keysInBaseButNotInLang, keysInLangButNotInBase, keysInBoth ) = compareLocalizationFile( lFileBasePath, lFileLangPath )
				# Display
				# if keysInBoth != None and len(keysInBoth) > 0:
				# 	print( "*** Key in Base and in ", lFolderName, " ***" )
				# 	for keyWithConflict in keysInBoth:
				# 		print( keyWithConflict )
				if keysInBaseButNotInLang != None and len(keysInBaseButNotInLang) > 0:
					print( "*** Key in Base but not in " + lFolderName + " (Keys to add) ***" )
					for keyAdded in keysInBaseButNotInLang:
						print( keyAdded )
				if keysInLangButNotInBase != None and len(keysInLangButNotInBase) > 0:
					print( "*** Key in " + lFolderName + " but not in Base (Keys deleted) ***" )
					for keyDeleted in keysInLangButNotInBase:
						print( keyDeleted )
	return

def checkConflictingCommentsForKeys( baseLocalizationFolderPath, localizationFiles, localizationFolders ):
	print( "================================================ Conflicting comments for Keys" )
	# lFileBase = os.path.basename( baseLocalizationFolderPath )
	for lFolderPath in localizationFolders:
		lFolderName = os.path.basename( lFolderPath )
		print( "================================ Files for " + lFolderName )
		for lFileName in localizationFiles:
			print( "================ Keys for file " + os.path.join( lFolderName, lFileName ) )
			lFileBasePath = os.path.join( baseLocalizationFolderPath, lFileName )
			lFileLangPath = os.path.join( lFolderPath, lFileName )
			filesExist = True
			if not ( os.path.exists( lFileBasePath ) and os.path.isfile( lFileBasePath ) ):
				error( lFileBasePath + " does not exist" )
				filesExist = False
			if not ( os.path.exists( lFileLangPath ) and os.path.isfile( lFileLangPath ) ):
				warning( lFileLangPath + " does not exist. Copying the file from Base" )
				shutil.copy2( lFileBasePath, lFileLangPath )
				filesExist = False
			if filesExist:
				keysWithComments = compareCommentsInLocalizationFileForSameKey( lFileBasePath, lFileLangPath )
				# Display
				if keysWithComments != None and len(keysWithComments) > 0:
					print( "*** Key in Base and in " + lFolderName + " with different comments ***" )
					for (keyWithConflict,commentInBase,commentInLang) in keysWithComments:
						if (commentInBase != commentInLang):
							print( "--- " + keyWithConflict + "\n- Base : " + commentInBase + "\n- Lang : " + commentInLang )
	return

def checkUntranslatedKeys( localizationFiles, localizationFolders ):
	print( "================================================ Non Translated Keys" )
	for lFolderPath in localizationFolders:
		lFolderName = os.path.basename( lFolderPath )
		print( "================================ Files for " + lFolderName )
		for lFileName in localizationFiles:
			lFileLangPath = os.path.join( lFolderPath, lFileName )
			filesExist = True
			if not ( os.path.exists( lFileLangPath ) and os.path.isfile( lFileLangPath ) ):
				error( lFileLangPath + " does not exist" )
				filesExist = False
			if filesExist:
				nonTranslatedKeys = getUntranslatedKeys( lFileLangPath )
				# Display
				if nonTranslatedKeys != None and len(nonTranslatedKeys) > 0:
					print( "================ Not translated keys for file " + os.path.join( lFolderName, lFileName ) )
					for keyAdded in nonTranslatedKeys:
						print( keyAdded )
	return

def checkLocalization( baseLocalizationFolderPath, localizationFiles, localizationFolders ):
	print( "================================================ Localization paths" )
	print( "Base.lproj Root folder for Localization process : " + baseLocalizationFolderPath )
	print( "localizationFiles : " + str(localizationFiles) )
	print( "localizationFolders : " + str(localizationFolders) )
	# TODO LATER : implement a check for natural language to detect only non translated when relevant
	checkMissingKeys( baseLocalizationFolderPath, localizationFiles, localizationFolders )
	checkUntranslatedKeys( localizationFiles, localizationFolders )
	checkConflictingCommentsForKeys( baseLocalizationFolderPath, localizationFiles, localizationFolders )
	return

def processLocalization( sourceFilesProjectRootFolderPath, withPrint = True, withFileCompletion = False ):
	if withPrint:
		print( "Root folder for Localization process : " + sourceFilesProjectRootFolderPath )
	( baseLocalizationFolderPath, localizationFiles, localizationFolders ) = prepareLocalizationPaths( sourceFilesProjectRootFolderPath )
	if baseLocalizationFolderPath == None or localizationFiles == None or localizationFolders == None :
		error( "prepareLocalizationPaths fails" )
		return
	writeLocalizationFiles( sourceFilesProjectRootFolderPath, baseLocalizationFolderPath )
	if withPrint:
		checkLocalization( baseLocalizationFolderPath, localizationFiles, localizationFolders )
	if withFileCompletion:
		completeLocalizationFilesWithMissingKeys( baseLocalizationFolderPath, localizationFiles, localizationFolders, withPrint )
	
	return

def completeMissingKeysInFile( lFilePathFrom, lFilePathTo, withPrint = True ):
	keysInfosFrom = getKeysInfos( lFilePathFrom )
	keysInfosTo = getKeysInfos( lFilePathTo )
	( keysInFromButNotInTo, keysInToButNotInFrom, keysInBoth ) = compareLocalizationFile( lFilePathFrom, lFilePathTo )
	if keysInfosFrom == None:
		error( "keysInfosFrom is None" )
		return 0
	if keysInfosTo == None:
		error( "keysInfosTo is None" )
		return 0
	if keysInFromButNotInTo == None:
		error( "keysInFromButNotInTo is None" )
		return 0
	if keysInToButNotInFrom == None:
		error( "keysInToButNotInFrom is None" )
		return 0
	
	if len(keysInFromButNotInTo) <= 0:
		return 0
	
	# Whether or not the choice is valid for the whole file
	definitiveChoiceForCompletion = False
	# Variable to store the choice of the user
	completeWithBaseValue = False
	
	numberOfMisingKeys = 0
	for (comment, key, value) in keysInfosFrom:
		if key in keysInFromButNotInTo:
			# We ask the user only if its choice is not valid for the wholde file
			if not definitiveChoiceForCompletion:
				print("Complete key " + key + " in file " + lFilePathTo + "\nwith value : \"" + value + "\" ? (y for yes ; N for no ; ya for yes for whole file ; na for no for whole file)" )
				# Get input.
				inputValue = raw_input().lower()
				
				# Default behaviour, same as n
				# No for this entry
				completeWithBaseValue = False
				if inputValue == "y":
					# Yes for this entry
					completeWithBaseValue = True
				elif inputValue == "ya":
					# Yes for every entry in this file
					completeWithBaseValue = True
					definitiveChoiceForCompletion = True
				elif inputValue == "n":
					# No for this entry
					completeWithBaseValue = False
				elif inputValue == "na":
					# No for every entry in this file
					completeWithBaseValue = False
					definitiveChoiceForCompletion = True
			
			if completeWithBaseValue:
				keysInfosTo.append( (comment, key, value) )
				if withPrint:
					print( "key " + key + " appended with value \"" + value + "\"" )
			else:
				# NOTE : we choose to complete the file with empty values to prevent completing with incorrect text
				keysInfosTo.append( (comment, key, "") )
				if withPrint:
					print( "key " + key + " appended with empty value" )
			
			numberOfMisingKeys += 1
	
	keysInfosTo = sorted( keysInfosTo, key=lambda keysInfosTo: keysInfosTo[1] ) # Does what I want : sorting by key
	
	# with open( lFilePathTo, 'w', ) as fileTo:
	with codecs.open( lFilePathTo, "w", "utf-16" ) as fileTo:
		# fileTo.write( "\n" ) # Unnecessary
		for (comment, key, value) in keysInfosTo:
			fileTo.write( "/* " + comment + " */" + "\n" )
			fileTo.write( "\"" + key + "\" = \"" + value + "\";" + "\n" )
			fileTo.write( "\n" )
	return numberOfMisingKeys

def completeLocalizationFilesWithMissingKeys( baseLocalizationFolderPath, localizationFiles, localizationFolders, withPrint = True ):
	if withPrint:
		print( "================================================ Completing files with missing keys" )
	for lFolderPath in localizationFolders:
		lFolderName = os.path.basename( lFolderPath )
		if withPrint:
			print( "================================ Files for " + lFolderName )
		for lFileName in localizationFiles:
			if withPrint:
				print( "Completing file", os.path.join( lFolderName, lFileName ) )
			lFileBasePath = os.path.join( baseLocalizationFolderPath, lFileName )
			lFileLangPath = os.path.join( lFolderPath, lFileName )
			filesExist = True
			if not ( os.path.exists( lFileBasePath ) and os.path.isfile( lFileBasePath ) ):
				error( lFileBasePath + " does not exist" )
				filesExist = False
			if not ( os.path.exists( lFileLangPath ) and os.path.isfile( lFileLangPath ) ):
				warning( lFileLangPath + " does not exist. Copying the file from Base" )
				shutil.copy2( lFileBasePath, lFileLangPath )
				filesExist = False
			if filesExist:
				numberOfKeysAdded = completeMissingKeysInFile( lFileBasePath, lFileLangPath, withPrint )
				if withPrint:
					print( str( numberOfKeysAdded ) + " key(s) added" )
	return































