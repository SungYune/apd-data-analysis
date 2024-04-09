/* IMPORT PREPROCESSED DATA */

%web_drop_table(WORK.APDC);

FILENAME REFFILE '/home/u63645806/Spring2024 DATA4000/APD_CrimeData_ver2.xlsx';

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

/* PROC FREQ DATA=WORK.APDC; */
/* TABLE 'Report Date'n 'Day Occurred'n 'Occur Date'n  */
/* 'Occur Time'n 'Zone'n 'Crime Type'n daydif ; run; */
/* 'NIBRS Code'n */

PROC FREQ DATA=WORK.APDC;
TABLE daydif  ;
run;

PROC FREQ DATA=WORK.APDC;
TABLE  
Zone 'Day Occurred'n ;
run;

/* PROC FREQ DATA=WORK.APDC; */
/* TABLE 'NIBRS Code'n  ; */
/* run; */

/* CHARTS*/
proc gchart data=APDC;
    pie zone /type = percent discrete;
    legend;
        title "Figure 4: Pie Chart of Crime Rates per Zone";
    
proc sgplot data=APDC;
    vbar 'Day Occurred'n ;
    xaxis values=('Sunday' 'Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday');
run;

proc sgplot data=APDC;
	histogram daydif/binwidth=1 datalabel=count 
	scale=count dataskin=gloss fillattrs=(color=lightpink)
	binstart=0;
	title "Figure 3: Histogram of Day Difference Variable (count)";
	
proc sgplot data=APDC;
	histogram daydif/binwidth=1 datalabel=percent
	scale=percent dataskin=gloss fillattrs=(color=steelblue)
	binstart=0;
	title "Figure 3: Histogram of Day Difference Variable (percent)";

proc gchart data=APDC;
    pie 'Crime Type'n /type = percent discrete descending;
    legend;
    title "Figure 2: Pie Chart of Crime Type";

 
PROC FREQ DATA = APDC;
    TABLES 'Day Occurred'n*'Crime Type'n;
    ODS OUTPUT CrossTabFreqs = CT;
    PROC SGPLOT DATA = CT;   *DO NOT CHANGE THIS BACK TO YOUR DATASET!!!;
    TITLE 'Figure 1: 100% Stacked Bar Chart of Day Occured by Crime';
    VBAR 'Day Occurred'n / GROUP = 'Crime Type'n RESPONSE=ROWPERCENT seglabel;
     xaxis values=('Sunday' 'Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday');
    YAXIS LABEL = 'Percent within Day Occurred'; 

   ON DAY OCCURED
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
/* Is line 103~111 supposed to be the same code with line 77~84? */

   /* ON DAY DIFFERENCE */
title 'Counts by Day Difference';
proc sgplot data=APDC;
  vbar daydif;
run;

proc sgplot data=APDC;
	histogram daydif/binwidth=1 datalabel=count 
	scale=count dataskin=gloss fillattrs=(color=lightpink)
	binstart=0;
	title "Figure 3: Histogram of Day Difference Variable (count)";
	
proc sgplot data=APDC;
	histogram daydif/binwidth=1 datalabel=percent
	scale=percent dataskin=gloss fillattrs=(color=steelblue)
	binstart=0;
	title "Figure 3: Histogram of Day Difference Variable (percent)";


/*********** INTERPRETATIONS UNNECCESSARY ***********/
/* proc gchart data=APDC; */
/*     pie daydif /type = percent discrete; */
/*     legend; */

   /* ON CRIME TYPE */
proc gchart data=APDC;
    vbar 'Crime Type'n;
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