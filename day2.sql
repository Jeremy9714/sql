#连接查询
#一.等值连接

#查询女性对应男友名
SELECT * FROM beauty;
SELECT * FROM boys;

SELECT 
  NAME,
  boyName 
FROM
  beauty,
  boys 
WHERE beauty.`boyfriend_id` = boys.`id` ;

#查询员工名和对应的部门名
SELECT 
  last_name,
  department_name 
FROM
  employees,
  departments 
WHERE employees.`department_id` = departments.department_id ;

#为表起别名
#查询员工名，工种号和工种名
SELECT 
  last_name,
  e.job_id,
  job_title 
FROM
  employees e,
  jobs j 
WHERE e.`job_id` = j.`job_id` ;

#添加筛选条件
#有奖金的员工名和部门名
SELECT 
  last_name,
  department_name 
FROM
  employees e,
  departments d 
WHERE e.`department_id` = d.`department_id` 
  AND commission_pct IS NOT NULL ;

#查询城市名中第二个字符为o的部门名和城市名
SELECT 
  department_name 部门名,
  city 城市名
FROM
  locations l,
  departments d 
WHERE d.`location_id` = l.`location_id` 
  AND city LIKE '_o%' ;

#增加分组
#查询每个城市的部门个数
SELECT 
  COUNT(*) 个数,
  city 
FROM
  departments d,
  locations l 
WHERE d.`location_id`=l.`location_id`
GROUP BY city ;

#查询有奖金的每个部门的部门名和部门的领导编号还有该部门的最低工资
SELECT 
  MIN(salary) 最低工资,
  department_name,
  d.manager_id 
FROM
  departments d,
  employees e 
WHERE e.`department_id` = d.`department_id` 
AND commission_pct IS NOT NULL
GROUP BY department_name,d.manager_id;

#排序
#查询每个工种的工种名和员工个数，并且按员工各个数降序
SELECT 
  job_title,
  COUNT(*) 员工个数 
FROM
  jobs j,
  employees e 
WHERE e.`job_id` = j.`job_id` 
GROUP BY job_title 
ORDER BY 员工个数 DESC ;

#三标连接
#查询员工名，部门名和所在的城市
SELECT 
  last_name,
  department_name,
  city 
FROM
  employees e,
  departments d,
  locations l 
WHERE e.`department_id` = d.`department_id` 
  AND d.`location_id` = l.`location_id` 
AND city LIKE 'S%'
ORDER BY department_name DESC;

#非等值连接
#查询员工的工资和工资级别
CREATE TABLE job_grades (
  grade_level VARCHAR (3),
  lowest_sal INT,
  highest_sal INT
) ;

INSERT INTO job_grades
VALUES ('A',1000,2999);

INSERT INTO job_grades
VALUES ('B',3000,5999);

INSERT INTO job_grades
VALUES ('C',6000,9999);

INSERT INTO job_grades
VALUES ('D',10000,14999);

INSERT INTO job_grades
VALUES ('E',15000,24999);

INSERT INTO job_grades
VALUES ('F',25000,40000);

SELECT 
  salary,
  grade_level 
FROM
  employees e,
  job_grades j 
WHERE salary BETWEEN lowest_sal 
  AND highest_sal 
  AND grade_level = 'a' 
ORDER BY salary ASC ;

#自连接
#查询员工名和领导的名称
SELECT 
  e.employee_id,
  e.last_name,
  m.employee_id 领导名,
  m.last_name 领导id 
FROM
  employees e,
  employees m 
WHERE e.`manager_id` = m.employee_id ;

#sql99
#等值连接、非等值连接和自连接 inner可以省略
#查询员工名、部门名
SELECT 
  last_name,
  department_name 
FROM
  employees e 
  INNER JOIN departments d 
    ON e.`department_id` = d.`department_id` ;

#查询名字中包含e的员工名和工种名
SELECT 
  last_name,
  job_title 
