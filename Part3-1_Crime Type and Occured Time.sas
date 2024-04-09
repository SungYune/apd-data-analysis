/* INSERT DATASET */
%web_drop_table(WORK.APDC);


FILENAME REFFILE '/home/u62596967/spring2024/APD.UPDATED.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.APDC;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.APDC; RUN;


%web_open_table(WORK.APDC);

/* CHECKING DATA */
Proc Contents data=work.APDC;
run;

proc means data = APDC n mean std min q1 median q3 max;
run;

PROC FREQ DATA=WORK.APDC;
TABLE 'Report Date'n 'Day Occurred'n 'Occur Date'n 
'Occur Time'n 'Zone'n 'Crime Type'n 'NIBRS Code'n daydif ;
run;

PROC FREQ DATA=WORK.APDC;
TABLE daydif  ;
run;

PROC FREQ DATA=WORK.APDC;
TABLE 'Crime Type'n ;
run;
 
PROC FREQ DATA=WORK.APDC;
TABLE  
Zone 'Day Occurred'n ;
run;

PROC FREQ DATA=WORK.APDC;
TABLE 'NIBRS Code'n  ;
run;

/* CHARTS*/
proc gchart data=APDC;
    pie zone /type = percent discrete;
    legend;
    
proc sgplot data=APDC;
    vbar 'Day Occurred'n ;
    xaxis values=('Sunday' 'Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday');
run;

proc sgplot data=APDC;
	histogram daydif/binwidth=1 datalabel=count 
	scale=count dataskin=gloss fillattrs=(color=lightpink)
	binstart=0;
	title "Histogram of Day Difference Variable";

proc gchart data=APDC;
    pie 'Crime Type'n /type = percent discrete;
    legend;
 
PROC FREQ DATA = APDC;
    TABLES 'Day Occurred'n*'Crime Type'n;
    ODS OUTPUT CrossTabFreqs = CT;
    PROC SGPLOT DATA = CT;   *DO NOT CHANGE THIS BACK TO YOUR DATASET!!!;
    TITLE '100% Stacked Bar Chart of Day Occured by Crime';
    VBAR 'Day Occurred'n / GROUP = 'Crime Type'n RESPONSE=ROWPERCENT seglabel;
     xaxis values=('Sunday' 'Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday');
    YAXIS LABEL = 'Percent within Day Occurred'; 
    
   

  /* ON DAY OCCURED */
proc gchart data=APDC;
    vbar3d 'Day Occurred'n;
        xaxis values=('Sunday' 'Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday');
run;
quit;

proc freq data=APDC order=formatted;
	tables 'Day Occurred'n;		


proc sgplot data=APDC;
    vbar 'Day Occurred'n ;
    xaxis values=('Sunday' 'Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday');
run;

   /*Day by Crime */
    PROC FREQ DATA = APDC;
    TABLES 'Day Occurred'n*'Crime Type'n;
    ODS OUTPUT CrossTabFreqs = CT;

    PROC SGPLOT DATA = CT;   *DO NOT CHANGE THIS BACK TO YOUR DATASET!!!;
    TITLE '100% Stacked Bar Chart of Day Occured by Crime';
    VBAR 'Day Occurred'n / GROUP = 'Crime Type'n RESPONSE=ROWPERCENT seglabel;
     xaxis values=('Sunday' 'Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday');
    YAXIS LABEL = 'Percent within Day Occurred'; 
  

   /* ON DAY DIFFERENCE */
title 'Counts by Day Difference';
proc sgplot data=APDC;
  vbar daydif;
run;

proc sgplot data=APDC;
	histogram daydif/binwidth=1 datalabel=count 
	scale=count dataskin=gloss fillattrs=(color=lightpink)
	binstart=0;
	title "Histogram of Day Difference Variable";

proc gchart data=APDC;
    pie daydif /type = percent discrete;
    legend;

   /* ON CRIME TYPE */
proc gchart data=APDC;
    vbar3d 'Crime Type'n;
run;
quit;

proc gchart data=APDC;
    pie 'Crime Type'n /type = percent discrete;
    legend;

   /* Crime by Day */
PROC FREQ DATA = APDC;
    TABLES 'Crime Type'n*'Day Occurred'n;
    ODS OUTPUT CrossTabFreqs = CT;

PROC SGPLOT DATA = CT;   *DO NOT CHANGE THIS BACK TO YOUR DATASET!!!;
    TITLE '100% Stacked Bar Chart of Crime Type by Day Occurred';
    VBAR 'Crime Type'n / GROUP = 'Day Occurred'n RESPONSE=ROWPERCENT seglabel;
    YAXIS LABEL = 'Percent within Crime Type'; 





/* PRESENTATION 2
First, I want to create a categorical Variable for time and possibly date */

