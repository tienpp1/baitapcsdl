--Baitapthuchanh1
--Tao bang

CREATE TABLE s_region (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(50)
);

CREATE TABLE s_warehouse (
    id NUMBER PRIMARY KEY,
    region_id NUMBER,
    address VARCHAR2(100),
    city VARCHAR2(50),
    state VARCHAR2(50),
    country VARCHAR2(50),
    zip_code VARCHAR2(20),
    phone VARCHAR2(20),
    manager_id NUMBER
);

CREATE TABLE s_title (
    title VARCHAR2(25) PRIMARY KEY
);

CREATE TABLE s_dept (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(25),
    region_id NUMBER
);

CREATE TABLE s_emp (
    id NUMBER PRIMARY KEY,
    last_name VARCHAR2(25),
    first_name VARCHAR2(25),
    userid VARCHAR2(10),
    start_date DATE,
    manager_id NUMBER,
    title VARCHAR2(25),
    dept_id NUMBER,
    salary NUMBER,
    commission_pct NUMBER
);

CREATE TABLE s_customer (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    phone VARCHAR2(20),
    address VARCHAR2(100),
    city VARCHAR2(50),
    state VARCHAR2(50),
    country VARCHAR2(50),
    zip_code VARCHAR2(20),
    credit_rating NUMBER,
    sales_rep_id NUMBER,
    region_id NUMBER
);

CREATE TABLE s_image (
    id NUMBER PRIMARY KEY,
    format VARCHAR2(20),
    use_filename VARCHAR2(3),
    filename VARCHAR2(100),
    image BLOB
);

CREATE TABLE s_longtext (
    id NUMBER PRIMARY KEY,
    use_filename VARCHAR2(3),
    filename VARCHAR2(100),
    text CLOB
);

CREATE TABLE s_product (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    short_desc VARCHAR2(255),
    longtext_id NUMBER,
    image_id NUMBER,
    suggested_whlsl_price NUMBER,
    whlsl_units NUMBER
);

CREATE TABLE s_ord (
    id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    date_ordered DATE,
    date_shipped DATE,
    sales_rep_id NUMBER,
    total NUMBER,
    payment_type VARCHAR2(20),
    order_filled VARCHAR2(3)
);

CREATE TABLE s_item (
    ord_id NUMBER,
    item_id NUMBER,
    product_id NUMBER,
    price NUMBER,
    quantity NUMBER,
    quantity_shipped NUMBER,
    PRIMARY KEY (ord_id, item_id)
);

CREATE TABLE s_inventory (
    product_id NUMBER,
    warehouse_id NUMBER,
    amount_in_stock NUMBER,
    reorder_point NUMBER,
    max_in_stock NUMBER,
    out_of_stock_explanation VARCHAR2(255),
    restock_date DATE,
    PRIMARY KEY (product_id, warehouse_id)
);
--insert dulieu
/* =========================
   INSERT DATA
   ========================= */

/* REGION */
INSERT INTO s_region VALUES (1, 'Asia');
INSERT INTO s_region VALUES (2, 'Europe');

/* TITLE */
INSERT INTO s_title VALUES ('Manager');
INSERT INTO s_title VALUES ('Staff');

/* DEPT */
INSERT INTO s_dept VALUES (10, 'HR', 1);
INSERT INTO s_dept VALUES (31, 'IT', 1);
INSERT INTO s_dept VALUES (42, 'Sales', 2);
INSERT INTO s_dept VALUES (50, 'Marketing', 2);

/* EMP */
INSERT INTO s_emp VALUES (1, 'Nguyen', 'Lan', 'lan01', TO_DATE('10/05/1990','DD/MM/YYYY'), NULL, 'Manager', 10, 3000, NULL);
INSERT INTO s_emp VALUES (2, 'Tran', 'Son', 'son01', TO_DATE('15/06/1991','DD/MM/YYYY'), 1, 'Staff', 10, 1500, NULL);
INSERT INTO s_emp VALUES (3, 'Le', 'Nam', 'nam01', TO_DATE('20/07/1992','DD/MM/YYYY'), 1, 'Staff', 31, 1200, NULL);
INSERT INTO s_emp VALUES (4, 'Pham', 'Linh', 'linh01', TO_DATE('01/01/1991','DD/MM/YYYY'), 1, 'Staff', 42, 2000, NULL);
INSERT INTO s_emp VALUES (5, 'Hoang', 'Sang', 'sang01', TO_DATE('12/12/1990','DD/MM/YYYY'), 2, 'Staff', 50, 1800, NULL);

