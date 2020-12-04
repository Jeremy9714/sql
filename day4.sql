#列级约束

CREATE DATABASE students;
CREATE TABLE stuinfo(
	id INT PRIMARY KEY, #主键
	studentName VARCHAR(20) NOT NULL,
	gender CHAR(1) CHECK(gender='男' OR gender='女'),
	seat INT UNIQUE,
	age INT DEFAULT 18,
	majorId INT REFERENCES major(id) #外键
);

CREATE TABLE major(
	id INT PRIMARY KEY,
	majorName VARCHAR(20)
);
DESC stuinfo;
SHOW INDEX FROM stuinfo;

#表级约束

DROP TABLE IF EXISTS stuinfo;
CREATE TABLE stuinfo(
	id INT,
	studentName VARCHAR(20),
	gender CHAR(1),
	seat INT,
	age INT,
	majorId INT,
	
	CONSTRAINT pk PRIMARY KEY(id), #主键名固定，修改没有效果
	CONSTRAINT uq UNIQUE(seat), #唯一键
	CONSTRAINT ck CHECK(gender='男' OR gender='女'), #检查
	CONSTRAINT fk FOREIGN KEY(majorId) REFERENCES major(id) #外键
);
SHOW INDEX FROM stuinfo;

#通用写法
CREATE TABLE stuinfo(
	id INT PRIMARY KEY,
	studentName VARCHAR(20) NOT NULL,
	gender CHAR(1),
	seat INT UNIQUE,
	age INT DEFAULT 18,
	majorId INT,
	CONSTRAINT pk FOREIGN KEY(majorId) REFERENCES major(id)
);
#多个唯一键、组合主键
DROP TABLE IF EXISTS stuinfo;
CREATE TABLE stuinfo(
	id INT,
	studentName VARCHAR(20),
	gender CHAR(1),
	seat INT,
	seat2 INT,
	age INT DEFAULT 18,
	majorId INT,
	CONSTRAINT PRIMARY KEY(id,studentName),
	UNIQUE(seat,seat2),
	CONSTRAINT fk FOREIGN KEY(majorId) REFERENCES major(id)
);
DELETE FROM stuinfo;
DELETE FROM major;
INSERT INTO major VALUES(1,'java'),(2,'html5');
INSERT INTO stuinfo VALUES(1,'jeremy','男',NULL,1,23,1);
INSERT INTO stuinfo VALUES(2,'jeremy','男',NULL,2,25,2);
SHOW INDEX FROM stuinfo;
DESC stuinfo;
SELECT * FROM stuinfo;

#修改表时添加约束

DROP TABLE IF EXISTS stuinfo;
DROP TABLE IF EXISTS major;
CREATE TABLE stuinfo(
	id INT,
	stuName VARCHAR(20),
	gender CHAR(1),
	seat INT,
	age INT,
	majorId INT
);

#添加非空约束
ALTER TABLE stuinfo MODIFY COLUMN stuName VARCHAR(20) NOT NULL;
#添加默认约束
ALTER TABLE stuinfo MODIFY COLUMN age INT DEFAULT 18;
#添加主键
#1.列级写法
ALTER TABLE stuinfo MODIFY COLUMN id INT PRIMARY KEY;
#2.表级写法
ALTER TABLE stuinfo ADD PRIMARY KEY(id);

#添加唯一键
ALTER TABLE stuinfo MODIFY COLUMN seat INT UNIQUE;
ALTER TABLE stuinfo ADD UNIQUE(seat);

#添加外键
ALTER TABLE stuinfo ADD CONSTRAINT fk FOREIGN KEY(majorId) REFERENCES major(id);
DESC stuinfo;
SHOW INDEX FROM stuinfo;

#修改表时删除约束
#删除非空约束
ALTER TABLE stuinfo MODIFY COLUMN stuName VARCHAR(20) NULL;
#删除默认约束
ALTER TABLE stuinfo MODIFY COLUMN age INT;
#删除主键
ALTER TABLE stuinfo DROP PRIMARY KEY;
#删除唯一键
ALTER TABLE stuinfo DROP INDEX seat;
#删除外键 
ALTER TABLE stuinfo DROP FOREIGN KEY fk;

#标识列(自增长列)

DROP TABLE IF EXISTS tab_identity;
CREATE TABLE tab_identity(
	id INT PRIMARY KEY AUTO_INCREMENT,
	NAME VARCHAR(20)
);
TRUNCATE TABLE tab_identity;
SET auto_increment_increment = 3; #更改步长
INSERT INTO tab_identity VALUES(NULL,'sean');
INSERT INTO tab_identity(NAME) VALUES('jeremy');
SELECT * FROM tab_identity;

