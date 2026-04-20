CREATE TABLE grade_audit_log (
    studentid NUMBER,
    classid NUMBER,
    grade_cu NUMBER,
    grade_moi NUMBER
);
CREATE TABLE LOG_DIEM (
    MASINHVIEN NUMBER,
    MALOPHOC   NUMBER,
    DIEM_CU    NUMBER,
    DIEM_MOI   NUMBER,
    NGAY_SUA   DATE
);
CREATE TABLE THONG_KE_DIEM (
    MALOPHOC NUMBER,
    SOSV NUMBER,
    DIEMTB NUMBER,
    DIEMMAX NUMBER,
    DIEMMIN NUMBER
);
INSERT INTO SINH_VIEN 
VALUES (201,'Mr','Nguyen','An','HCM','111',NULL,SYSDATE,USER,SYSDATE,USER,SYSDATE);

INSERT INTO SINH_VIEN
VALUES (1, 'Anh', 'Nguyen', 'A', 'HCM', '0123', 'CTY', SYSDATE, USER, SYSDATE, USER, SYSDATE);

INSERT INTO SINH_VIEN
VALUES (999, 'Anh', 'Nguyen', 'A', 'HCM', '0123', 'CTY', SYSDATE, USER, SYSDATE, USER, SYSDATE);

INSERT INTO SINH_VIEN 
VALUES (202,'Mr','Tran','Binh','HCM','222',NULL,SYSDATE,USER,SYSDATE,USER,SYSDATE);

INSERT INTO SINH_VIEN 
VALUES (203,'Mr','Le','Cuong','HN','333',NULL,SYSDATE,USER,SYSDATE,USER,SYSDATE);

INSERT INTO SINH_VIEN 
VALUES (204,'Mr','Pham','Dung','DN','444',NULL,SYSDATE,USER,SYSDATE,USER,SYSDATE);

INSERT INTO GIANG_VIEN 
VALUES (1,'Mr','Nguyen','ThayA',NULL,SYSDATE,USER,SYSDATE,USER,SYSDATE);

INSERT INTO GIANG_VIEN 
VALUES (2,'Mr','Tran','ThayB',NULL,SYSDATE,USER,SYSDATE,USER,SYSDATE);

INSERT INTO MON_HOC 
VALUES (1,'Database',1000,NULL,USER,SYSDATE,USER,SYSDATE);

INSERT INTO MON_HOC 
VALUES (2,'Programming',1200,NULL,USER,SYSDATE,USER,SYSDATE);

INSERT INTO MON_HOC 
VALUES (3,'Network',900,NULL,USER,SYSDATE,USER,SYSDATE);

INSERT INTO MON_HOC VALUES (4,'Web',1100,NULL,USER,SYSDATE,USER,SYSDATE);

INSERT INTO MON_HOC VALUES (5,'AI',1500,NULL,USER,SYSDATE,USER,SYSDATE);

-- l?p nh? ?? test "??y l?p"
INSERT INTO LOP_HOC 
VALUES (1,1,1,SYSDATE,'A1',1,2,USER,SYSDATE,USER,SYSDATE);

INSERT INTO LOP_HOC 
VALUES (2,1,2,SYSDATE,'A2',1,3,USER,SYSDATE,USER,SYSDATE);

INSERT INTO LOP_HOC 
VALUES (3,2,1,SYSDATE,'B1',1,3,USER,SYSDATE,USER,SYSDATE);

INSERT INTO LOP_HOC 
VALUES (4,3,2,SYSDATE,'C1',1,2,USER,SYSDATE,USER,SYSDATE);

-- l?p 1 ??y (capacity = 2)
INSERT INTO DANG_KY VALUES (201,1,SYSDATE,95,USER,SYSDATE,USER,SYSDATE);
INSERT INTO DANG_KY VALUES (202,1,SYSDATE,85,USER,SYSDATE,USER,SYSDATE);

-- l?p khác
INSERT INTO DANG_KY VALUES (203,2,SYSDATE,70,USER,SYSDATE,USER,SYSDATE);
INSERT INTO DANG_KY VALUES (204,2,SYSDATE,NULL,USER,SYSDATE,USER,SYSDATE);

INSERT INTO DANG_KY VALUES (201,3,SYSDATE,60,USER,SYSDATE,USER,SYSDATE);
INSERT INTO DANG_KY VALUES (202,3,SYSDATE,75,USER,SYSDATE,USER,SYSDATE);