/* CUSTOMER */
INSERT INTO s_customer VALUES (1, 'Customer A', '111', 'Addr1', 'HCM', 'NA', 'VN', '70000', 1, 2, 1);
INSERT INTO s_customer VALUES (2, 'Customer B', '222', 'Addr2', 'HN', 'NA', 'VN', '10000', 2, 3, 2);
INSERT INTO s_customer VALUES (3, 'Customer C', '333', 'Addr3', 'DN', 'NA', 'VN', '50000', 3, 4, 1);
/* KH ch?a ??t hàng */
INSERT INTO s_customer VALUES (4, 'Customer D', '444', 'Addr4', 'CT', 'NA', 'VN', '90000', 1, 5, 2);

/* IMAGE */
INSERT INTO s_image VALUES (1, 'jpg', 'Y', 'img1.jpg', NULL);

/* LONGTEXT */
INSERT INTO s_longtext VALUES (1, 'Y', 'text1.txt', 'Detail product');

/* PRODUCT */
INSERT INTO s_product VALUES (1, 'Pro Bike', 'This is bicycle', 1, 1, 1000, 10);
INSERT INTO s_product VALUES (2, 'Pro Ski', 'Ski equipment', 1, 1, 2000, 5);
INSERT INTO s_product VALUES (3, 'Normal Product', 'Other item', 1, 1, 500, 20);

/* WAREHOUSE */
INSERT INTO s_warehouse VALUES (1, 1, 'AddrW1', 'HCM', 'NA', 'VN', '70000', '999', 1);

/* ORD */
INSERT INTO s_ord VALUES (101, 1, SYSDATE, SYSDATE, 2, 150000, 'CASH', 'Y');
INSERT INTO s_ord VALUES (102, 2, SYSDATE, SYSDATE, 3, 50000, 'CARD', 'Y');
INSERT INTO s_ord VALUES (103, 1, SYSDATE, SYSDATE, 2, 200000, 'CASH', 'Y');

/* ITEM */
INSERT INTO s_item VALUES (101, 1, 1, 1000, 50, 50);
INSERT INTO s_item VALUES (101, 2, 2, 2000, 20, 20);
INSERT INTO s_item VALUES (102, 1, 3, 500, 10, 10);
INSERT INTO s_item VALUES (103, 1, 2, 2000, 30, 30);

/* INVENTORY */
INSERT INTO s_inventory VALUES (1, 1, 100, 10, 200, NULL, SYSDATE);
INSERT INTO s_inventory VALUES (2, 1, 50, 5, 100, NULL, SYSDATE);

COMMIT;
--bai2
--cau1
SELECT name AS "Ten khach hang",
       id AS "Ma khach hang"
FROM s_customer
ORDER BY id DESC;

--cau2
SELECT first_name || ' ' || last_name AS "Employees",
       dept_id
FROM s_emp
WHERE dept_id IN (10, 50)
ORDER BY first_name;

--cau3
SELECT last_name, first_name
FROM s_emp
WHERE first_name LIKE '%S%'
   OR last_name LIKE '%S%';

--cau4
SELECT userid, start_date
FROM s_emp
WHERE start_date BETWEEN TO_DATE('14/05/1990','DD/MM/YYYY')
                     AND TO_DATE('26/05/1991','DD/MM/YYYY');

--cau5
SELECT last_name, salary
FROM s_emp
WHERE salary BETWEEN 1000 AND 2000;

--cau6
SELECT last_name || ' ' || first_name AS "Employee Name",
       salary AS "Monthly Salary"