#TCL语言

SHOW VARIABLES LIKE '%autocommit%';
SHOW ENGINES;
DROP TABLE IF EXISTS account;
CREATE TABLE account(
	id INT PRIMARY KEY AUTO_INCREMENT,
	username VARCHAR(20),
	balance DOUBLE	
);
INSERT INTO account(username, balance) VALUES('张无忌',1000),('赵敏',1000);
#事务的使用步骤

#开启事务
SET autocommit=0;
START TRANSACTION;
#编写事务中的语句
UPDATE account SET balance=1000 WHERE username='张无忌';
UPDATE account SET balance=1000 WHERE username='赵敏';
#结束事务(commit提交 或 rollback回滚)
COMMIT;
ROLLBACK;

#事务对于delete和truncate的处理的区别
SET autocommit=0;
START TRANSACTION;
DELETE FROM account;
#truncate table account;
ROLLBACK;

#演示savepoint的使用
SET autocommit=0;
START TRANSACTION;
DELETE FROM account WHERE id=7;
SAVEPOINT a;
DELETE FROM account WHERE id=10;
ROLLBACK TO a;

SELECT * FROM account;

#视图

#视图的创建
USE myemployees;

#查询邮箱中包含a字符的员工名、部门名和工种信息
CREATE VIEW v AS 
SELECT last_name, department_name, job_title FROM employees e 
INNER JOIN departments d ON e.department_id=d.department_id
INNER JOIN jobs j ON e.job_id=j.job_id;

SELECT * FROM v WHERE last_name LIKE '%a%';

#查询各部门的平均工资级别
CREATE VIEW v2 AS 
SELECT MIN(salary) , department_id FROM employees e
GROUP BY department_id;

SELECT 
  v.department_id,
  j.grade_level 
FROM
  v2 v 
  JOIN job_grades j 
    ON v.`min(salary)` BETWEEN j.`lowest_sal` 
    AND j.`highest_sal` ;

#查询平均工资最低的部门信息

SELECT * FROM departments d
JOIN v2 ON d.`department_id`=v2.`department_id`
ORDER BY v2.`min(salary)` ASC
LIMIT 1;

#视图的修改

CREATE OR REPLACE VIEW v2 AS 
SELECT AVG(salary) ag, department_id FROM employees e
GROUP BY department_id;
CREATE VIEW v3 AS SELECT * FROM v2 ORDER BY ag LIMIT 1;
#方式一

CREATE OR REPLACE VIEW v3 AS 
SELECT AVG(salary), job_id FROM employees GROUP BY job_id;

#方式二
ALTER VIEW v3 AS 
SELECT * FROM employees;
SELECT * FROM v3;

#删除视图
DROP VIEW v, v2, v3;

#查看视图
DESC v3;
SHOW CREATE VIEW v3;

#视图的更新
CREATE OR REPLACE VIEW v1 AS SELECT last_name, email FROM employees;
#插入
INSERT INTO v1 VALUES('张飞','zf@qq.com');
#修改
UPDATE v1 SET last_name='张无忌' WHERE last_name='张飞';
#删除
DELETE FROM v1 WHERE last_name = '张无忌';
SELECT * FROM employees;
#不允许更新的视图
#1.具有分组函数、distinct、group by、having、union和union all
CREATE OR REPLACE VIEW v1 AS 
SELECT MAX(salary) m,department_id FROM employees GROUP BY department_id;
#update v1 set m = '9000' where department_id=10; #无法更新

#2.常量视图
CREATE OR REPLACE VIEW v2 AS 
SELECT 'john' NAME;
#update v2 set name='sean';

#select中包含子查询
CREATE OR REPLACE VIEW v3 AS
SELECT department_id,(SELECT MAX(salary) FROM employees) 最高工资 FROM departments;
#update v3 set 最高工资=300000;

#join
CREATE OR REPLACE VIEW v4 AS 
SELECT last_name,department_name FROM employees e JOIN departments d ON e.department_id=d.department_id;
UPDATE v4 SET last_name='张飞' WHERE last_name='whalen';
#insert into v4 values('陈真','xxxx');

#from一个不能更新的视图
CREATE OR REPLACE VIEW v5 AS 
SELECT * FROM v3;
#update v5 set 最高工资= 100000 where department_id=60;

#where子句的子查询引用了from子句中的表
CREATE OR REPLACE VIEW v6 AS 
SELECT last_name, email,salary FROM employees
WHERE employee_id IN(
	SELECT DISTINCT manager_id FROM employees 
	WHERE manager_id IS NOT NULL
);
#update v6 set salary=50000 where last_name='k_ing';
SELECT * FROM v6;

