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
## How to use a skeleton
Before starting to use a skeleton my advice is to define a dedicated library, just to keep objects separated. This library needs to be declared before using file tailoring services that are needed to perform the creation of the output file.  
For this example we will use a job head skeleton that will be imported in the main skeleton that will perform a file copy operation from a file which name will be asked to the user using pull.  
We will import [JOBCARD](JOBCARD) into [SKSAMPLE](SKSAMPLE), give the values to the variables defined in the skeleton, invoke the file tailoring services and then display the copied file.  
Doing this is simple: just use the )IM <skeleton_name> and it's done!  
```
)IM JOBCARD
```