FROM s_emp
WHERE dept_id IN (31, 42, 50)
  AND salary > 1350;

--cau7
SELECT last_name, start_date
FROM s_emp
WHERE TO_CHAR(start_date,'YYYY') = '1991';

--cau8
SELECT last_name, first_name
FROM s_emp
WHERE id NOT IN (
    SELECT manager_id
    FROM s_emp
    WHERE manager_id IS NOT NULL
);

--cau9
SELECT name
FROM s_product
WHERE name LIKE 'Pro%'
ORDER BY name;

--cau10
SELECT name, short_desc
FROM s_product
WHERE LOWER(short_desc) LIKE '%bicycle%';

--cau11
SELECT short_desc
FROM s_product;

--cau12
SELECT last_name || ' ' || first_name || ' (' || title || ')' AS "Nhan vien"
FROM s_emp;

--bai3--
--cau1
SELECT id, last_name,
       ROUND(salary * 1.15, 2) AS "Luong moi"
FROM s_emp;

--cau2
SELECT last_name, start_date,
       TO_CHAR(
           NEXT_DAY(ADD_MONTHS(start_date,6),'MONDAY'),
           'Ddspth "of" Month YYYY'
       ) AS "Ngay tang luong"
FROM s_emp;

--cau3
SELECT name
FROM s_product
WHERE LOWER(name) LIKE '%ski%';

--cau4
SELECT last_name,
       ROUND(MONTHS_BETWEEN(SYSDATE,start_date)) AS "Tham nien"
FROM s_emp
ORDER BY MONTHS_BETWEEN(SYSDATE,start_date);

--cau5
SELECT COUNT(DISTINCT manager_id) AS "So quan ly"
FROM s_emp
WHERE manager_id IS NOT NULL;

--cau6
SELECT MAX(total) AS "Highest",
       MIN(total) AS "Lowest"
FROM s_ord;

--bai4
--cau1
SELECT p.name, p.id,
       i.quantity AS "ORDERED"
FROM s_product p, s_item i
WHERE p.id = i.product_id
  AND i.ord_id = 101;

--cau2
SELECT c.id AS "Ma khach hang",
       o.id AS "Ma don hang"
FROM s_customer c, s_ord o
WHERE c.id = o.customer_id(+)
ORDER BY c.id;

--cau3
SELECT o.customer_id,
       i.product_id,
       i.quantity
FROM s_ord o, s_item i
WHERE o.id = i.ord_id
  AND o.total > 100000;

--bai5
--cau1
SELECT manager_id,
       COUNT(id) AS "So nhan vien"
FROM s_emp
WHERE manager_id IS NOT NULL
GROUP BY manager_id;

--cau2
SELECT manager_id,
       COUNT(id)
FROM s_emp
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING COUNT(id) >= 20;

--cau3
SELECT r.id, r.name,
       COUNT(d.id)
FROM s_region r, s_dept d
WHERE r.id = d.region_id
GROUP BY r.id, r.name;

--cau4
SELECT c.name,
       COUNT(o.id)
FROM s_customer c, s_ord o
WHERE c.id = o.customer_id
GROUP BY c.id, c.name;

--cau5
SELECT c.name,
       COUNT(o.id)
FROM s_customer c, s_ord o
WHERE c.id = o.customer_id
GROUP BY c.id, c.name
HAVING COUNT(o.id) = (
    SELECT MAX(COUNT(id))
    FROM s_ord
    GROUP BY customer_id
);

--cau6
SELECT c.name,
       SUM(o.total)
FROM s_customer c, s_ord o
WHERE c.id = o.customer_id
GROUP BY c.id, c.name
HAVING SUM(o.total) = (
    SELECT MAX(SUM(total))
    FROM s_ord
    GROUP BY customer_id
);

--bai6
--cau1
SELECT last_name, first_name, start_date
FROM s_emp
WHERE dept_id IN (
    SELECT dept_id
    FROM s_emp
    WHERE first_name = 'Lan'
)
AND first_name <> 'Lan';

