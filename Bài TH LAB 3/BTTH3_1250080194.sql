-- MON_HOC
CREATE TABLE MON_HOC (
    MaMonHoc NUMBER PRIMARY KEY,
    MoTa VARCHAR2(50),
    HocPhi NUMBER,
    MonTienQuyet NUMBER,
    NguoiTao VARCHAR2(30),
    NgayTao DATE,
    NguoiCapNhat VARCHAR2(30),
    NgayCapNhat DATE
);

-- GIANG_VIEN
CREATE TABLE GIANG_VIEN (
    MaGiangVien NUMBER PRIMARY KEY,
    XungHo VARCHAR2(5),
    Ten VARCHAR2(25),
    Ho VARCHAR2(25),
    DiaChi VARCHAR2(50),
    DienThoai VARCHAR2(15),
    NguoiTao VARCHAR2(30),
    NgayTao DATE,
    NguoiCapNhat VARCHAR2(30),
    NgayCapNhat DATE
);

-- SINH_VIEN
CREATE TABLE SINH_VIEN (
    MaSinhVien NUMBER PRIMARY KEY,
    XungHo VARCHAR2(5),
    Ten VARCHAR2(25),
    Ho VARCHAR2(25),
    DiaChi VARCHAR2(50),
    DienThoai VARCHAR2(15),
    CongTy VARCHAR2(50),
    NgayDangKy DATE,
    NguoiTao VARCHAR2(30),
    NgayTao DATE,
    NguoiCapNhat VARCHAR2(30),
    NgayCapNhat DATE
);

-- LOP_HOC
CREATE TABLE LOP_HOC (
    MaLopHoc NUMBER PRIMARY KEY,
    MaMonHoc NUMBER,
    SoLop NUMBER,
    ThoiGianBatDau DATE,
    DiaDiem VARCHAR2(50),
    MaGiangVien NUMBER,
    SiSoToiDa NUMBER,
    NguoiTao VARCHAR2(30),
    NgayTao DATE,
    NguoiCapNhat VARCHAR2(30),
    NgayCapNhat DATE,
    FOREIGN KEY (MaMonHoc) REFERENCES MON_HOC(MaMonHoc),
    FOREIGN KEY (MaGiangVien) REFERENCES GIANG_VIEN(MaGiangVien)
);

-- DANG_KY
CREATE TABLE DANG_KY (
    MaSinhVien NUMBER,
    MaLopHoc NUMBER,
    NgayDangKy DATE,
    DiemTongKet NUMBER,
    NguoiTao VARCHAR2(30),
    NgayTao DATE,
    NguoiCapNhat VARCHAR2(30),
    NgayCapNhat DATE,
    PRIMARY KEY (MaSinhVien, MaLopHoc),
    FOREIGN KEY (MaSinhVien) REFERENCES SINH_VIEN(MaSinhVien),
    FOREIGN KEY (MaLopHoc) REFERENCES LOP_HOC(MaLopHoc)
);

-- DIEM
CREATE TABLE DIEM (
    MaSinhVien NUMBER,
    MaLopHoc NUMBER,
    Diem NUMBER,
    NhanXet VARCHAR2(200),
    NguoiTao VARCHAR2(30),
    NgayTao DATE,
    NguoiCapNhat VARCHAR2(30),
    NgayCapNhat DATE,
    PRIMARY KEY (MaSinhVien, MaLopHoc),
    FOREIGN KEY (MaSinhVien, MaLopHoc)
        REFERENCES DANG_KY(MaSinhVien, MaLopHoc)
);
--INSERT
INSERT INTO MON_HOC VALUES (1,'CSDL',1000,NULL,USER,SYSDATE,USER,SYSDATE);
INSERT INTO MON_HOC VALUES (2,'Lap trinh',1200,NULL,USER,SYSDATE,USER,SYSDATE);

INSERT INTO GIANG_VIEN VALUES (1,'Mr','Nguyen','A','HCM','0123',USER,SYSDATE,USER,SYSDATE);
INSERT INTO GIANG_VIEN VALUES (2,'Mr','Tran','B','HCM','0456',USER,SYSDATE,USER,SYSDATE);

INSERT INTO SINH_VIEN VALUES (101,'Mr','Le','An','HCM','111',NULL,SYSDATE,USER,SYSDATE,USER,SYSDATE);
INSERT INTO SINH_VIEN VALUES (102,'Mr','Pham','Binh','HCM','222',NULL,SYSDATE,USER,SYSDATE,USER,SYSDATE);

