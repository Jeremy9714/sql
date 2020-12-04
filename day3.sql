#DML语言

#插入语句
INSERT INTO beauty(id,NAME,sex,borndate,phone,photo,boyfriend_id) VALUES
(13,'唐艺昕','女','1990-4-23','1898888888',NULL,2);
#nullable的列值为空可以省略列和值
INSERT INTO beauty(id,NAME,sex,borndate,phone,boyfriend_id) VALUES
(14,'金星','女','1990-4-23','1388888888',2);
INSERT INTO beauty(id,NAME,sex,phone) VALUES
(15,'娜扎','女','1388888888');
#列的顺序可以调换
INSERT INTO beauty(NAME,sex,id,phone) VALUES('蒋欣','女',16,'110');
#列值的个数必须一致
INSERT INTO beauty(NAME,sex,id,phone) VALUES('关晓彤','女',17,'110');
#可以省略列名，则默认为所有列，且顺序与表中列的顺序一致
INSERT INTO beauty VALUES(18,'张飞','男',NULL,'119',NULL,NULL);

#另一种方式添加
INSERT INTO beauty SET id = 19, NAME ='刘涛',phone='999';
SELECT * FROM beauty;

#修改语句
#将唐姓的女星的电话修改为138
UPDATE beauty SET phone='138' WHERE NAME LIKE'唐%';
#修改男性表中id为2D额男性的名字和魅力值
UPDATE boys SET boyName='张飞', userCP=10 WHERE id =2;

#修改多表的记录
#将张无忌的女朋友的手机号修改为114
UPDATE boys bo INNER JOIN beauty b ON bo.`id`=b.`boyfriend_id` SET phone='114' WHERE bo.`boyName`='张无忌';

#修改没有男朋友的女性的男友编号为2
UPDATE beauty SET boyfriend_id = 2 WHERE boyfriend_id NOT IN(SELECT id FROM boys); 
UPDATE boys bo RIGHT JOIN beauty b ON bo.`id`=b.`boyfriend_id` SET boyfriend_id=2 WHERE bo.id=NULL;

#删除语句

#delete删除
#单表的删除
#删除手机号以9结尾的女性信息
DELETE FROM beauty WHERE phone LIKE '%9';

#多表删除
#删除张无忌的女朋友的信息
DELETE b FROM beauty b INNER JOIN boys bo ON b.`boyfriend_id`=bo.`id` WHERE bo.`boyName`='张无忌';
#删除黄晓明夫妇的信息
DELETE b,bo FROM beauty b INNER JOIN boys bo ON b.`boyfriend_id`=bo.`id` WHERE bo.`boyName`='黄晓明';

#truncate删除
#将男性表中魅力值大于100的删除
TRUNCATE TABLE boys; #整个表都删除

#创建表
USE myemployees;
CREATE TABLE my_employees (
  Id INT (10),
  First_name VARCHAR (10),
  Last_name VARCHAR (10),
  Userid VARCHAR (10),
  Salary DOUBLE (10, 2)
) ;

CREATE TABLE users (
  id INT,
  userid VARCHAR (10),
  department_id INT
) ;
#显示my_employees的结构
DESC my_employees;

DELETE FROM my_employees;
#向my_employees表中插入数据
#方式一
INSERT INTO my_employees
VALUES
  (1, 'Patel', 'Ralph', 'Rpatel', 895),
  (2, 'Dancs', 'Betty', 'Bdancs', 860),
  (3, 'Biri', 'Ben', 'Bbiri', 1100),
  (4, 'Newman', 'Chad', 'Cnewman', 750),
  (5, 'Ropeburn','Audrey','Aropeburn',1550) ;
DELETE FROM my_employees;
#方式二
INSERT INTO my_employees
SELECT 1, 'Patel', 'Ralph', 'Rpatel', 895 UNION
SELECT 2, 'Dancs', 'Betty', 'Bdancs', 860 UNION
SELECT 3, 'Biri', 'Ben', 'Bbiri', 1100 UNION 
SELECT 4, 'Newman', 'Chad', 'Cnewman', 750 UNION
SELECT 5, 'Ropeburn','Audrey','Aropeburn',1550;

#向users表中插入数据
INSERT INTO users
VALUES
  (1, 'Rpatel', 10),
  (2, 'Bdancs', 10),
  (3, 'Bbiri', 20),
  (4, 'Cnewman', 30),
  (5, 'Aropeburn',40) ;

