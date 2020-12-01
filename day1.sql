/*
select 字段 from 查询列表
*/

USE myemployees;

#1.查询表中的单个字段
SELECT last_name FROM employees;

#2.查询表中的多个字段
SELECT last_name,salary,email FROM employees;

#3.查询表中的所有字段
#方法一
SELECT 
  `employee_id`,
  `first_name`,
  `last_name`,
  `email`,
  `phone_number`,
  `job_id`,
  `salary`,
  `commission_pct`,
  `manager_id`,
  `department_id`,
  `hiredate` 
FROM
  employees ;
#方法二
SELECT * FROM employees;

#4.查询常量值
SELECT 100;
SELECT 'john';

#5.查询表达式
SELECT 100%98;

#6.查询函数
SELECT VERSION();

#起别名
SELECT 100*2 AS 结果;
SELECT last_name AS 姓, first_name AS 名 FROM employees;
SELECT employee_id 编号 FROM employees;
SELECT 100*3 'out put';

#去重
SELECT DISTINCT department_id FROM departments;

#运算符+号
#尝试将字符转换为数值，转换失败则为0
SELECT last_name+first_name AS result FROM employees;
SELECT '100'+department_id AS result FROM departments;
#只要有一方为null，则结果为null
SELECT NULL+100;

#concat函数
SELECT CONCAT(last_name,first_name) AS 姓名 FROM employees;

#desc 用于显示表的结构
DESC departments;

#ifnull函数 用于判断字段值是否为null
SELECT IFNULL(commission_pct,0)AS奖金率,commission_pct FROM employees;
SELECT 
  CONCAT(first_name,
  ',',
  last_name,
  ',',
  IFNULL(commission_pct, 0)) AS out_put FROM employees ;

#按条件表达式筛选
SELECT 
  * 
FROM
  employees 
WHERE salary > 12000 ;

#查询部门编号不为90的员工的部门编号和姓名
SELECT 
  department_id,
  CONCAT(last_name, ' ', first_name) 
FROM
  employees 
WHERE department_id <> 90 ;

#查询薪水在10000和20000之间的员工姓名、薪水和奖金率
#方法一
SELECT 
  last_name,
  salary,
  commission_pct 
FROM
  employees 
WHERE salary >= 10000 
  AND salary <= 20000 ;
#方法二
SELECT 
  last_name,
  salary,
  commission_pct 
FROM
  employees 
WHERE salary BETWEEN 10000 
  AND 20000 ;

#查询部门编号不在90和100之间或者薪水大于10000的员工信息
SELECT 
  * 
FROM
  employees 
WHERE NOT (
    department_id >= 90 
    AND department_id <= 110
  ) 
  OR salary > 10000 ;
  
#查询员工名中包含字符a的员工信息
SELECT 
  * 
FROM
  employees 
WHERE last_name LIKE '%a%' ;

#查询员工名中第三个字符为a，第五个字符为e的员工姓名和薪水
SELECT 
  last_name,
  salary 
FROM
  employees 
WHERE last_name LIKE '__a_e%' ;

#查询员工名中第三个字符为_的员工名
#方法一
SELECT 
  last_name 
FROM
  employees 
WHERE last_name LIKE '_\_%' ;
#方法二 使用escape定义转义字符
SELECT 
  last_name 
FROM
  employees 
WHERE last_name LIKE '_&_%' ESCAPE '&' ;

#查询员工的工种编号是IT_PROG、AD_VP或AD_PRES的员工名和工种编号
#方法一
SELECT 
  last_name,
  job_id 
FROM
  employees 
WHERE job_id = 'IT_PROG' 
  OR job_id = 'AD_VP'
  OR job_id = 'AD_PRES' ;

#方法二
SELECT 
  last_name,
  job_id 
FROM
  employees 
WHERE job_id IN ('IT_PROG', 'AD_VP', 'AD_PRES') ;

#查询员工奖金率为null的员工名和奖金率
#方法一
SELECT 
  last_name,
  commission_pct 
FROM
  employees 
WHERE commission_pct IS NULL ;
#方法二 安全等于<=>
SELECT 
  last_name,
  commission_pct 
FROM
  employees 
WHERE commission_pct <=> NULL ;

#查询员工工资等于12000的员工名和工资
SELECT 
  last_name,
  salary 
FROM
  employees 
WHERE salary <=> 12000 ;
 
#排序筛选 order by 排序列表[asc|desc](升序、降序) 默认升序
#查询员工信息，要求工资从高到低排序
SELECT 
  * 
FROM
  employees 
