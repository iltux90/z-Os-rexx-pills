# GDGs in a TSO session execution  
If you don't know what a GDG(Generation Data Group) is refer to [IBM Documentation](https://www.ibm.com/docs/en/zos-basic-skills?topic=vtoc-what-is-generation-data-group)  

## How z/Os handles GDGs?
GDGs are very useful and easy to use(IMO) in a JCL environment. They still reamain useful but not so easy if you want to use them in an interactive REXX execution.  
GDG version is stored in the task life:  
In a Job execution(JCL) the 0 version is the current version, +1 the new one, +2 the newest one and so on. If we write, for example, a +1 version of the GDG TUX.FILE.OUT in the JCL named A, the JCL that will follow can refer to this version as the 0-version because the end of the job consolidates versions.  
**But what happens in a TSO session?**  
A TSO session is treated as a task in the system so you can still use 0,+1,+2... but they will remain the same reference until the task will be terminated(read as logoff!).  

## How to handle this condition
If you want to generate a new version in a GDG base your journey starts from determine the current 0-version: you can do it using a [TSO LISTC](https://www.ibm.com/docs/en/zos/2.1.0?topic=subcommands-listcat-command) command and trap the output with [OUTTRAP](https://www.ibm.com/docs/en/zos/2.4.0?topic=tef-outtrap) command:  
``` REXX
a=outtrap('lc.')
ADDRESS TSO "LISTC ENTRY('"filename"') ALL"
a=outtrap('OFF')
/* optional GDG base define */
if pos('NOT FOUND',lc.1) > 0 then do                      
   address tso "DEFINE GDG(NAME('"filename"') LIM(5) SCR)"                             
end                                                       
```
In my case I decided to create the GDG if the base was not found in catalog.  
After this you should scan the lc. stem from the end and search for the first 'NONVSAM ----' occurrence: there you can find the 0 version of the GDG! You can go backwards more searching for other past versions(-1,-2...)  
Once you find the string you can proceed to the extraction of the GxxxxVxx version string.  
``` REXX
curr_gen=''
do i=lc.0 to 1 by -1                                  
   if SUBSTR(lc.i,4,12) = 'NONVSAM ----' then do
      gdggen = substr(lc.i,34,8)                      
      nextgen=substr(gdggen,2,4)+1                    
      gdggen=overlay(right(nextgen,4,0),gdggen,2,4,0) 
      curr_gen = filename!!'.'!!gdggen                
      curr_gen = strip(curr_gen)                      
      leave                                           
   end                                                
end
if curr_gen='' then do                                  
   curr_gen=filename'.G0001V00'                         
end                                                     
address tso "ALLOC F(FILEOUT) DA('"curr_gen"') NEW ",   
            "SPACE(4,2) CYLINDERS RECFM(F,B) LRECL(133)"
```
Once done that just add 1 to the number of version, compose the complete filename and proceed to the allocation of the file.  
In my case I forced the creation of the version 1 if the scan produced no result.
Now you are done! you can use the new version as usually!  

A complete and documented REXX exec can be found [HERE](RXGDGNEW.rexx)