INSERT INTO LOP_HOC VALUES (1,1,1,SYSDATE,'A1',1,30,USER,SYSDATE,USER,SYSDATE);
INSERT INTO LOP_HOC VALUES (2,2,1,SYSDATE,'B1',1,30,USER,SYSDATE,USER,SYSDATE);
INSERT INTO LOP_HOC VALUES (3,1,1,SYSDATE,'A2',2,30,USER,SYSDATE,USER,SYSDATE);

INSERT INTO DANG_KY VALUES (101,1,SYSDATE,80,USER,SYSDATE,USER,SYSDATE);
INSERT INTO DANG_KY VALUES (101,2,SYSDATE,90,USER,SYSDATE,USER,SYSDATE);
INSERT INTO DANG_KY VALUES (101,3,SYSDATE,85,USER,SYSDATE,USER,SYSDATE);
INSERT INTO DANG_KY VALUES (102,1,SYSDATE,70,USER,SYSDATE,USER,SYSDATE);

COMMIT;
-- =========================
-- BÀI 1 - CÂU 1 (a ? j)
-- =========================

-- a
CREATE TABLE CAU1 (
    ID NUMBER,
    TEN VARCHAR2(20)
);

-- b
CREATE SEQUENCE CAU1SEQ START WITH 5 INCREMENT BY 5;

-- c


DECLARE
    v_ten VARCHAR2(50);
    v_id NUMBER;
BEGIN
    NULL;
END;


-- d
SET SERVEROUTPUT ON;

DECLARE
    v_ten VARCHAR2(50);
    v_id NUMBER;
BEGIN

    -- d: Sinh vien dang ki nhieu mon nhat
    SELECT Ten || ' ' || Ho
    INTO v_ten
    FROM SINH_VIEN
    WHERE MaSinhVien = (
        SELECT MaSinhVien FROM (
            SELECT MaSinhVien
            FROM DANG_KY
            GROUP BY MaSinhVien
            ORDER BY COUNT(*) DESC
        )
        WHERE ROWNUM = 1
    );

    INSERT INTO CAU1 VALUES (CAU1SEQ.NEXTVAL, v_ten);
    SAVEPOINT sp_a;

    -- e: Sinh vien dang ki it mon nhat
    SELECT Ten || ' ' || Ho
    INTO v_ten
    FROM SINH_VIEN
    WHERE MaSinhVien = (
        SELECT MaSinhVien FROM (
            SELECT MaSinhVien
            FROM DANG_KY
            GROUP BY MaSinhVien
            ORDER BY COUNT(*) ASC
        )
        WHERE ROWNUM = 1
    );

    INSERT INTO CAU1 VALUES (CAU1SEQ.NEXTVAL, v_ten);
    SAVEPOINT sp_b;

    -- f: Giang vien day nhieu lop nhat
    SELECT Ten || ' ' || Ho
    INTO v_ten
    FROM GIANG_VIEN
    WHERE MaGiangVien = (
        SELECT MaGiangVien FROM (
            SELECT MaGiangVien
            FROM LOP_HOC
            GROUP BY MaGiangVien
            ORDER BY COUNT(*) DESC
        )
        WHERE ROWNUM = 1
    );

    INSERT INTO CAU1 VALUES (CAU1SEQ.NEXTVAL, v_ten);
    SAVEPOINT sp_c;

    -- g: Lay ID vua them (fix loi ORA-01422)
    SELECT ID INTO v_id
    FROM CAU1
    WHERE TEN = v_ten
    AND ROWNUM = 1;

    DBMS_OUTPUT.PUT_LINE('ID GV nhieu lop: ' || v_id);

    -- h: rollback ve sp_b
    ROLLBACK TO sp_b;

    -- i: Giang vien day it lop nhat
    SELECT Ten || ' ' || Ho
    INTO v_ten
    FROM GIANG_VIEN
    WHERE MaGiangVien = (
        SELECT MaGiangVien FROM (
            SELECT MaGiangVien
            FROM LOP_HOC
            GROUP BY MaGiangVien
            ORDER BY COUNT(*) ASC
        )
        WHERE ROWNUM = 1
    );

    INSERT INTO CAU1 VALUES (v_id, v_ten);

    -- j: Them lai GV day nhieu lop
    SELECT Ten || ' ' || Ho
    INTO v_ten
    FROM GIANG_VIEN
    WHERE MaGiangVien = (
        SELECT MaGiangVien FROM (
            SELECT MaGiangVien
            FROM LOP_HOC
            GROUP BY MaGiangVien
            ORDER BY COUNT(*) DESC
        )
        WHERE ROWNUM = 1
    );

    INSERT INTO CAU1 VALUES (CAU1SEQ.NEXTVAL, v_ten);

    COMMIT;

END;
 COMMIT;

