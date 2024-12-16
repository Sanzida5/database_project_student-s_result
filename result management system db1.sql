CREATE TABLE student (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL
);
CREATE TABLE course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(255) NOT NULL,
    student_id INT,
    FOREIGN KEY (student_id) REFERENCES student(student_id)
);
CREATE TABLE result (
    result_id INT PRIMARY KEY,
    mark INT NOT NULL,
    grade VARCHAR(2) NOT NULL,
    student_id INT,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id)
);
//to show the table name
select table_name from user_tables;
//add column to student table;
alter table student add location char(20);
//modify the data type

alter table student modify location varchar(23);

//alter the cloumn name
alter table student rename column location to location2;
//drop the cloumn

alter table student drop column location2;
//insertion

 insert into  student values(1,'sanzida','moin',TO_DATE('200
0-01-01','YYYY-MM-DD'));
 insert into  student values(2,'toha','moin',TO_DATE('2001-01-02','YYYY-MM-DD'));
 insert into  student values(3,'shayeeri','taj',TO_DATE('200
2-02-04','YYYY-MM-DD'));


insert into course values(101,'EEE',1);
insert into course values(102,'CSE',2);
insert into course values(103,'ECE',3);
insert into course values(104,'ME',3);


 insert into result values(11,70,'A',1,101);
 insert into result values(12,80,'A+',2,102);
 insert into result values(13,60,'A-',3,103);
 insert into result values(14,60,'A-',3,104);

 select * from course where student_id=3;

 select * from student where student_id=(select student_id f
rom course where course_name='ECE');

update course set course_name='ESE' where course_id='103';
//union

select course_name from course where course_name like 'E%'
union select course_name from course where course_name like '%C%
';
//max_mark using with clause
 with max_mark(val) as (select max(mark) from result)
   select * from result,max_mark where result.mark=max_mark.va
l;
//number of row
select count(*) from result;
//number of course
select count(course_name) as number_of_course from course;
 select count(distinct course_name) as number_of_course from
 course;
//avarage of mark

 select avg(mark) from result;
//summation of mark

  select sum(mark) from result;

//minimum mark

  select min(mark) from result;
//avarage mark using group by and having

select course_id,avg(mark) from result group by course_id;
select course_id,avg(mark) from result group by course_id having avg(mark)>60;
//subquery

SELECT first_name 
FROM student 
WHERE student_id IN (
    SELECT student_id 
    FROM course 
    WHERE course_id IN (
        SELECT course_id 
        FROM result 
        WHERE grade = 'A'
    )
);
//some
 select * from course where course_id> some(select course_id
 from result where mark>=70);
//all
select * from course where course_id> all(select course_id
 from result where mark>=70);

//exists
select * from result where mark>=70 and exists(select * fro
m course where course_name like '%EE%');

 SELECT * FROM course WHERE course_name LIKE '%E%E%';

SELECT * FROM course WHERE course_name LIKE '___';

//view
 create view dept_details as select student_id,first_name fr
om student;


//natural join

 select * from student natural join course;

select first_name,course_name from student join course usin
g(student_id);
//left outer join

 select last_name,course_name from student left outer join c
ourse using(student_id);

//right outer join
 select last_name,course_name from student right outer join
 course using(student_id);

//full outer join
 select first_name,course_name from student full outer join
 course using(student_id);


//pl/sql

SET SERVEROUTPUT ON;
DECLARE 
  course_id COURSE.COURSE_ID%TYPE;
  course_name COURSE.COURSE_NAME%TYPE;
BEGIN
  SELECT course_id, course_name INTO course_id, course_name
  FROM course
  WHERE course_id = 103;

  DBMS_OUTPUT.PUT_LINE('COURSE_id: ' || course_id || 
                       ' COURSE_name: ' || course_name);
END;
/

//insertion
SET SERVEROUTPUT ON;
DECLARE 
  course_id COURSE.COURSE_ID%TYPE := 105; 
  course_name COURSE.COURSE_NAME%TYPE :='MME';
  student_id COURSE.STUDENT_ID%TYPE := 1; 
BEGIN
  INSERT INTO course VALUES(course_id, course_name, student_id);
END;
/
//cursor and row count

SET SERVEROUTPUT ON;
DECLARE 
  cursor course_cursor is select * from course;
  course_row course%rowtype;
BEGIN
  OPEN course_cursor;
  FETCH course_cursor INTO course_row.course_id, course_row.course_name, course_row.student_id;
  
  WHILE course_cursor%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE('COURSE_id: ' || course_row.course_id || 
                         ' COURSE_name: ' || course_row.course_name || 
                         ' STUDENT_id: ' || course_row.student_id);
    DBMS_OUTPUT.PUT_LINE('Row count: ' || course_cursor%ROWCOUNT);
    FETCH course_cursor INTO course_row.course_id, course_row.course_name, course_row.student_id;
  END LOOP;
  
  CLOSE course_cursor;
END;
/

//if/else

DECLARE 
   counter NUMBER := 1;
   course_name2 COURSE.COURSE_NAME%TYPE;
   TYPE NAMEARRAY IS VARRAY(5) OF COURSE.COURSE_NAME%TYPE;
   A_NAME NAMEARRAY := NAMEARRAY('Course 1', 'Course 2', 'Course 3', 'Course 4', 'Course 5'); 
   
BEGIN
   counter := 1;
   FOR x IN 101..105
   LOOP
      SELECT course_name INTO course_name2 FROM course WHERE course_id=x;
      IF course_name2='CSE' THEN
        dbms_output.put_line(course_name2 ||' is a '||'CSE department course');
      ELSIF course_name2='EEE' THEN
        dbms_output.put_line(course_name2 ||' is a '||'EEE department course');
      ELSE 
        dbms_output.put_line(course_name2 ||' is a '||'other dept course');
      END IF;
   END LOOP;
END;
/

//procedure

CREATE OR REPLACE PROCEDURE proc2(
  var1 IN NUMBER,
  var2 OUT VARCHAR2,
  var3 IN OUT NUMBER
)
AS
  t_show CHAR(30);
BEGIN
  t_show := 'From procedure: ';
 
  SELECT course_name INTO var2 FROM course WHERE course_id = var1;
  var3 := var1 + 1; 
  DBMS_OUTPUT.PUT_LINE(t_show || var2 || ' code is ' || var1 || ' In out parameter: ' || var3);
END;
/

SET SERVEROUTPUT ON;
DECLARE 
  course_id COURSE.COURSE_ID%TYPE := 105;
  course_name2 COURSE.COURSE_NAME%TYPE;
  extra NUMBER;
BEGIN
  proc2(course_id, course_name2, extra);
END;
/


//function

SET SERVEROUTPUT ON;
CREATE OR REPLACE FUNCTION fun_course(var1 IN NUMBER) RETURN VARCHAR2 AS
  value COURSE.COURSE_NAME%TYPE;
BEGIN
  SELECT course_name INTO value FROM course WHERE course_id = var1;
  RETURN value;
END;
/

SET SERVEROUTPUT ON;
DECLARE 
  value VARCHAR2(255); 
BEGIN
  value := fun_course(101);
  DBMS_OUTPUT.PUT_LINE('Course Name: ' || value);
END;
/


drop procedure proc2;
drop function fun_course;


//trigger


SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER trg_before_course_delete
BEFORE DELETE ON course
FOR EACH ROW
BEGIN
 
  DELETE FROM result WHERE course_id = :OLD.course_id;
  
END;
/


DELETE FROM course WHERE course_id = 105;



show errors;
select * from user_triggers;
drop trigger trg_before_course_delete;

select last_name,course_name from student left outer join c
ourse using(student_id) union select last_name,course_name from student right outer join
 course using(student_id);