FROM
  employees e 
  INNER JOIN jobs j 
    ON e.`job_id` = j.`job_id` 
WHERE last_name LIKE '%e%' ;

#查询部门个数大于3的城市名和部门个数
SELECT 
  city,
  COUNT(*) 部门个数 
FROM
  locations l 
  INNER JOIN departments d 
    ON l.`location_id` = d.`location_id` 
GROUP BY city 
HAVING 部门个数 > 3 ;

#查询员工个数>3的部门名和员工个数，并按个数降序
SELECT 
  department_name,
  COUNT(*) 员工个数 
FROM
  departments d 
  INNER JOIN employees e 
    ON d.`department_id` = e.`department_id` 
GROUP BY department_name 
HAVING 员工个数 > 3 
ORDER BY 员工个数 DESC ;

#查询员工名、部门名、工种名，并按部门名降序
SELECT 
  last_name,
  department_name,
  job_title 
FROM
  employees e 
  JOIN departments d 
    ON e.`department_id` = d.`department_id` 
  JOIN jobs j 
    ON e.`job_id` = j.`job_id` 
GROUP BY department_name,
  job_title 
ORDER BY department_name DESC ;

#查询员工的工资等级
SELECT 
  salary,
  grade_level 
FROM
  employees e 
  JOIN job_grades j 
    ON e.`salary` BETWEEN lowest_sal 
    AND highest_sal ;

#查询工资级别个数大于20的个数，并且按照工资级别降序，
SELECT 
  salary,
  grade_level,
  COUNT(*) 员工个数 
FROM
  employees e 
  JOIN job_grades j 
    ON e.`salary` BETWEEN lowest_sal 
    AND highest_sal 
GROUP BY grade_level 
HAVING 员工个数 > 20 
ORDER BY grade_level DESC ;

#查询姓名中包含字符k的员工的名字、领导的名字
SELECT 
  e.last_name 职员姓名,
  m.last_name 领导姓名 
FROM
  employees e 
  JOIN employees m 
    ON e.manager_id = m.`employee_id` 
WHERE e.last_name LIKE '%k%' ;

#外连接=内连接结果+主表中有从表中没有的

#左外连接和右外连接
#查询没有男朋友的女性姓名
SELECT 
  NAME
FROM
  beauty g 
  LEFT JOIN boys b 
    ON boyFriend_id = b.`id`
WHERE b.id IS NULL;

#查询哪个部门没有员工
#左外连接
SELECT 
  d.*,e.`employee_id` 
FROM
  departments d 
  LEFT JOIN employees e 
    ON d.`department_id` = e.`department_id` 
WHERE e.`employee_id` IS NULL ;
#右外连接
SELECT 
  d.*,e.`employee_id` 
FROM
  employees e 
  RIGHT JOIN departments d 
    ON d.`department_id` = e.`department_id` 
WHERE e.`employee_id` IS NULL ;

#全外连接=内连接的结果+表一中有表二中没有的+表二中有表一中没有的
#交叉连接
USE girls;
SELECT 
  b.*,
  bo.* 
FROM
  beauty b 
  CROSS JOIN boys bo ;

#子查询
#where或having后面，一般为标量子查询(结果集一行一列)，列子查询(结果集一行多列)和行子查询(结果集一列多行)(较少使用)
#谁的工资比Abel高
#标量子查询
#1.查找Abel的工资
SELECT 
  salary 
FROM
  employees 
WHERE last_name = 'Abel' ;

#2.查询员工的信息，满足salary>结果1
SELECT 
  *
FROM
  employees 
WHERE salary > 
  (SELECT 
    salary 
  FROM
    employees 
  WHERE last_name = 'Abel') 
  ORDER BY salary ASC;

#返回员工类型与141号员工相同，工资比143号员工多的员工姓名、员工类型和工资
SELECT 
  last_name,
  job_id,
  salary 
