#!/usr/bin/python

import os
import os.path

# Keep idp.data and idp.optimization at the same level
EPIDOC_XML_DIR=os.path.abspath('../../../idp.data/DDB_EpiDoc_XML')
XINCLUDE_FILE='xinclude.xml'

out = open(XINCLUDE_FILE, 'w')
out.write('<files xmlns:xi="http://www.w3.org/2001/XInclude">\n')

for (path, dirs, files) in os.walk(EPIDOC_XML_DIR):
  for file_name in files:
    out.write('<xi:include href="%s" />\n' % (os.path.join(path, file_name)))
    
out.write('</files>\n')
out.close()