#将三号员工的姓名修改为drelxer
UPDATE my_employees SET last_name='drelxer' WHERE id=3;

#将所有员工工资少于900的工资修改为1000
UPDATE my_employees SET salary=1000 WHERE salary<900;

#将userid为Bbiri的user表和my_employees表的记录全部删除
DELETE u, me FROM users u INNER JOIN my_employees me ON u.`id` = me.`Id` WHERE u.`userid`='Bbiri';

#删除所有数据
DELETE FROM sers;
DELETE FROM my_employees;
SELECT * FROM my_employees;
SELECT * FROM users;

#清空表my_employees
TRUNCATE TABLE users;
TRUNCATE TABLE my_employees;

#DDL语言(库与表的管理)

#库的创建
CREATE DATABASE IF NOT EXISTS books;

#库的修改
#更改库的字符集
ALTER DATABASE books CHARACTER SET gbk;

#库的删除
DROP DATABASE IF EXISTS books;

#表的管理
#表的创建
CREATE TABLE IF NOT EXISTS Book(
	id INT,#编号
	bName VARCHAR(20),#书名
	price DOUBLE,#价格
	authorId INT,#作者编号
	publishDate DATETIME#出版日期
);
DESC book;
CREATE TABLE IF NOT EXISTS Author(
	id INT,
	au_name VARCHAR(10),
	nation VARCHAR(10)		
);
DESC author;

#表的修改
#1.修改列名
ALTER TABLE book CHANGE COLUMN publishDate pubDate DATETIME;
#2.修改列的类型或约束
ALTER TABLE book MODIFY COLUMN pubDate TIMESTAMP;
#3.添加新列
ALTER TABLE author ADD COLUMN annual DOUBLE;
#4.删除列
ALTER TABLE author DROP COLUMN annual;
#修改表名
ALTER TABLE author RENAME TO book_author;
DESC book_author;

#表的删除
DROP TABLE IF EXISTS book_author;
SHOW TABLES;

#表的复制

INSERT INTO author VALUES(1,'村上春树','日本'),(2,'莫言','中国'),(3,'冯唐','中国'),(4,'金庸','中国');
#只复制结构
CREATE TABLE copy LIKE author;
#全部复制
CREATE TABLE copy2 SELECT * FROM author;
#只复制部分信息
CREATE TABLE copy3 SELECT id,au_name FROM author WHERE nation='中国';
#只复制某些结构
CREATE TABLE copy4 SELECT id, au_name FROM author WHERE 0;

#常规的数据类型

#数值型
#整型
USE books;
DROP TABLE IF EXISTS tab_int;
CREATE TABLE tab_int(
	t1 INT(7) ZEROFILL,
	t2 INT UNSIGNED
);
DESC tab_int;
INSERT INTO tab_int VALUES(13456,12222);
INSERT INTO tab_int VALUES(123456,-12222);
SELECT * FROM tab_int;

#小数
DROP TABLE IF EXISTS tab_float;
CREATE TABLE tab_float(
	f1 FLOAT(5,2),
	f2 DOUBLE(5,2),
	f3 DECIMAL(5,2)
);
DESC tab_float;
INSERT INTO tab_float VALUES(123.45,123.45,123.45),
(123.456,123.456,123.456),
(12355.45,123.45,123.45);
SELECT * FROM tab_float;

#字符型
#较短的文本
CREATE TABLE tab_char(
	c1 ENUM('a','b','c')
);
INSERT INTO tab_char VALUES('a');
INSERT INTO tab_char VALUES('b');
INSERT INTO tab_char VALUES('c');
INSERT INTO tab_char VALUES('m');
INSERT INTO tab_char VALUES('A');
SELECT * FROM tab_char;

DROP TABLE IF EXISTS tab_set;
CREATE TABLE tab_set(
	s1 SET('a','b','c','d')
);
INSERT INTO tab_set VALUES('a');
INSERT INTO tab_set VALUES('a,b');
INSERT INTO tab_set VALUES('a,b,c,d');
INSERT INTO tab_set VALUES('m');
SELECT * FROM tab_set;

#日期型
DROP TABLE IF EXISTS tab_date;
CREATE TABLE tab_date(
	t1 DATETIME,
	t2 TIMESTAMP
);
INSERT INTO tab_date VALUES(NOW(),NOW());
SHOW VARIABLES LIKE 'time_zone';
SELECT * FROM tab_date;