FROM
  employees 
WHERE job_id = 
  (SELECT 
    job_id 
  FROM
    employees 
  WHERE employee_id = 141) 
  AND salary > 
  (SELECT 
    salary 
  FROM
    employees 
  WHERE employee_id = 143) 
  ORDER BY salary ASC;

#返回公司中工资最少的员工的姓名、员工类型和工资
SELECT 
  last_name,
  job_id,
  salary 
FROM
  employees 
WHERE salary = 
  (SELECT 
    MIN(salary) 
  FROM
    employees) ;

#查询最低工资大于50号部门最低工资的部门id和其最低工资
SELECT 
  department_id,
  MIN(salary) 最低薪水 
FROM
  employees 
GROUP BY department_id 
HAVING 最低薪水 > 
  (SELECT 
    MIN(salary) 
  FROM
    employees 
  WHERE department_id = 50) 
ORDER BY 最低薪水 ASC ;

#列子查询
#返回location_id是1400或1700的部门中的所有员工姓名
#1.查询location_id是1400或1700的部门 2.所有员工的姓名
SELECT 
  last_name 
FROM
  employees 
WHERE department_id IN 
  (SELECT 
    department_id 
  FROM
    departments 
  WHERE location_id IN (1400, 1700)) ;

#返回其他工种中比job_id为'IT_PROG'中任意员工的工资低的员工号、姓名、job_id和工资
SELECT 
  employee_id,
  last_name,
  job_id,
  salary 
FROM
  employees 
WHERE salary < ANY 
  (SELECT 
    DISTINCT salary 
  FROM
    employees 
  WHERE job_id = 'IT_PROG') 
  AND job_id <> 'IT_PROG' ;
  
SELECT 
  employee_id,
  last_name,
  job_id,
  salary 
FROM
  employees 
WHERE salary < 
  (SELECT DISTINCT 
    MAX(salary) 
  FROM
    employees 
  WHERE job_id = 'IT_PROG') 
  AND job_id <> 'IT_PROG' ;

#返回其他工种中比job_id为'IT_PROG'中所有员工的工资低的员工号、姓名、job_id和工资
SELECT 
  employee_id,
  last_name,
  job_id,
  salary 
FROM
  employees 
WHERE salary < ALL 
  (SELECT 
    DISTINCT salary 
  FROM
    employees 
  WHERE job_id = 'IT_PROG') 
  AND job_id <> 'IT_PROG' 
  ORDER BY salary DESC;
  
#行子查询
#查询员工编号最小且工资最高的员工信息
SELECT 
  * 
FROM
  employees 
WHERE employee_id = 
  (SELECT 
    MIN(employee_id) 
  FROM
    employees) 
  AND salary = 
  (SELECT 
    MAX(salary) 
  FROM
    employees) ;
#当查找条件都使用相同的操作符时，可以使用行子查询如下
SELECT 
  * 
FROM
  employees 
WHERE (employee_id, salary) = 
  (SELECT 
    MIN(employee_id),
    MAX(salary) 
  FROM
    employees) ;

#select后面的子查询
#查询每个部门的员工个数 
SELECT 
  d.*,
  (SELECT 
    COUNT(*) 
  FROM
    employees e 
  WHERE e.department_id = d.department_id) 个数
FROM
  employees d ;
  
#查询员工号等于102的部门名
SELECT 
  (SELECT 
    department_name 
  FROM
    departments d 
    INNER JOIN employees e 
      ON d.`department_id` = e.`department_id` 
  WHERE employee_id = 102) 部门名 ;

#from后面的子查询
#查询每个部门的的平均工资的工资等级
SELECT 
  avg_dep.*,
  grade_level 
FROM
  (SELECT 
    AVG(salary) 平均工资,
    department_id 
  FROM
    employees 
  GROUP BY department_id) avg_dep 
  INNER JOIN job_grades 
    ON 平均工资 BETWEEN lowest_sal 
    AND highest_sal ;

