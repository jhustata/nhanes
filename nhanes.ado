capture program drop nhanes
program define nhanes
 
    qui {
		
		//v04.07.23
		clear
		noi di "by courtesy of https://github.com/jhustata"
	    do nhanes.ael.keep.do
	
	    clear 
	    noi di "loading $keepvars from ${url}adult.DAT"
	    do adult.do
	    save adult.dta, replace 
	
	    clear 
	    noi di "loading $keepvars from ${url}exam.DAT"
	    do exam.do
	    save exam.dta, replace 
	
	    clear 
	    noi di "loading $keepvars from ${url}lab.DAT"	    
		do lab.do
	    save lab.dta, replace 
		
		clear 
		foreach file in adult exam lab {
			
			noi di "appending `file'.dta"
			append using `file'.dta
			rm `file'.do
			rm `file'.dta
			
		}
		
		rename *, lower
		noi di "saving... pwd/nhanes.dta"
		lab data "NHANES III curated for you by https://github.com/jhustata"
		save nhanes.dta, replace
		noi di "completed!"
				
	}
	
end 

