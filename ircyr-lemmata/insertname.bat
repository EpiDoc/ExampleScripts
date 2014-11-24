rem BATCH FILE TO INSERT WORD LEMMATA
rem NAME REGS
rem AND
rem PLACENAME REGS
rem IN ALL XML FILES IN FOLDER

cd ..\..\xml\workspace\

perl ..\..\perl\dt.pl . off

for %%a in (*.xml) do call saxon -t -w1 -o ..\leminscrip\%%a %%a ..\..\xslt\lemmata\insertnameregs.xsl

perl ..\..\perl\dt.pl . on
perl ..\..\perl\dt.pl ..\leminscrip on

cd ..\..\xslt\lemmata