INSERT INTO DANG_KY VALUES (203,4,SYSDATE,40,USER,SYSDATE,USER,SYSDATE);

INSERT INTO DANG_KY 
VALUES (202,2,SYSDATE,80,USER,SYSDATE,USER,SYSDATE);

INSERT INTO DANG_KY 
VALUES (203,3,SYSDATE,NULL,USER,SYSDATE,USER,SYSDATE);

INSERT INTO DANG_KY 
VALUES (204,3,SYSDATE,NULL,USER,SYSDATE,USER,SYSDATE);

INSERT INTO DANG_KY
VALUES (1, 1, SYSDATE, 50, USER, SYSDATE, USER, SYSDATE);

INSERT INTO DANG_KY
VALUES (2, 1, SYSDATE, 70, USER, SYSDATE, USER, SYSDATE);

COMMIT;

--BÀI 1 – VIEW
-- 1.1 T?ng h?p môn h?c
CREATE OR REPLACE VIEW vw_monhoc_tonghop AS
SELECT mh.MaMonHoc,
       mh.MoTa,
       mh.HocPhi,
       COUNT(DISTINCT lh.MaLopHoc) AS so_lop,
       COUNT(dk.MaSinhVien) AS tong_sv
FROM MON_HOC mh
LEFT JOIN LOP_HOC lh ON mh.MaMonHoc = lh.MaMonHoc
LEFT JOIN DANG_KY dk ON lh.MaLopHoc = dk.MaLopHoc
GROUP BY mh.MaMonHoc, mh.MoTa, mh.HocPhi;

SELECT * FROM vw_monhoc_tonghop;
-- 1.2 Tr?ng thái sinh viên
CREATE OR REPLACE VIEW vw_sinhvien_trangthai AS
SELECT sv.MaSinhVien,
       sv.Ho || ' ' || sv.Ten AS ho_ten,
       COUNT(dk.MaLopHoc) AS so_lop,
       NVL(SUM(mh.HocPhi),0) AS tong_hoc_phi,
       ROUND(AVG(dk.DiemTongKet),2) AS diem_tb
FROM SINH_VIEN sv
JOIN DANG_KY dk ON sv.MaSinhVien = dk.MaSinhVien
JOIN LOP_HOC lh ON dk.MaLopHoc = lh.MaLopHoc
JOIN MON_HOC mh ON lh.MaMonHoc = mh.MaMonHoc
GROUP BY sv.MaSinhVien, sv.Ho, sv.Ten
HAVING COUNT(dk.MaLopHoc) >= 1;

SELECT * FROM vw_sinhvien_trangthai;
-- 1.3 Tình tr?ng l?p h?c
CREATE OR REPLACE VIEW vw_lophoc_trong AS
SELECT lh.MaLopHoc,
       lh.MaMonHoc,
       mh.MoTa,
       gv.Ho || ' ' || gv.Ten AS ten_gv,
       lh.SiSoToiDa,
       COUNT(dk.MaSinhVien) AS so_da_dk,
       lh.SiSoToiDa - COUNT(dk.MaSinhVien) AS cho_trong,
       CASE
           WHEN lh.SiSoToiDa - COUNT(dk.MaSinhVien) > 0 THEN 'Con cho'
           ELSE 'Het cho'
       END AS trang_thai
FROM LOP_HOC lh
JOIN MON_HOC mh ON lh.MaMonHoc = mh.MaMonHoc
JOIN GIANG_VIEN gv ON lh.MaGiangVien = gv.MaGiangVien
LEFT JOIN DANG_KY dk ON lh.MaLopHoc = dk.MaLopHoc
GROUP BY lh.MaLopHoc, lh.MaMonHoc, mh.MoTa,
         gv.Ho, gv.Ten, lh.SiSoToiDa
HAVING lh.SiSoToiDa - COUNT(dk.MaSinhVien) > 0;

SELECT * FROM vw_lophoc_trong;
-- 1.4 Top môn h?c
CREATE OR REPLACE VIEW vw_top_monhoc AS
SELECT MaMonHoc, MoTa, HocPhi, tong_dk, hang
FROM (
    SELECT mh.MaMonHoc,
           mh.MoTa,
           mh.HocPhi,
           COUNT(dk.MaSinhVien) AS tong_dk,
           RANK() OVER (ORDER BY COUNT(dk.MaSinhVien) DESC) AS hang
    FROM MON_HOC mh
    LEFT JOIN LOP_HOC lh ON mh.MaMonHoc = lh.MaMonHoc
    LEFT JOIN DANG_KY dk ON lh.MaLopHoc = dk.MaLopHoc
    GROUP BY mh.MaMonHoc, mh.MoTa, mh.HocPhi
)
WHERE hang <= 5;