-- =========================
-- CÂU 2
-- =========================
SET SERVEROUTPUT ON;

DECLARE 
    v_ma        NUMBER := &ma_sinh_vien; 
    v_ho        VARCHAR2(25);
    v_ten       VARCHAR2(25);
    v_diachi    VARCHAR2(50);

    v_hoten     VARCHAR2(50); 
    v_so_lop    NUMBER; 
BEGIN 

    -- Ki?m tra sinh viên t?n t?i
    SELECT Ho || ' ' || Ten INTO v_hoten
    FROM SINH_VIEN
    WHERE MaSinhVien = v_ma;

    -- N?u có thì ??m s? l?p
    SELECT COUNT(*) INTO v_so_lop
    FROM DANG_KY
    WHERE MaSinhVien = v_ma;

    DBMS_OUTPUT.PUT_LINE('Ho ten: ' || v_hoten);
    DBMS_OUTPUT.PUT_LINE('So lop dang hoc: ' || v_so_lop);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Sinh vien chua ton tai, nhap thong tin moi');

        -- Nh?p thêm thông tin
        v_ho     := '&ho';
        v_ten    := '&ten';
        v_diachi := '&dia_chi';

        INSERT INTO SINH_VIEN (MaSinhVien, Ho, Ten, DiaChi)
        VALUES (v_ma, v_ho, v_ten, v_diachi);

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Da them sinh vien moi');
END;

/
-- =========================
-- BÀI 2 (IF)
-- =========================
--cau1
SET SERVEROUTPUT ON;

DECLARE 
    v_ma_gv  NUMBER := &ma_giao_vien; 
    v_so_lop NUMBER; 
    v_check  NUMBER;
BEGIN 

    SELECT COUNT(*) INTO v_check 
    FROM GIANG_VIEN 
    WHERE MaGiangVien = v_ma_gv;

    IF v_check = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Khong tim thay giao vien');
        RETURN;
    END IF;

    SELECT COUNT(*) INTO v_so_lop 
    FROM LOP_HOC 
    WHERE MaGiangVien = v_ma_gv; 

    IF v_so_lop >= 5 THEN 
        DBMS_OUTPUT.PUT_LINE('Giao vien nen nghi ngoi'); 
    ELSE 
        DBMS_OUTPUT.PUT_LINE('So lop: ' || v_so_lop); 
    END IF; 

END; 
--cau2
SET SERVEROUTPUT ON;

DECLARE 
    v_ma_sv NUMBER := &ma_sinh_vien; 
    v_ma_lop NUMBER := &ma_lop; 
    v_diem  NUMBER; 
    v_xep_loai VARCHAR2(2); 
    v_check NUMBER; 
BEGIN 

    SELECT COUNT(*) INTO v_check 
    FROM SINH_VIEN 
    WHERE MaSinhVien = v_ma_sv; 

    IF v_check = 0 THEN 
        DBMS_OUTPUT.PUT_LINE('SV khong ton tai'); 
        RETURN; 
    END IF; 

    SELECT COUNT(*) INTO v_check 
    FROM LOP_HOC 
    WHERE MaLopHoc = v_ma_lop; 

    IF v_check = 0 THEN 
        DBMS_OUTPUT.PUT_LINE('Lop khong ton tai'); 
        RETURN; 
    END IF; 

    SELECT DiemTongKet INTO v_diem 
    FROM DANG_KY 
    WHERE MaSinhVien = v_ma_sv AND MaLopHoc = v_ma_lop; 

    CASE 
        WHEN v_diem >= 90 THEN v_xep_loai := 'A'; 
        WHEN v_diem >= 80 THEN v_xep_loai := 'B'; 
        WHEN v_diem >= 70 THEN v_xep_loai := 'C'; 
        WHEN v_diem >= 50 THEN v_xep_loai := 'D'; 
        ELSE v_xep_loai := 'F'; 
    END CASE; 

    DBMS_OUTPUT.PUT_LINE('Diem: ' || v_diem || ' -> ' || v_xep_loai); 

EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Chua co diem'); 
END; 

-- =========================
-- BÀI 3 (CURSOR)
-- =========================

SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_mon IS
        SELECT MaMonHoc, MoTa FROM MON_HOC;

    CURSOR c_lop(p_mh NUMBER) IS
        SELECT MaLopHoc FROM LOP_HOC WHERE MaMonHoc = p_mh;

    v_dem NUMBER;