ORDER BY salary DESC ;

#查询员工信息，要求部门编号>=90.并且入职日期从早到晚排序
SELECT 
  * 
FROM
  employees 
WHERE department_id >= 90 
ORDER BY hiredate ASC ;

#按照年薪的高低显示员工的信息和年薪
SELECT 
  *,
  salary * 12 * (1+ IFNULL(commission_pct, 0)) 年薪 
FROM
  employees 
ORDER BY 年薪 DESC ;

#按员工姓名的字节长度显示员工的姓名和工资
SELECT 
  LENGTH(last_name) 字节长度,
  last_name,
  salary 
FROM
  employees 
ORDER BY 字节长度 DESC;

#查询员工信息，要求先按工资升序，再按员工编号降序
SELECT 
  * 
FROM
  employees 
ORDER BY salary ASC,
  employee_id DESC ;

#一.字节函数
#获取参数值的字节个数
SELECT LENGTH("这是一句话");
SHOW VARIABLES LIKE '%char%';

SELECT 
  CONCAT(last_name, '_', first_name) 姓名 
FROM
  employees ;

#upper,lower
SELECT UPPER('john');
SELECT LOWER('johN');

#函数中可以嵌套函数
#将姓变成大写，将名变成小写
SELECT 
  CONCAT(
    UPPER(last_name),
    '_',
    LOWER(first_name)
  ) 
FROM
  employees ;
 
#substr,substring
#截取从指定索引处后面所有字符
SELECT SUBSTR('这是一句九个字的话',2) output;
#截取从指定索引处指定长度的字符
SELECT SUBSTRING('这是一句九个字的话',2,5) output;

#姓名中首字母大写，其他字母小写，然后用'_'进行拼接
SELECT 
  CONCAT(
    UPPER(SUBSTR(Last_name, 1, 1)),
    '_',
    LOWER(SUBSTR(first_name, 1))
  ) 
FROM
  employees ;
  
#instr用于返回子串在字符串中第一次出现的索引，找不到则返回0
SELECT 
  INSTR('只是一句话', '一句话') AS out_put ;

#trim用于去除字符串前后字符
SELECT 
  TRIM('    没有空格    ') AS out_put ;
  
SELECT 
  TRIM(
    'a' FROM 'aaaaaa没有空格aaaaa在这句话里aaa'
  ) AS out_put ;

#lpad、rpad用指定字符左、右填充至指定长度
SELECT 
  LPAD('只是一句话', 10, '%') AS out_put ;

SELECT 
  RPAD('只是一句话', 10, '%') AS out_put ;

#replace替换
SELECT 
  REPLACE(
    '第一条字符串依然是第一条字符串',
    '一',
    '二'
  ) AS out_put ;

#二.数学函数
#round四舍五入，可以指定保留的小数位数
SELECT ROUND(-1.55);
SELECT ROUND(1.467,2);

#ceil向上取正，floor向下取整
SELECT CEIL(-1.2);
SELECT FLOOR(-1.9);

#truncate截断,保留指定位数的小数
SELECT TRUNCATE(1.695,1);

#mod取余
SELECT MOD(10,-3);

#三.时间函数
#now返回当前系统时间+日期
SELECT NOW();

#curdate返回当前日期
SELECT CURDATE();

#curtime返回当前时间
SELECT CURTIME();

#可以获取指定的部分，年月日时分秒
SELECT YEAR(NOW()) 年,MONTH(NOW()) 月,SECOND(NOW()) 秒;
SELECT MONTHNAME(NOW()) 月份;
SELECT DAYNAME('1997-07-14') 日;
SELECT YEAR('1997-07-14') 年;
SELECT YEAR(hiredate) 年 FROM employees;

#str_to_date将日期格式的字符串转换为指定格式的日期
SELECT STR_TO_DATE('20-7-14','%Y-%m-%d');
#查询入职日期为指定年月日的员工信息
SELECT 
  * 
FROM
  employees 
WHERE hiredate = STR_TO_DATE('4-3 1992', '%c-%d %Y') ;

#date_format将日期转换成字符
SELECT DATE_FORMAT(NOW(),'%Y年%m月%d日');

#查询有奖金的员工名和入职日期(年月日)
SELECT 
  last_name,
  DATE_FORMAT(hiredate, '%Y年%m月%d日') 
FROM
  employees 
WHERE commission_pct IS NOT NULL ;

#四.流程控制函数
#if函数 类似三元表达式
SELECT 
  IF(100 > 99, '大于', '小于') ;

