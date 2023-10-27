# GDGs in a TSO session execution  
If you don't know what a GDG(Generation Data Group) is refer to [IBM Documentation](https://www.ibm.com/docs/en/zos-basic-skills?topic=vtoc-what-is-generation-data-group)  

## How z/Os handles GDGs?
GDGs are very useful and easy to use(IMO) in a JCL environment. They still reamain useful but not so easy if you want to use them in an interactive REXX execution.  
GDG version is stored in the task life:  
In a Job execution(JCL) the 0 version is the current version, +1 the new one, +2 the newest one and so on. If we write, for example, a +1 version of the GDG TUX.FILE.OUT in the JCL named A, the JCL that will follow can refer to this version as the 0-version because the end of the job consolidates versions.  
**But what happens in a TSO session?**  
A TSO session is treated as a task in the system so you can still use 0,+1,+2... but they will remain the same reference until the task will be terminated(read as logoff!).  

## How to handle this condition
If you want to generate a new version in a GDG base your journey starts from determine the current 0-version: you can do it using a [TSO LISTC](https://www.ibm.com/docs/en/zos/2.1.0?topic=subcommands-listcat-command) command:  
``` REXX
ADDRESS TSO "LISTC ENTRY('"filename"') ALL"
```
