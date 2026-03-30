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