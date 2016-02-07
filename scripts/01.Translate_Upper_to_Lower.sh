#!/bin/bash
# Author:	Arjun Shrinivas
# Date:	24-Jan-2015
# Purpose:	Illustrate using tr in a script to convert upper to lower filenames

for i in `ls -A`
do
  newname=`echo $i | tr A-Z a-z`
  mv $i $newname
done

# End of File
