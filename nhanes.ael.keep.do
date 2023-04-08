qui { 
	
	if 0 { //background,context
		
		1.chapter: delimit
		2.generalized: adult,exam,lab
		3.product: three .do files
		
	}
	
	if 1 { //settings,logfile,macros
		
		capture log close 		
		
        global url https://wwwn.cdc.gov/nchs/data/nhanes3/1a/ 
		global fyl adult exam lab 
		global range 1387/2624 2627/3865 2892/5259 5262/7629 640/995 998/1353 
		global keepvars SEQN //HSAGEIR BMPHT BMPWT HAZA8AK1 CEP GHP HAB1 
		
	}
	
	if 2 { //translate .sas -> .do
		
		local range=1
		
		foreach file in adult exam lab { 

		   if 2.2 { //import .sas read-in commands
		   	
				import delimited using "${url}`file'.sas",clear
				di "import using `file'.sas"

		   }

		   if 2.3 { //export .do read-in commands
		       preserve 
                  local num: di word("$range",`range')
		          keep in `num'
			      local range=`range'+1		          
				  keep v1
		          g id=_n+2
		          insobs 1
		          replace v1="#delimit ;" in `c(N)'
		          insobs 1
		          replace v1="infix" in `c(N)'
		          insobs 1
		          replace v1="using ${url}`file'.dat ;" in `c(N)'
		          insobs 1
		          replace v1="#delimit cr" in `c(N)'
		          replace id=1 if v1=="#delimit ;"
		          replace id=2 if v1=="infix"
		          replace id=`c(N)' if v1=="using ${url}`file'.dat ;"
		          replace id=id-1 if v1=="using ${url}`file'.dat ;"
		          replace id=`c(N)' if v1=="#delimit cr"
		          sort id
		          drop id
		          tempfile vars
		          format v1 %-20s
		          rename v1 concat 
		          keep concat 
		          save `vars'
		       restore 
		       
               local num: di word("$range",`range')
		       keep in `num'
			   local range=`range'+1
	           split v1, p(" = ")
	           gen concat="lab var "+v11+" "+v12
		       keep concat 
		       format concat %-20s
	           drop in `c(N)'
		       tempfile labs
		       save `labs'

		       use `vars', clear
		       append using `labs'
			   rename *,lower
			   			   
			   if 1 { //user-selected variables of interest
			   
			   	foreach nhvars in $keepvars {
					
					preserve 
					#delimit ;
					    keep if strpos(concat,"`nhvars'") | 
						        strpos(concat,"delimit")  |
								strpos(concat,"infix")    |
								strpos(concat,"https")
								; 
    	            #delimit cr 

		            outfile using "`file'-`nhvars'.do", noquote replace
		            outfile using "`file'.do", noquote replace
					
					if c(N) == 4 {

					rm "`file'-`nhvars'.do" 
					noi di "`file'-`nhvars'" 
					restore 

					}
					
					else {
						
					restore 

						
					}

					
			    } 
			   
			   

				
			   }
			
		   }
		   
		} 
				
	}
	
}