--cau2
SELECT id, last_name, first_name, userid
FROM s_emp
WHERE salary > (
    SELECT AVG(salary)
    FROM s_emp
);

--cau3
SELECT id, last_name, first_name
FROM s_emp
WHERE salary > (
    SELECT AVG(salary)
    FROM s_emp
)
AND (
    UPPER(first_name) LIKE '%L%'
    OR UPPER(last_name) LIKE '%L%'
);

--cau4
SELECT name
FROM s_customer
WHERE id NOT IN (
    SELECT customer_id
    FROM s_ord
    WHERE customer_id IS NOT NULL
);

--Phan2 38 cau truy van
-- T?O B?NG HR
CREATE TABLE departments (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(50),
    location_id NUMBER
);

CREATE TABLE locations (
    location_id NUMBER PRIMARY KEY,
    city VARCHAR2(50),
    state_province VARCHAR2(50)
);

CREATE TABLE jobs (
    job_id VARCHAR2(10) PRIMARY KEY,
    job_title VARCHAR2(50)
);

CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    last_name VARCHAR2(50),
    job_id VARCHAR2(10),
    hire_date DATE,
    salary NUMBER,
    commission_pct NUMBER,
    manager_id NUMBER,
    department_id NUMBER
);
--insert
-- LOCATIONS
INSERT INTO locations VALUES (1000, 'Toronto', 'Ontario');
INSERT INTO locations VALUES (1700, 'California', 'California');

-- DEPARTMENTS
INSERT INTO departments VALUES (10, 'HR', 1000);
INSERT INTO departments VALUES (20, 'IT', 1700);
INSERT INTO departments VALUES (50, 'Sales', 1700);

-- JOBS
INSERT INTO jobs VALUES ('AD_PRES', 'President');
INSERT INTO jobs VALUES ('ST_MAN', 'Manager');
INSERT INTO jobs VALUES ('IT_PROG', 'Programmer');
INSERT INTO jobs VALUES ('SA_REP', 'Sales Rep');
INSERT INTO jobs VALUES ('ST_CLERK', 'Clerk');

-- EMPLOYEES
INSERT INTO employees VALUES (1, 'King', 'AD_PRES', TO_DATE('01/01/1995','DD/MM/YYYY'), 20000, NULL, NULL, 10);
INSERT INTO employees VALUES (2, 'Clark', 'ST_MAN', TO_DATE('01/01/1996','DD/MM/YYYY'), 10000, NULL, 1, 20);
INSERT INTO employees VALUES (3, 'Scott', 'IT_PROG', TO_DATE('01/01/1997','DD/MM/YYYY'), 6000, NULL, 2, 20);
INSERT INTO employees VALUES (4, 'Allen', 'SA_REP', TO_DATE('01/01/1998','DD/MM/YYYY'), 4000, 0.1, 2, 50);
INSERT INTO employees VALUES (5, 'Ward', 'ST_CLERK', TO_DATE('01/01/1994','DD/MM/YYYY'), 2000, NULL, 2, 50);
INSERT INTO employees VALUES (6, 'James', 'SA_REP', TO_DATE('01/02/1998','DD/MM/YYYY'), 4500, 0.2, 2, 50);
INSERT INTO employees VALUES (7, 'Ford', 'IT_PROG', TO_DATE('01/03/1997','DD/MM/YYYY'), 7000, NULL, 2, 20);

COMMIT;
--NHÓM 1: SELECT Và WHERE - L?c D? Li?u C? B?n (Câu 1–10)
-- 1
SELECT last_name, salary
FROM employees
WHERE salary > 12000;

-- 2
SELECT last_name, salary
FROM employees
WHERE salary < 5000 OR salary > 12000;

-- 3
SELECT last_name, job_id, hire_date
FROM employees
WHERE hire_date BETWEEN TO_DATE('20/02/1998','DD/MM/YYYY')
AND TO_DATE('01/05/1998','DD/MM/YYYY')
ORDER BY hire_date ASC;