#exists后面的子查询(相关子查询),用于判断资产寻是否有值
SELECT EXISTS(SELECT employee_id FROM employees) 是否有值;
SELECT EXISTS(SELECT salary FROM employees WHERE salary>40000) 是否有值;

#查询有员工的部门名
SELECT 
  department_name 
FROM
  departments d 
WHERE EXISTS 
  (SELECT 
    * 
  FROM
    employees e 
  WHERE e.`department_id` = d.`department_id`) ;

SELECT 
  department_name 
FROM
  departments 
WHERE department_id IN 
  (SELECT 
    department_id 
  FROM
    employees) ;

#查询没有女朋友的男性信息
SELECT EXISTS(SELECT bo.* FROM boys bo WHERE bo.id NOT IN(SELECT boyfriend_id FROM beauty)) 是否存在答案;

SELECT bo.* FROM boys bo WHERE EXISTS(SELECT boyfriend_id FROM beauty b WHERE bo.id = b.`boyfriend_id`);

#查询和Zlotkey相同部门的员工姓名和工资
SELECT 
  last_name,
  salary,
  department_id 
FROM
  employees 
WHERE department_id = 
  (SELECT 
    department_id 
  FROM
    employees 
  WHERE last_name = 'zlotkey') 
  AND last_name <> 'zlotkey' ;

#查询工资比公司平均工资高的员工的员工号、姓名和工资
SELECT 
  employee_id,
  last_name,
  salary 
FROM
  employees 
WHERE salary > 
  (SELECT 
    AVG(salary) 
  FROM
    employees) ;

#查询各部门中工资比本部门平均工资高的员工的员工号、姓名和工资
SELECT 
  employee_id,
  last_name,
  salary 
FROM
  employees e 
  INNER JOIN 
    (SELECT 
      AVG(salary) 平均工资,
      department_id 
    FROM
      employees 
    GROUP BY department_id) avg_dep 
    ON e.`department_id` = avg_dep.department_id 
WHERE salary > avg_dep.平均工资 ;

#查询和姓名中包含字母u的员工在相同部门的员工的员工号和姓名
SELECT 
  employee_id,
  last_name 
FROM
  employees 
WHERE department_id IN 
  (SELECT DISTINCT 
    department_id 
  FROM
    employees 
  WHERE last_name LIKE '%u%') ;

#查询在部门的location_id为1700的部门工作的员工的员工号
SELECT 
  employee_id
FROM
  employees 
WHERE department_id IN 
  (SELECT 
    DISTINCT department_id 
  FROM
    departments 
  WHERE location_id = 1700) ;

#查询管理者是K_ing的员工姓名和工资
SELECT 
  last_name,
  salary
FROM
  employees 
WHERE manager_id = ANY 
  (SELECT 
    employee_id 
  FROM
    employees 
  WHERE last_name = 'K_ing') ;

#查询工资最高的员工的姓名，要求姓和名显示为一列，列名为姓，名
SELECT 
  CONCAT(first_name, ' ', last_name) 
FROM
  employees 
WHERE salary = 
  (SELECT 
    MAX(salary)
  FROM
    employees) ;

#分页查找(limit offset, size)
#查询前五条员工信息
SELECT 
  * 
FROM
  employees 
LIMIT 5 ;

#查询第11-25条员工信息
SELECT * FROM employees LIMIT 10, 15;

#查询有奖金的员工里，工资较高的前十名员工的信息
SELECT * FROM employees WHERE commission_pct IS NOT NULL ORDER BY salary DESC LIMIT 10;

#union联合查询
#查询部门编号大于90或邮箱包含a的员工信息
SELECT * FROM employees WHERE department_id>90 OR email LIKE '%a%';
#使用union
SELECT * FROM employees WHERE department_id >90
UNION
SELECT * FROM employees WHERE email LIKE '%a%';

