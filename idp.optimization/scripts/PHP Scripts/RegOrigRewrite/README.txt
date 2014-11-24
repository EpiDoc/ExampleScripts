
To Run:

Needed - 
TransformServer.class - java class which runs a xslt2 capable saxon server
rewriteRegOrigTags.php - main class
accentLib - library of functions used by rewriteRegOrigTags.php
list-unique-reg-orig_expanded.xsl - stylesheet sent to the TransformServer by rewriteRegOrigTags.xsl

Dictionary files (nb - urls need to be edited to point to the files):
consonants.txt
vowel_homophony.txt
vowel-combinations.txt



System - 

rewriteRegOrigTags.php is pointed towards the directory with the desired xml files for transformation in. It starts the TransformServer with the desired stylesheet. For each xml file below the specified directory the name of the file is written into a text file which is read by the TransformServer. The results of the transformation are written to a temporary file which is then read back in by the php and processed. The converted output is written to the designated output directory structure. This is repeated for each xml file in the input hierarchy.



Supplemental:

accentShiftTest.php - test file for accent moves
accentTk8.php - test file for running accentLib.php 