BEGIN
    FOR m IN c_mon LOOP
        DBMS_OUTPUT.PUT_LINE(m.MaMonHoc || ' ' || m.MoTa);

        FOR l IN c_lop(m.MaMonHoc) LOOP
            SELECT COUNT(*) INTO v_dem
            FROM DANG_KY
            WHERE MaLopHoc = l.MaLopHoc;

            DBMS_OUTPUT.PUT_LINE('   Lop ' || l.MaLopHoc || ' co ' || v_dem || ' SV');
        END LOOP;
    END LOOP;
END;
/

-- =========================
-- BÀI 4 (PROCEDURE + FUNCTION)
-- =========================

CREATE OR REPLACE PROCEDURE tim_ten_sv 
    (p_ma IN SINH_VIEN.MaSinhVien%TYPE,
     p_ten OUT SINH_VIEN.Ten%TYPE,
     p_ho OUT SINH_VIEN.Ho%TYPE)
IS
BEGIN
    SELECT Ten, Ho INTO p_ten, p_ho
    FROM SINH_VIEN
    WHERE MaSinhVien = p_ma;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_ten := NULL;
        p_ho := NULL;
END;

SET SERVEROUTPUT ON;

BEGIN
    in_ten_sv(101);
END;

CREATE OR REPLACE PROCEDURE in_ten_sv(p_ma NUMBER)
IS
    v_ten VARCHAR2(50);
    v_ho VARCHAR2(50);
BEGIN
    tim_ten_sv(p_ma, v_ten, v_ho);

    IF v_ten IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE(v_ten || ' ' || v_ho);
    END IF;
END;
--tinh tien
CREATE OR REPLACE PROCEDURE giam_hoc_phi
IS
BEGIN
    FOR r IN (
        SELECT m.MaMonHoc, m.MoTa, m.HocPhi
        FROM MON_HOC m
        WHERE (
            SELECT COUNT(*)
            FROM DANG_KY d
            JOIN LOP_HOC l ON d.MaLopHoc = l.MaLopHoc
            WHERE l.MaMonHoc = m.MaMonHoc
        ) > 15
    )
    LOOP
        UPDATE MON_HOC
        SET HocPhi = HocPhi * 0.95
        WHERE MaMonHoc = r.MaMonHoc;

        DBMS_OUTPUT.PUT_LINE('Da giam ' || r.MoTa);
    END LOOP;

    COMMIT;
END;
SET SERVEROUTPUT ON;

BEGIN
    giam_hoc_phi;
END;
SELECT MaMonHoc, MoTa, HocPhi FROM MON_HOC;
--Tong hoc phi
CREATE OR REPLACE FUNCTION tong_hoc_phi(p_ma NUMBER)
RETURN NUMBER
IS
    v_tong NUMBER;
    v_check NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_check
    FROM SINH_VIEN
    WHERE MaSinhVien = p_ma;

    IF v_check = 0 THEN
        RETURN NULL;
    END IF;

    SELECT NVL(SUM(m.HocPhi),0)
    INTO v_tong
    FROM DANG_KY d
    JOIN LOP_HOC l ON d.MaLopHoc = l.MaLopHoc
    JOIN MON_HOC m ON l.MaMonHoc = m.MaMonHoc
    WHERE d.MaSinhVien = p_ma;

    RETURN v_tong;
END;
SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Tong hoc phi: ' || tong_hoc_phi(101));
END;

-- =========================
-- BÀI 5 (TRIGGER)
-- =========================

CREATE OR REPLACE TRIGGER trg_sv
BEFORE INSERT OR UPDATE ON SINH_VIEN
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.NguoiTao := USER;
        :NEW.NgayTao := SYSDATE;
    END IF;

    :NEW.NguoiCapNhat := USER;
    :NEW.NgayCapNhat := SYSDATE;
END;
INSERT INTO SINH_VIEN (MaSinhVien, Ho, Ten, DiaChi)
VALUES (999, 'Test', 'Trigger', 'HCM');
SELECT MaSinhVien, NguoiTao, NgayTao, NguoiCapNhat, NgayCapNhat
FROM SINH_VIEN
WHERE MaSinhVien = 999;
--Trigger gi?i h?n ??ng kí
CREATE OR REPLACE TRIGGER trg_gioi_han
BEFORE INSERT ON DANG_KY
FOR EACH ROW
DECLARE
    v_dem NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_dem
    FROM DANG_KY
    WHERE MaSinhVien = :NEW.MaSinhVien;

    IF v_dem >= 3 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Vuot qua 3 lop');
    END IF;
END;
Show USER;
SET SERVEROUTPUT ON;

BEGIN
    print_student_name(101);
END;
SELECT MaSinhVien, COUNT(*)
FROM DANG_KY
GROUP BY MaSinhVien;
INSERT INTO DANG_KY (MaSinhVien, MaLopHoc, NgayDangKy)
VALUES (101, 999, SYSDATE);