SELECT * FROM vw_top_monhoc;
-- 1.5 ??ng ký ch?a có ?i?m
CREATE OR REPLACE VIEW vw_dangky_chuadiem AS
SELECT *
FROM DANG_KY
WHERE DiemTongKet IS NULL;

SELECT * FROM vw_dangky_chuadiem;
--BÀI 2 – PROCEDURE
-- 2.1 ??ng ký h?c
CREATE OR REPLACE PROCEDURE dang_ky_hoc
(
    p_masv IN NUMBER,
    p_malop IN NUMBER
)
IS
    v_check NUMBER;
    v_siso NUMBER;
    v_dadangky NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_check
    FROM SINH_VIEN
    WHERE MaSinhVien = p_masv;

    IF v_check = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Khong ton tai SV');
        RETURN;
    END IF;

    SELECT SiSoToiDa INTO v_siso
    FROM LOP_HOC
    WHERE MaLopHoc = p_malop;

    SELECT COUNT(*) INTO v_dadangky
    FROM DANG_KY
    WHERE MaLopHoc = p_malop;

    IF v_dadangky >= v_siso THEN
        DBMS_OUTPUT.PUT_LINE('Lop da day');
        RETURN;
    END IF;

    INSERT INTO DANG_KY(MaSinhVien, MaLopHoc, NgayDangKy)
    VALUES(p_masv, p_malop, SYSDATE);

    COMMIT;
END;
BEGIN
    dang_ky_hoc(102, 2);
END;
SELECT * FROM DANG_KY;
-- 2.2 C?p nh?t ?i?m
CREATE OR REPLACE PROCEDURE cap_nhat_diem
(
    p_masv IN NUMBER,
    p_malop IN NUMBER,
    p_diem IN NUMBER
)
IS
BEGIN
    IF p_diem < 0 OR p_diem > 100 THEN
        DBMS_OUTPUT.PUT_LINE('Diem khong hop le');
        RETURN;
    END IF;

    UPDATE DANG_KY
    SET DiemTongKet = p_diem
    WHERE MaSinhVien = p_masv AND MaLopHoc = p_malop;

    COMMIT;
END;
SELECT * 
FROM DANG_KY
WHERE MaSinhVien = 203;

BEGIN
    cap_nhat_diem(203, 3, 85);
END;
-- 2.3 Chuy?n l?p
CREATE OR REPLACE PROCEDURE chuyen_lop
(
    p_masv IN NUMBER,
    p_lopcu IN NUMBER,
    p_lopmoi IN NUMBER
)
IS
    v_siso NUMBER;
    v_dadangky NUMBER;
    v_check NUMBER;
BEGIN
    -- ki?m tra có h?c l?p c? không
    SELECT COUNT(*) INTO v_check
    FROM DANG_KY
    WHERE MaSinhVien = p_masv AND MaLopHoc = p_lopcu;

    IF v_check = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SV khong hoc lop cu');
        RETURN;
    END IF;

    -- ki?m tra ?ã h?c l?p m?i ch?a
    SELECT COUNT(*) INTO v_check
    FROM DANG_KY
    WHERE MaSinhVien = p_masv AND MaLopHoc = p_lopmoi;

    IF v_check > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SV da hoc lop moi');
        RETURN;
    END IF;

    -- ki?m tra s? s? l?p m?i
    SELECT SiSoToiDa INTO v_siso
    FROM LOP_HOC
    WHERE MaLopHoc = p_lopmoi;

    SELECT COUNT(*) INTO v_dadangky
    FROM DANG_KY
    WHERE MaLopHoc = p_lopmoi;

    IF v_dadangky >= v_siso THEN
        DBMS_OUTPUT.PUT_LINE('Lop moi da day');
        RETURN;
    END IF;

    -- chuy?n l?p
    DELETE FROM DANG_KY
    WHERE MaSinhVien = p_masv AND MaLopHoc = p_lopcu;

    INSERT INTO DANG_KY(MaSinhVien, MaLopHoc, NgayDangKy)
    VALUES(p_masv, p_lopmoi, SYSDATE);

    COMMIT;
END;

