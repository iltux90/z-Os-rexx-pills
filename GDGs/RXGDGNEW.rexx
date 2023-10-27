/* REXX */                                                 
trace n
filename=userid()".FILE.OUT"                               
/* trap the listc command output */
a=outtrap('lc.','*')                                       
address tso "LISTC ENTRY('"filename"') all"                
a=outtrap('OFF')                                           
/* uncomment to see the output of the listc command
do i=1 to lc.0                                             
   say lc.i                                                
end                                                        
*/                                                         
/* GDG base not found, creating one */
if pos('NOT FOUND',lc.1) > 0 then do                       
   address tso "DEFINE GDG(NAME('"filename"') LIM(5) SCR)" 
   say 'creazione gdg:' rc                                 
end                                                        
curr_gen=''                                                
/* reading the outtrap result from the end, searching for the last version */
do i=lc.0 to 1 by -1                                       
   if SUBSTR(lc.i,4,12) = 'NONVSAM ----' THEN DO           
      /* extracting the GxxxxVxx string that contains the version */
      gdggen = substr(lc.i,34,8)                           
      /* adding 1 to Gxxxx version */
      nextgen=substr(gdggen,2,4)+1                         
      /* overlay the version number */
      gdggen=overlay(right(nextgen,4,0),gdggen,2,4,0)      
      /* recompose the complete filename */
      curr_gen = filename!!'.'!!gdggen                     
      curr_gen = strip(curr_gen)                         
      leave                                              
   end                                                   
end                                                      
say curr_gen                                             
/* if no version was found we force the creation of the version 1(example only GDG base was defined) */
if curr_gen='' then do                                   
   curr_gen=filename'.G0001V00'                          
end                                                      
address tso "ALLOC F(FILEOUT) DA('"curr_gen"') NEW ",    
            "SPACE(4,2) CYLINDERS RECFM(F,B) LRECL(80)" 
src=rc                                                   
if src /==0 then                                         
   return src                                            
/* let's try to write something */
out.0=1                                                  
out.1='hello world'                                             
'EXECIO * DISKW SDMSOUT (STEM OUT. OPEN FINIS'           
say rc                                                   
'free all'                                               
EXIT                                                     