data APDC;
set APDC;
length 'Occur Time Cat'n $20;
	if 'Occur Time'n <'6:00:00'T then 'Occur Time Cat'n="A";
	else if '6:00:00'T<= 'Occur Time'n <'12:00:00'T then 'Occur Time Cat'n="B";
	else if '12:00:00'T<= 'Occur Time'n <'17:00:00'T then 'Occur Time Cat'n="C";
	else if 'Occur Time'n >='17:00:00'T then 'Occur Time Cat'n="D";


Proc format;
Value $timeFORMAT
'A'="Night"
'B'="Morning"
'C'="Afternoon"
'D'="Evening";
run;

data APDC;
set APDC;
format 'Occur Time Cat'n $timeFORMAT.;
run;

PROC FREQ DATA= APDC;
TABLE 'Occur Time Cat'n;
run;

/* CHI SQ TESTS */

/**	DAY OCCURRED & CRIME TYPE *****/
	proc freq data = APDC;
  	tables 'Day Occurred'n*'Crime Type'n / chisq;
	run;

	proc freq data = APDC;
 	tables 'Crime Type'n*'Day Occurred'n / chisq EXPECTED DEVIATION NOROW NOCOL NOPERCENT;
	run;

    PROC FREQ DATA = APDC;
    TABLES 'Crime Type'n*'Day Occurred'n;
    ODS OUTPUT CrossTabFreqs = CT;

	proc SGPLOT data= APDC;
	vbar 'Day Occurred'n /group = 'Crime Type'n stat=mean;
	title ‘Crime Type by Occur Time’;
	run;
	quit;
	
	/* BETTER GRAPHIC */
	/*create line plot that displays sales by day for each store*/
	title "Sales by Day by Store";
	proc sgplot data=APDC;
    styleattrs datacontrastcolors=(red green blue);
    series x='Day Occurred'n y='Occur Time Cat'n / group='Crime Type'n;
	run;
	title;
	
	

/**	OCCUR TIME CAT & DAY OCCURRED *****/

	proc freq data = APDC;
 	tables 'Occur Time Cat'n*'Day Occurred'n / chisq ;
	run;

	proc freq data = APDC;
 	tables 'Occur Time Cat'n*'Day Occurred'n / chisq EXPECTED DEVIATION NOROW NOCOL NOPERCENT;
	run;

	/*proc SGPLOT data= APDC;
	vbar 'Occur Time Cat'n /group = 'Day Occurred'n stat=mean;
	title ‘Occur Time by Day Occurred’;
	run;
	quit;*/
	
	proc SGPLOT data= APDC;
	vbar 'Day Occurred'n /group = 'Occur Time Cat'n stat=mean;
	xaxis values=('Sunday' 'Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday');
	title ‘Day Occurred by Occur Time’;
	run;
	quit;

	PROC FREQ DATA = APDC;
    TABLES 'Day Occurred'n*'Occur Time Cat'n;
    ODS OUTPUT CrossTabFreqs = CT;
    PROC SGPLOT DATA = CT;   *DO NOT CHANGE THIS BACK TO YOUR DATASET!!!;
    TITLE '100% Stacked Bar Chart of Occur Time by Day Occurred';
    VBAR 'Day Occurred'n / GROUP = 'Occur Time Cat'n RESPONSE=ROWPERCENT seglabel;
    xaxis values=('Sunday' 'Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday');
    YAXIS LABEL = 'Percent within Day Occurred'; 
    run;
    quit;

	
/**	OCCUR TIME CAT & CRIME TYPE *****/
proc freq data = APDC;
  tables 'Occur Time Cat'n*'Crime Type'n / chisq;
run;

	PROC FREQ DATA = APDC;
    TABLES'Occur Time Cat'n*'Crime Type'n;
    ODS OUTPUT CrossTabFreqs = CT;
    
    	/*	proc SGPLOT data= APDC;
		vbar 'Crime Type'n /group = 'Occur Time Cat'n stat=mean;
		title ‘Crime Type by Occur Time’;
		run;
		quit; */
	
	proc SGPLOT data= APDC;
	vbar 'Occur Time Cat'n /group = 'Crime Type'n stat=mean;
	title ‘Occur Time by Crime Type’;
	run;
	quit;

	
	PROC FREQ DATA = APDC;
    TABLES 'Occur Time Cat'n*'Crime Type'n;
    ODS OUTPUT CrossTabFreqs = CT;
    PROC SGPLOT DATA = CT;   *DO NOT CHANGE THIS BACK TO YOUR DATASET!!!;
    TITLE '100% Stacked Bar Chart of Occur Time by Crime';
    VBAR 'Occur Time Cat'n / GROUP = 'Crime Type'n RESPONSE=ROWPERCENT seglabel;
    YAXIS LABEL = 'Percent within Occur Time'; 