-- 4
SELECT last_name, department_id
FROM employees
WHERE department_id IN (20, 50)
ORDER BY last_name ASC;

-- 5
SELECT last_name, hire_date
FROM employees
WHERE TO_CHAR(hire_date, 'YYYY') = '1994';

-- 6
SELECT last_name, job_id
FROM employees
WHERE manager_id IS NULL;

-- 7
SELECT last_name, salary, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary DESC, commission_pct DESC;

-- 8
SELECT last_name
FROM employees
WHERE last_name LIKE '__a%';

-- 9
SELECT last_name
FROM employees
WHERE last_name LIKE '%a%'
AND last_name LIKE '%e%';

-- 10
SELECT last_name, job_id, salary
FROM employees
WHERE job_id IN ('SA_REP', 'ST_CLERK')
AND salary NOT IN (2500, 3500, 7000);
--NHÓM 2: Các Hàm X? Lý D? Li?u (Câu 11–16)
-- 11
SELECT employee_id,
       last_name,
       ROUND(salary * 1.15, 0) AS "New Salary"
FROM employees;

-- 12
SELECT INITCAP(last_name) AS "Ten Nhan Vien",
       LENGTH(last_name) AS "Chieu Dai"
FROM employees
WHERE SUBSTR(last_name, 1, 1) IN ('J','A','L','M')
ORDER BY last_name ASC;

-- 13
SELECT last_name,
       TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)) AS "So Thang Lam Viec"
FROM employees
ORDER BY MONTHS_BETWEEN(SYSDATE, hire_date) ASC;

-- 14
SELECT last_name || ' earns '
    || TO_CHAR(salary, '$99,999') || ' monthly but wants '
    || TO_CHAR(salary*3, '$99,999') AS "Dream Salaries"
FROM employees;

-- 15
SELECT last_name,
       CASE WHEN commission_pct IS NULL THEN 'No commission'
            ELSE TO_CHAR(commission_pct)
       END AS "Commission"
FROM employees;

-- 16
SELECT job_id,
       CASE job_id
           WHEN 'AD_PRES'  THEN 'A'
           WHEN 'ST_MAN'   THEN 'B'
           WHEN 'IT_PROG'  THEN 'C'
           WHEN 'SA_REP'   THEN 'D'
           WHEN 'ST_CLERK' THEN 'E'
           ELSE '0'
       END AS "GRADE"
FROM employees;
--NHÓM 3: Phép K?t Nhi?u B?ng - JOIN (Câu 17–21)
-- 17
SELECT e.last_name, e.department_id, d.department_name
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id
  AND d.location_id   = l.location_id
  AND UPPER(l.city)   = 'TORONTO';

-- 18
SELECT e.employee_id AS "Ma NV",
       e.last_name AS "Ten NV",
       m.employee_id AS "Ma Quan Ly",
       m.last_name AS "Ten Quan Ly"
FROM employees e, employees m
WHERE e.manager_id = m.employee_id;

-- 19
SELECT e1.last_name AS "Nhan Vien 1",
       e2.last_name AS "Nhan Vien 2",
       e1.department_id AS "Phong Ban"
FROM employees e1, employees e2
WHERE e1.department_id = e2.department_id
  AND e1.employee_id < e2.employee_id
ORDER BY e1.department_id, e1.last_name;

-- 20
SELECT last_name, hire_date
FROM employees
WHERE hire_date > (
    SELECT hire_date
    FROM employees
    WHERE last_name = 'Davies'
);

-- 21
SELECT e.last_name AS "Nhan Vien",
       e.hire_date AS "Ngay Vao",
       m.last_name AS "Quan Ly",
       m.hire_date AS "Quan Ly Vao"
FROM employees e, employees m
WHERE e.manager_id = m.employee_id
  AND e.hire_date < m.hire_date;
--NHÓM 4: GROUP BY, HAVING Và Hàm G?p Nhóm (Câu 22–24)
-- 22
SELECT job_id,
       MIN(salary) AS "Luong Thap Nhat",
       MAX(salary) AS "Luong Cao Nhat",
       ROUND(AVG(salary),2) AS "Luong Trung Binh",
       SUM(salary) AS "Tong Luong"
