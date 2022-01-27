CREATE TEMP VIEW orderlyGPA AS 
SELECT sid, qtr, year, avg(grade) AS gpa 
FROM record 
GROUP BY sid, year, qtr 
--ORDER BY sid, year, qtr desc;
ORDER BY qtr desc;

CREATE TEMP VIEW po AS
SELECT DISTINCT laterOne.sid 
FROM orderlyGPA laterOne, orderlyGPA previousOne --previousOne is the previous one
WHERE laterOne.sid = previousOne.sid 
AND laterOne.gpa > previousOne.gpa 
AND (
(laterOne.year < previousOne.year) --后面大于前面,按理说后面的year应该大于前面的year,但却小于,所以不行
OR
(laterOne.year = previousOne.year AND laterOne.qtr > previousOne.qtr) --后面大于前面,按理说后面的qtr应该小于前面的qtr,但却大于,所以也不行
)
GROUP BY laterOne.sid;
--W later F
SELECT DISTINCT later.sid 
FROM orderlyGPA later, orderlyGPA previous --previous is the previous one
WHERE later.sid = previous.sid 
AND later.gpa >= previous.gpa 
AND (
(later.year = previous.year AND later.qtr < previous.qtr)  --condition 1
OR
(later.year > previous.year)  --condition 2
)

AND later.sid not in (SELECT DISTINCT laterOne.sid 
FROM orderlyGPA laterOne, orderlyGPA previousOne --previousOne is the previous one
WHERE laterOne.sid = previousOne.sid 
AND laterOne.gpa > previousOne.gpa 
AND laterOne.year < previousOne.year --后面大于前面,按理说后面的year应该大于前面的year,但却小于,所以不行
GROUP BY laterOne.sid)

AND later.sid not in (SELECT DISTINCT laterOne.sid 
FROM orderlyGPA laterOne, orderlyGPA previousOne --previousOne is the previous one
WHERE laterOne.sid = previousOne.sid 
AND laterOne.gpa > previousOne.gpa 
AND laterOne.year = previousOne.year AND laterOne.qtr > previousOne.qtr --后面大于前面,按理说后面的qtr应该小于前面的qtr,但却大于,所以也不行
GROUP BY laterOne.sid)

GROUP BY later.sid

UNION

SELECT DISTINCT later.sid
FROM orderlyGPA later
GROUP BY later.sid
HAVING COUNT(later.sid) = 1
