# ISPF Skeleton
## Introduction  
Skeletons are a very fast way to write dynamic files with a template. Often used as a template to generate a JCL file but can also write plain text files.  
## Skeleton keywords
**This section will be updated progressively while I discover and test other commands**  
Every skeleton keyword begin with ) and every variable with &  
- )CM : used for comments
- )IM : import another skeleton
- )DOT <isptablename> : used to write an ISPF Table into a section of the output file. Must be closed with )ENDDOT
- )BLANK : insert a blank line to the output file
