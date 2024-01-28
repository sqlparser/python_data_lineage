-- redshift sample sql
Create table sales(
	dateid int,
	venuestate char(80),
	venuecity char(40),
	venuename char(100),
	catname char(50),
	Qtr int,
	qtysold int,
	pricepaid int,
	Year date
);

insert into t2 
SELECT qtr, 
       Sum(pricepaid)           AS qtrsales, 
       (SELECT Sum(pricepaid) 
        FROM   sales 
               JOIN date 
                 ON sales.dateid = date.dateid 
        WHERE  qtr = '1' 
               AND year = 2008) AS q1sales 
FROM   sales 
       JOIN date 
         ON sales.dateid = date.dateid 
WHERE  qtr IN( '2', '3' ) 
       AND year = 2008 
GROUP  BY qtr 
ORDER  BY qtr; 


