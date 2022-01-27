create view SortGrade as select sid, qtr, year, avg(grade) as gpa from record group by year, qtr, sid order by sid, year, qtr desc;
select distinct s.sid from SortGrade s join SortGrade g on s.sid = g.sid and s.gpa > g.gpa and ((s.year < g.year) or (s.year = g.year and s.qtr < g.qtr)) and s.sid not in (select distinct r.sid from SortGrade r join SortGrade t on r.sid = t.sid and r.gpa > t.gpa and (r.year < t.year) group by r.sid) group by s.sid;