FROM employees
GROUP BY job_id
ORDER BY job_id;

-- 23A
SELECT d.department_id,
       d.department_name,
       COUNT(e.employee_id) AS "So Nhan Vien"
FROM departments d LEFT JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY d.department_id;

-- 23B
SELECT COUNT(*) AS "Tong NV",
 SUM(CASE WHEN TO_CHAR(hire_date,'YYYY')='1995' THEN 1 ELSE 0 END) AS "Nam 1995",
 SUM(CASE WHEN TO_CHAR(hire_date,'YYYY')='1996' THEN 1 ELSE 0 END) AS "Nam 1996",
 SUM(CASE WHEN TO_CHAR(hire_date,'YYYY')='1997' THEN 1 ELSE 0 END) AS "Nam 1997",
 SUM(CASE WHEN TO_CHAR(hire_date,'YYYY')='1998' THEN 1 ELSE 0 END) AS "Nam 1998"
FROM employees;

--NHÓM 5: Truy V?n Con - Subquery (Câu 25–33)
-- 25
SELECT last_name, hire_date
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM employees
    WHERE last_name = 'Zlotkey'
)
AND last_name <> 'Zlotkey';

-- 26
SELECT last_name, department_id, job_id
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM departments
    WHERE location_id = 1700
);

-- 27
SELECT last_name, manager_id
FROM employees
WHERE manager_id IN (
    SELECT employee_id
    FROM employees
    WHERE last_name = 'King'
);

-- 28
SELECT last_name, salary, department_id
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
AND department_id IN (
    SELECT department_id
    FROM employees
    WHERE last_name LIKE '%n'
);

-- 29
SELECT department_id, department_name
FROM departments d
WHERE (SELECT COUNT(*)
       FROM employees e
       WHERE e.department_id = d.department_id) < 3
ORDER BY department_id;

-- 30
SELECT department_id, COUNT(*) AS "So Nhan Vien", 'Dong nhat' AS "Loai"
FROM employees
GROUP BY department_id
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM employees GROUP BY department_id)
UNION ALL
SELECT department_id, COUNT(*), 'It nhat'
FROM employees
GROUP BY department_id
HAVING COUNT(*) = (SELECT MIN(COUNT(*)) FROM employees GROUP BY department_id);

-- 31
SELECT last_name, hire_date,
       TO_CHAR(hire_date,'Day') AS "Thu trong tuan"
FROM employees
WHERE TO_CHAR(hire_date,'Day') = (
    SELECT TO_CHAR(hire_date,'Day')
    FROM employees
    GROUP BY TO_CHAR(hire_date,'Day')
    HAVING COUNT(*) = (
        SELECT MAX(COUNT(*))
        FROM employees
        GROUP BY TO_CHAR(hire_date,'Day')
    )
);

-- 32
SELECT last_name, salary
FROM (
    SELECT last_name, salary
    FROM employees
    ORDER BY salary DESC
)
WHERE ROWNUM <= 3;

-- 33
SELECT e.last_name, e.department_id
FROM employees e,
     departments d,
     locations l
WHERE e.department_id = d.department_id
  AND d.location_id   = l.location_id
  AND UPPER(l.state_province) = 'CALIFORNIA';
--NHÓM 6: DML - C?p Nh?t Và Xóa D? Li?u (Câu 34–38)
-- 34
UPDATE employees
SET last_name = 'Drexler'
WHERE employee_id = 3;

COMMIT;

-- 35
SELECT e1.last_name, e1.salary, e1.department_id
FROM employees e1
WHERE e1.salary < (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
)
ORDER BY e1.department_id;

-- 36
UPDATE employees
SET salary = salary + 100
WHERE salary < 900;

COMMIT;

-- 37
DELETE FROM departments
WHERE department_id = 500;

COMMIT;

-- 38
DELETE FROM departments d
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.department_id
);

COMMIT;