SELECT * 
FROM DANG_KY
WHERE MaSinhVien = 202;
BEGIN
    chuyen_lop(202, 3, 4);
END;
-- 2.4 In danh sách l?p
CREATE OR REPLACE PROCEDURE in_ds_lop(p_malop NUMBER)
IS
    v_count NUMBER := 0;
BEGIN
    FOR rec IN (
        SELECT sv.Ho || ' ' || sv.Ten AS ten,
               dk.DiemTongKet
        FROM DANG_KY dk
        JOIN SINH_VIEN sv ON dk.MaSinhVien = sv.MaSinhVien
        WHERE dk.MaLopHoc = p_malop
    ) LOOP
        v_count := v_count + 1;
        DBMS_OUTPUT.PUT_LINE(v_count || '. ' || rec.ten || ' - ' || rec.DiemTongKet);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Tong SV: ' || v_count);
END;
SET SERVEROUTPUT ON;

BEGIN
    in_ds_lop(1);
END;
--2.5 h?y ??ng kí h?c
CREATE OR REPLACE PROCEDURE sync_grade_from_enrollment
IS
    v_check NUMBER;
    v_dem_insert NUMBER := 0;
    v_dem_update NUMBER := 0;
BEGIN
    FOR rec IN (
        SELECT 
            MA_SINH_VIEN, 
            MA_LOP_HOC, 
            DIEM_TONG_KET AS DIEM   -- ? QUAN TR?NG
        FROM DANG_KY
        WHERE DIEM_TONG_KET IS NOT NULL
    ) LOOP

        SELECT COUNT(*)
        INTO v_check
        FROM DIEM
        WHERE MA_SINH_VIEN = rec.MA_SINH_VIEN
          AND MA_LOP_HOC = rec.MA_LOP_HOC;

        IF v_check = 0 THEN
            INSERT INTO DIEM
            (MA_SINH_VIEN, MA_LOP_HOC, DIEM_SO,
             NGUOI_TAO, NGAY_TAO, NGUOI_CAP_NHAT, NGAY_CAP_NHAT)
            VALUES
            (rec.MA_SINH_VIEN, rec.MA_LOP_HOC, rec.DIEM,
             USER, SYSDATE, USER, SYSDATE);

            v_dem_insert := v_dem_insert + 1;
        ELSE
            UPDATE DIEM
            SET DIEM_SO = rec.DIEM,
                NGUOI_CAP_NHAT = USER,
                NGAY_CAP_NHAT = SYSDATE
            WHERE MA_SINH_VIEN = rec.MA_SINH_VIEN
              AND MA_LOP_HOC = rec.MA_LOP_HOC;

            v_dem_update := v_dem_update + 1;
        END IF;

    END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('INSERT: ' || v_dem_insert);
    DBMS_OUTPUT.PUT_LINE('UPDATE: ' || v_dem_update);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;


SHOW USER;
--BÀI 3 – TRIGGER
-- 3.1 Không cho ??ng ký khi l?p ??y
CREATE OR REPLACE TRIGGER trg_check_capacity
BEFORE INSERT ON DANG_KY
FOR EACH ROW
DECLARE
    v_siso NUMBER;
    v_dangky NUMBER;
BEGIN
    SELECT SiSoToiDa INTO v_siso
    FROM LOP_HOC
    WHERE MaLopHoc = :NEW.MaLopHoc;

    SELECT COUNT(*) INTO v_dangky
    FROM DANG_KY
    WHERE MaLopHoc = :NEW.MaLopHoc;

    IF v_dangky >= v_siso THEN
        RAISE_APPLICATION_ERROR(-20010, 'Lop da day!');
    END IF;
END;
SELECT * FROM DANG_KY
WHERE MaLopHoc = 1;

INSERT INTO DANG_KY
VALUES (999, 1, SYSDATE, NULL, USER, SYSDATE, USER, SYSDATE);
-- 3.2 Log thay ??i ?i?m
CREATE OR REPLACE TRIGGER TRG_LOG_DIEM
AFTER UPDATE OF DIEMTONGKET ON DANG_KY
FOR EACH ROW
BEGIN
    IF NVL(:OLD.DIEMTONGKET, -1) <> NVL(:NEW.DIEMTONGKET, -1) THEN
        INSERT INTO LOG_DIEM
        VALUES (
            :OLD.MASINHVIEN,
            :OLD.MALOPHOC,
            :OLD.DIEMTONGKET,
            :NEW.DIEMTONGKET,
            SYSDATE
        );
    END IF;
