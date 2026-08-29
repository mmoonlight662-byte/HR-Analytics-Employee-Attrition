                         
                         ---- Workforce Analysis ----

--1.Employee Count by Department
Select COUNT(EmpID) AS TotalEmployees,
Department
From HR_Analytics
Group by Department

--2.Employee Count by Job Role
Select COUNT(EmpID) AS TotalEmployees,
JobRole
From HR_Analytics
Group by JobRole

--3.Employee Distribution by Salary Slab
Select COUNT(EmpID) AS TotalEmployees,
SalarySlab
From HR_Analytics
Group by SalarySlab

                         ---- Compensation Analysis ----
 
--4.Average Monthly Income by Job Role
Select COUNT(EmpID) AS TotalEmployees,
JobRole,
AVG(MonthlyIncome) AS AverageMonthlyIncome
From HR_Analytics
Group by JobRole
Having COUNT(EmpID)>=10
Order by AverageMonthlyIncome DESC

--5.Average Monthly Income by Department
Select Department,
AVG(MonthlyIncome) AS AverageMonthlyIncome
From HR_Analytics
Group by Department
Order by AverageMonthlyIncome DESC

--6.Employees Above Company Average
Select EmpID, 
Department,
JobRole,
MonthlyIncome From HR_Analytics
Where MonthlyIncome>(Select AVG(MonthlyIncome) From HR_Analytics) 
Order by MonthlyIncome DESC

                        ---- Attrition Analysis ----

--7.Attrition by Department
Select COUNT(EmpID) AS TotalEmployees,
Department,
Round(Sum(Case When Attrition = 'Yes' then 1 else 0 END)*100.0/COUNT(EmpID),2) AS AttritionRate
From HR_Analytics
Group by Department
Order by AttritionRate DESC

--8.Attrition by Salary Slab
Select COUNT(EmpID) AS TotalEmployees,
SalarySlab,
Round(Sum(Case When Attrition = 'Yes' then 1 else 0 END)*100.0/COUNT(EmpID),2) AS AttritionRate
From HR_Analytics
Group by SalarySlab
Order by AttritionRate DESC

--9.Attrition by Job Role
Select COUNT(EmpID) AS TotalEmployees,
JobRole,
Round(Sum(Case When Attrition = 'Yes' then 1 else 0 END)*100.0/COUNT(EmpID),2) AS AttritionRate
From HR_Analytics
Group by JobRole
Order by AttritionRate DESC

--10.Overtime vs Attrition
Select OverTime,
COUNT(EmpID) AS TotalEmployees,
Round(Sum(Case When Attrition = 'Yes' then 1 else 0 END)*100.0/COUNT(EmpID),2) AS AttritionRate
From HR_Analytics
Group by OverTime
Order by AttritionRate DESC

--11.Years at Company vs Attrition
Select YearsAtCompany,
COUNT(EmpID) AS TotalEmployees,
Round(Sum(Case When Attrition = 'Yes' then 1 else 0 END)*100.0/COUNT(EmpID),2) AS AttritionRate
From HR_Analytics
Group by YearsAtCompany
Order by AttritionRate DESC

                                ----Advanced Analysis ----

--12.Top 3 Earners in Each Department
With RankedEmployee As(
Select EmpID,  
Department,
JobRole,
MonthlyIncome, 
Dense_Rank() Over(Partition by Department Order by MonthlyIncome DESC) as Income_rnk 
From HR_Analytics) 
Select EmpID,  
Department, 
JobRole,
MonthlyIncome, 
Income_rnk
From RankedEmployee 
Where income_rnk<=3  
Order by MonthlyIncome DESC;

--13.Employees Above Department Average
With DepartAvgIncome AS(
Select EmpID,
Department,
JobRole,
MonthlyIncome,
AVG(MonthlyIncome) Over(Partition by Department) As DepartAverageIncome
From HR_Analytics)
Select EmpID,
Department,
JobRole,
MonthlyIncome,
Round(DepartAverageIncome,2) as DepartAverageIncome
From DepartAvgIncome
Where MonthlyIncome>DepartAverageIncome
Order by DepartAverageIncome DESC

--14.Employees Earning More Than 2× Department Average
With DeptAvg AS(
Select EmpID,
Department,
JobRole,
MonthlyIncome,
AVG(MonthlyIncome) Over(Partition by Department)*2 as TwiceDeptAverage
From HR_Analytics)
Select EmpID, 
Department,
JobRole,
MonthlyIncome, 
Round(TwiceDeptAverage,2) as TwiceDeptAverage
From DeptAvg
Where MonthlyIncome > TwiceDeptAverage
Order by MonthlyIncome DESC

--15.HR Priority Departments
With OverallCompanyBenchmarks as(                -- CTE 1. calculate Global Company-Wide benchmarks
Select Sum(Case When Attrition = 'Yes' then 1 else 0 END)*100.0/COUNT(EmpID) AS OverallCompanyAttritionRate,
AVG(MonthlyIncome) As OverallCompanyMonthlyIncome 
From HR_Analytics), 
DepartmentBenchMarks as(                         -- CTE 2. Calculate Local metrics for each Department 
Select Department, COUNT(EmpID) AS TotalEmployee, 
Sum(Case When Attrition = 'Yes' then 1 else 0 END) AS EmployeeLeft,
Sum(Case When Attrition = 'Yes' then 1 else 0 END)*100.0/COUNT(EmpID) AS DepartmentAttritionRate, 
AVG(MonthlyIncome) As DepartmentAverageMonthlyIncome 
From HR_Analytics
Group by Department ) 
Select d.Department,                             -- 3. Main Query 
d.TotalEmployee, 
d.EmployeeLeft, 
d.DepartmentAttritionRate as DepartmentAttritionRate, 
c. OverallCompanyAttritionRate as OverallCompanyAttritionRate,
d.DepartmentAverageMonthlyIncome,
c.OverallCompanyMonthlyIncome
From DepartmentBenchMarks d 
Cross join OverallCompanyBenchmarks c 
Where d.DepartmentAttritionRate>c.OverallCompanyAttritionRate       -- Condition 1 
AND d.DepartmentAverageMonthlyIncome<c.OverallCompanyMonthlyIncome  -- Condition 2 
Order by DepartmentAttritionRate DESC



