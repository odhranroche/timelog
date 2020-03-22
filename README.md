<pre>

Name:        time.lua
Usage:       lua time.lua
Commands:    exit, quit -> end timing
             view       -> takes a date in format YYYYMMDD and prints time for that day
             TODO : view today|yesterday -> prints relative time
             pause      -> stops timer
Version:     1
Description:
A command line task timer. Logs are kept and a breakdown of time spent on each task can be viewed.

Example session:

λ lua time.lua                              
                                            
time track >> task 1                        
Tracking task 1 for the first time          
                                            
time track >> task 2                        
Tracking task 1 complete                    
Tracking task 2 for the first time          
                                            
time track >> snack break                   
Tracking task 2 complete                    
Tracking snack break for the first time     
                                            
time track >> task 2                        
Tracking snack break complete               
Tracking task 2 again                       
                                            
time track >> view                          
Tracking task 2 complete                    
                                            
snack break    0.50 mins   34.48%           
task 1        0.42 mins   28.74%            
task 2        0.53 mins   36.78%            
---------------------------------           
Total         1.45 mins                     
                                            
time track >> exit                          


</pre>