SELECT 
  last_name,
  commission_pct,
  IF(
    commission_pct IS NULL,
    '无奖金',
    '有奖金'
  ) 备注 
FROM
  employees ;

#case函数
#应用一，用作switch case语句
/*查询员工的工资，要求 
1)部门号=30，显示的工资为1.1倍 
2)部门号=40，显示的工资为1.2倍
3)部门号=50，显示的工资为1.3倍
4)其他的部门显示的为原工资
*/

SELECT salary 原始工资,department_id,
CASE department_id 
WHEN 30 THEN salary*1.1
WHEN 40 THEN salary*1.2
WHEN 50 THEN salary*1.3
ELSE salary
END AS 新工资
FROM employees
ORDER BY department_id ASC;

#应用二，用作多重if语句
/*查询员工的工资情况
如果工资大于20000，显示A级别
如果工资大于15000，显示B级别
如果工资大于10000，显示C级别
否则，显示D级别
*/
SELECT 
  salary,
  CASE
    WHEN salary > 20000 
    THEN 'A' 
    WHEN salary > 15000 
    THEN 'B' 
    WHEN salary > 10000 
    THEN 'C' 
    ELSE 'D' 
  END AS 工资情况 
FROM
  employees ;

SELECT USER();

#分组函数
SELECT 
  SUM(salary) 总额,
  CEIL(AVG(salary)) 平均工资,
  MAX(salary) 最高工资,
  MIN(salary) 最低工资,
  COUNT(salary) 工资人数 
FROM
  employees ;

SELECT 
  MAX(last_name),
  MIN(last_name),
  MAX(hiredate),
  COUNT(first_name),
  COUNT(commission_pct)
FROM
  employees ;
#分组函数全部忽略null值
SELECT 
  COUNT(commission_pct) 
FROM
  employees ;
  
#count(*)或count(1)被用于统计行数
SELECT COUNT(*),COUNT(1) FROM employees;

#datediff
SELECT DATEDIFF(NOW(),'1997-07-14') 经过天数;
SELECT DATEDIFF(MAX(hiredate),MIN(hiredate)) difference FROM employees;

#group by将表中数据分成若干组
#查询每个工种的最高工资
SELECT 
  MAX(salary),
  job_id 
FROM
  employees 
GROUP BY job_id ;
#根据位置统计每个部门人员的个数
SELECT 
  COUNT(department_id),
  location_id 
FROM
  departments 
GROUP BY location_id ;

#查询邮箱中包含a字符的，每个部门的平均工资
SELECT 
  AVG(salary),
  department_id 
FROM
  employees 
WHERE email LIKE '%a%' 
GROUP BY department_id ;

#查询有奖金的每个领导手下员工最高的工资
SELECT 
  MAX(salary),
  manager_id 
FROM
  employees 
WHERE commission_pct IS NOT NULL 
GROUP BY manager_id ;

#having借以用于筛选分组后的各组数据
#查询哪个部门的员工个数大于2
SELECT 
  COUNT(*) 员工个数,
  department_id 
FROM
  employees 
#where 员工个数 > 2 
GROUP BY department_id 
HAVING 员工个数>2;

#查询每个工种有奖金的员工的最大公子大于12000的工种编号和最高工资
SELECT 
  MAX(salary) 最高工资,
  job_id 
FROM
  employees 
WHERE commission_pct IS NOT NULL 
GROUP BY job_id 
HAVING 最高工资 > 12000 ;

#查询领导编号大于102的每个领导手下的最低工资>5000的领导编号是哪个
SELECT 
  manager_id,
  MIN(salary) 最低工资 
FROM
  employees 
WHERE manager_id > 102 
GROUP BY manager_id 
HAVING 最低工资 > 5000 ;

#按员工姓名的长度分组，查询每一组的员工个数，员工个数大于5的有哪些
SELECT 
  COUNT(*) 员工个数,
  LENGTH(last_name) 长度 
FROM
  employees 
GROUP BY 长度 
HAVING 员工个数 > 5 ;

#按多个字段分组
#查询每个部门、每个工种的员工的平均工资
SELECT 
  AVG(salary),
  department_id,
  job_id 
FROM
  employees 
GROUP BY department_id,job_id;

#添加排序
#查询每个部门、每个工种的员工的平均工资,并且按工资的高低排序
SELECT 
  AVG(salary) 工资,
  department_id,
  job_id 
FROM
  employees 
WHERE department_id IS NOT NULL 
GROUP BY department_id,
  job_id 
HAVING 工资 > 10000 
ORDER BY 工资 ASC ;

