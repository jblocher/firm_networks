/* *************************************************************************/
/* CREATED BY:      Jesse Blocher (UNC-Chapel Hill)                                               
/* MODIFIED BY:                                                    
/* DATE CREATED:    October 2009                                                                                                               
/* PROG NAME:       get_thomson.sas                                                              
/* Project:         MF Ownership Induces Correlations
/* This File:       Pulls ownership data from Thomson
/************************************************************************************/
/* Datasets required to run: 
 * firmnet.rdateYYMMDD		: monthly datasets from Thomson (WRDS)
 */
 
/* Datasets Produced:
 * 
 */
 
 %let start_year = 1979; * macro adds 1 since jobarray indices start at 1;
 
%include 'firmnet_header.sas'; *header file with basic options and libraries;

%macro transpose_matrix(keepvar = , YRMO =);
	
	
	proc contents data = firmnet.rdate&YRMO;
	run;
	
	
	data var_matrix_data;
		set firmnet.rdate&YRMO (keep = mgrno cusip &keepvar );
	run;
	
	* code for transposing matrix - first sort it;
	proc sort data = var_matrix_data out = mgrno_sorted nodupkey;
	by mgrno cusip;
	run;
	
	* Now, we need to transpose;
	proc transpose data = mgrno_sorted out = firmnet.&keepvar._mat_&yrmo let;
		by mgrno;
		id cusip;
	run;

%mend transpose_matrix;

* this macro gets the jobarray index to split it up, then runs the rest for each year;
%macro runjob;
	%let index = %sysget(LSB_JOBINDEX);
	%let yr = %eval(&start_year + &index);
	
	%do n = 1 %to 4;
		%let mo = %eval(&n * 3);
		%transpose_matrix(keepvar = block, yrmo = &yr.&mo);
		%transpose_matrix(keepvar = pct_held, yrmo = &yr.&mo);
	%end;

%mend;

%runjob;