END;

UPDATE DANG_KY
SET DIEMTONGKET = 90
WHERE MASINHVIEN = 204 AND MALOPHOC = 2;

SELECT * FROM LOG_DIEM;
--3.3 xóa môn h?c
CREATE OR REPLACE TRIGGER trg_khong_xoa_monhoc
BEFORE DELETE ON MON_HOC
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM LOP_HOC
    WHERE MAMONHOC = :OLD.MAMONHOC;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Mon hoc da co lop, khong duoc xoa');
    END IF;
END;

SELECT * FROM MON_HOC;
DELETE FROM MON_HOC WHERE MAMONHOC = 1;
--3.4 c?p nh?t b?ng th?ng kê t? ??ng
CREATE OR REPLACE TRIGGER TRG_THONGKE_DIEM
AFTER UPDATE OF DIEMTONGKET ON DANG_KY
FOR EACH ROW
BEGIN
    -- xóa d? li?u c? c?a l?p
    DELETE FROM THONG_KE_DIEM
    WHERE MALOPHOC = :NEW.MALOPHOC;

    -- insert l?i th?ng kê ??n gi?n (ch? d?a trên dòng v?a update)
    INSERT INTO THONG_KE_DIEM
    VALUES (
        :NEW.MALOPHOC,
        1,
        :NEW.DIEMTONGKET,
        :NEW.DIEMTONGKET,
        :NEW.DIEMTONGKET
    );
END;
UPDATE DANG_KY
SET DIEMTONGKET = 88
WHERE MASINHVIEN = 201 AND MALOPHOC = 1;

COMMIT;

SELECT * FROM THONG_KE_DIEM;

--BÀI 4 – T?NG H?P
--T?O VIEW
CREATE OR REPLACE VIEW vw_gv_soluonglop AS
SELECT 
    gv.MaGiangVien,
    gv.Ho || ' ' || gv.Ten AS ten,
    COUNT(DISTINCT lh.MaLopHoc) AS so_lop,
    COUNT(dk.MaSinhVien) AS tong_sv,
    ROUND(AVG(dk.DiemTongKet),2) AS diem_tb_chung,
    CASE
        WHEN COUNT(DISTINCT lh.MaLopHoc) >= 3 THEN 'Ban nhieu'
        WHEN COUNT(DISTINCT lh.MaLopHoc) = 2 THEN 'Binh thuong'
        ELSE 'Nhe nhang'
    END AS muc_ban
FROM GIANG_VIEN gv
LEFT JOIN LOP_HOC lh ON gv.MaGiangVien = lh.MaGiangVien
LEFT JOIN DANG_KY dk ON lh.MaLopHoc = dk.MaLopHoc
GROUP BY gv.MaGiangVien, gv.Ho, gv.Ten;
SELECT * FROM vw_gv_soluonglop;
--T?O PROCEDURE
CREATE OR REPLACE PROCEDURE bao_cao_he_thong
IS
    v_mon NUMBER;
    v_lop NUMBER;
    v_sv  NUMBER;
    v_gv  NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_mon FROM MON_HOC;
    SELECT COUNT(*) INTO v_lop FROM LOP_HOC;
    SELECT COUNT(*) INTO v_sv  FROM SINH_VIEN;
    SELECT COUNT(*) INTO v_gv  FROM GIANG_VIEN;

    DBMS_OUTPUT.PUT_LINE('===== BAO CAO HE THONG =====');
    DBMS_OUTPUT.PUT_LINE('Mon hoc : ' || v_mon);
    DBMS_OUTPUT.PUT_LINE('Lop hoc : ' || v_lop);
    DBMS_OUTPUT.PUT_LINE('Sinh vien: ' || v_sv);
    DBMS_OUTPUT.PUT_LINE('Giang vien: ' || v_gv);
    DBMS_OUTPUT.PUT_LINE('----------------------------');

    FOR rec IN (SELECT * FROM vw_gv_soluonglop) LOOP
        DBMS_OUTPUT.PUT_LINE(
            rec.ten || 
            ' | ' || rec.so_lop || ' lop' ||
            ' | ' || rec.tong_sv || ' SV' ||
            ' | DTB: ' || NVL(TO_CHAR(rec.diem_tb_chung),'--') ||
            ' | ' || rec.muc_ban
        );
    END LOOP;
END;
SET SERVEROUTPUT ON;

BEGIN
    bao_cao_he_thong;
END;