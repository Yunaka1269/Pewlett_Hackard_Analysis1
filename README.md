# Pewlett_Hackard_Analysis

##Using SQL query to create tables for determining the number of retiring employees by title and for identifying the number of employees who are eligible to participate in a mentorship program.

####Result

-Attached is [retire ready employee list with title](https://github.com/Yunaka1269/Pewlett_Hackard_Analysis1/blob/main/Data/retirement_titles.csv). Because of switching the titles over years, there are duplicate entries in database for some employees.
-Attached shows [retire ready employee list with current/unique title](https://github.com/Yunaka1269/Pewlett_Hackard_Analysis1/blob/main/Data/unique_titles.csv). DISTINCT ON statement is used to remove the duplicate entries ORDER BY emp_no ASC and from_date DESC. 
-see [the number of retire-ready employees breakdown by the tile](https://github.com/Yunaka1269/Pewlett_Hackard_Analysis1/blob/main/Data/retiring_title.csv). There are total of 90,398 retirement-ready employees who were born between Jan 1,1952 and Dec 31, 1955. 
-Attached is [the list of employees who are eligible to participate in mentorship program](https://github.com/Yunaka1269/Pewlett_Hackard_Analysis1/blob/main/Data/mentorship_eligibility.csv). The qualified amployees are filtered based on their birth date between Jan 1,1965 and Dec 31, 1965.

####Resources
-Data Source
	-departmments.csv
	-dept_emp.csv
	-dept_manager.csv
	-employees.csv
	-salaries.csv
	-titles.csv

-Software
	-postgresql 12.4.1
	-pgAdmin version 4.24
  
##Summary
See [the number of mentorship qualified employees by title](). There are total of 1,549 qualified employees, who were born in the year 1965, eligible to participate for the mentorship program. This is not sufficient number to fill in the roles in near future. Even if "silver tsunami" eligibility is changed to the employees whose birth dates are between Jan 1, 1962 and Dec 31, 1965, the number of eligible employees changes to 56,859 which is about 63% of retire-ready employees. Currently, male-female ratio is 60%:40%. This ratio is the same for the retire-ready employees. I do suggest Pewlett_Hackard to actively hire female candidates to fill in position. Although the average salary seems weird for title hierarchy, I found male and female average salary are almost even except Manager title ($8,000 less in female).  
