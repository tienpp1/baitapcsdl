--PHIEU HOC TAP 1
-- Tao bang
CREATE TABLE KHOA (
  Makhoa     VARCHAR2(10) PRIMARY KEY,
  Tenkhoa    VARCHAR2(100),
  Dienthoai  VARCHAR2(20)
);

CREATE TABLE LOP (
  Malop       VARCHAR2(10) PRIMARY KEY,
  Tenlop      VARCHAR2(100),
  Khoa        VARCHAR2(100),
  Hedt        VARCHAR2(50),
  Namnhaphoc  VARCHAR2(10),
  Makhoa      VARCHAR2(10),
  CONSTRAINT fk_lop_khoa FOREIGN KEY (Makhoa) REFERENCES KHOA(Makhoa)
);

-- Them du lieu
INSERT INTO KHOA VALUES('K01','CNTT','0256-111111');
INSERT INTO KHOA VALUES('K02','Kinh t?','0256-222222');
COMMIT;

-- Thu tuc them Khoa
CREATE OR REPLACE PROCEDURE SP_THEM_KHOA(
  p_makhoa     IN VARCHAR2,
  p_tenkhoa    IN VARCHAR2,
  p_dienthoai  IN VARCHAR2
) AS
  v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt FROM KHOA WHERE Tenkhoa = p_tenkhoa;
  IF v_cnt > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Tên khoa ?ã t?n t?i. Không thêm.');
  ELSE
    INSERT INTO KHOA(Makhoa, Tenkhoa, Dienthoai)
    VALUES(p_makhoa, p_tenkhoa, p_dienthoai);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('?ã thêm khoa thành công.');
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('L?i: '||SQLERRM);
    ROLLBACK;
END;

-- Thu tuc them Lop
CREATE OR REPLACE PROCEDURE SP_THEM_LOP(
  p_malop       IN VARCHAR2,
  p_tenlop      IN VARCHAR2,
  p_khoa        IN VARCHAR2,
  p_hedt        IN VARCHAR2,
  p_namnhaphoc  IN VARCHAR2,
  p_makhoa      IN VARCHAR2
) AS
  v_cnt_tenlop NUMBER;
  v_cnt_makhoa NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt_tenlop FROM LOP WHERE Tenlop = p_tenlop;
  IF v_cnt_tenlop > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Tên l?p ?ã t?n t?i. Không thêm.');
    RETURN;
  END IF;

  SELECT COUNT(*) INTO v_cnt_makhoa FROM KHOA WHERE Makhoa = p_makhoa;
  IF v_cnt_makhoa = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Makhoa không t?n t?i trong b?ng KHOA. Không thêm l?p.');
    RETURN;
  END IF;

  INSERT INTO LOP(Malop, Tenlop, Khoa, Hedt, Namnhaphoc, Makhoa)
  VALUES(p_malop, p_tenlop, p_khoa, p_hedt, p_namnhaphoc, p_makhoa);
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('?ã thêm l?p thành công.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('L?i: '||SQLERRM);
    ROLLBACK;
END;

-- Thu tuc them Khoa co out trang thai
CREATE OR REPLACE PROCEDURE SP_THEM_KHOA_OUT(
  p_makhoa     IN  VARCHAR2,
  p_tenkhoa    IN  VARCHAR2,
  p_dienthoai  IN  VARCHAR2,
  p_status     OUT NUMBER
) AS
  v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt FROM KHOA WHERE Tenkhoa = p_tenkhoa;
  IF v_cnt > 0 THEN
    p_status := 0; -- tên khoa ?ã t?n t?i
    DBMS_OUTPUT.PUT_LINE('Tên khoa ?ã t?n t?i.');
  ELSE
    INSERT INTO KHOA(Makhoa, Tenkhoa, Dienthoai)
    VALUES(p_makhoa, p_tenkhoa, p_dienthoai);
    COMMIT;
    p_status := 1; -- thêm thành công
    DBMS_OUTPUT.PUT_LINE('?ã thêm khoa (OUT=1).');
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    p_status := -1;
    DBMS_OUTPUT.PUT_LINE('L?i: '||SQLERRM);
    ROLLBACK;
END;

-- Thu tuc Them Lop voi Out status
CREATE OR REPLACE PROCEDURE SP_THEM_LOP_OUT(
  p_malop       IN  VARCHAR2,
  p_tenlop      IN  VARCHAR2,
  p_khoa        IN  VARCHAR2,
  p_hedt        IN  VARCHAR2,
  p_namnhaphoc  IN  VARCHAR2,
  p_makhoa      IN  VARCHAR2,
  p_status      OUT NUMBER
) AS
  v_cnt_tenlop NUMBER;
  v_cnt_makhoa NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt_tenlop FROM LOP WHERE Tenlop = p_tenlop;
  IF v_cnt_tenlop > 0 THEN
    p_status := 0;
    DBMS_OUTPUT.PUT_LINE('Tên l?p ?ã t?n t?i (OUT=0).');
    RETURN;
  END IF;

  SELECT COUNT(*) INTO v_cnt_makhoa FROM KHOA WHERE Makhoa = p_makhoa;
  IF v_cnt_makhoa = 0 THEN
    p_status := 1;
    DBMS_OUTPUT.PUT_LINE('Makhoa không t?n t?i (OUT=1).');
    RETURN;
  END IF;

  INSERT INTO LOP(Malop, Tenlop, Khoa, Hedt, Namnhaphoc, Makhoa)
  VALUES(p_malop, p_tenlop, p_khoa, p_hedt, p_namnhaphoc, p_makhoa);
  COMMIT;
  p_status := 2;
  DBMS_OUTPUT.PUT_LINE('?ã thêm l?p (OUT=2).');
EXCEPTION
  WHEN OTHERS THEN
    p_status := -1;
    DBMS_OUTPUT.PUT_LINE('L?i: '||SQLERRM);
    ROLLBACK;
END;
--PHIEU HOC TAP 2
-- Tao bang
CREATE TABLE tblChucVu (
    MaCV VARCHAR2(10) PRIMARY KEY,
    TenCV VARCHAR2(100)
);

CREATE TABLE tblNhanVien (
    MaNV VARCHAR2(10) PRIMARY KEY,
    MaCV VARCHAR2(10) REFERENCES tblChucVu(MaCV),
    TenNV VARCHAR2(100),
    NgaySinh DATE,
    LuongCanBan NUMBER,
    NgayCong NUMBER,
    PhuCap NUMBER
);
--Thu tuc SP_Them_Nhan_Vien
CREATE OR REPLACE PROCEDURE SP_Them_Nhan_Vien (
    p_MaNV       IN tblNhanVien.MaNV%TYPE,
    p_MaCV       IN tblNhanVien.MaCV%TYPE,
    p_TenNV      IN tblNhanVien.TenNV%TYPE,
    p_NgaySinh   IN tblNhanVien.NgaySinh%TYPE,
    p_LuongCB    IN tblNhanVien.LuongCanBan%TYPE,
    p_NgayCong   IN tblNhanVien.NgayCong%TYPE,
    p_PhuCap     IN tblNhanVien.PhuCap%TYPE
)
AS
    v_dem NUMBER := 0;
BEGIN
    -- Kiem tra ma chuc vu co ton tai khong
    SELECT COUNT(*) INTO v_dem
    FROM tblChucVu
    WHERE MaCV = p_MaCV;

    IF v_dem = 0 THEN
        DBMS_OUTPUT.PUT_LINE('MaCV khong ton tai!');
    ELSE
        INSERT INTO tblNhanVien
        VALUES (p_MaNV, p_MaCV, p_TenNV, p_NgaySinh, p_LuongCB, p_NgayCong, p_PhuCap);
        DBMS_OUTPUT.PUT_LINE('Them nhan vien thanh cong!');
    END IF;
END;
--Thu tuc SP_CapNhat_Nhan_Vien
CREATE OR REPLACE PROCEDURE SP_CapNhat_Nhan_Vien (
    p_MaNV       IN tblNhanVien.MaNV%TYPE,
    p_MaCV       IN tblNhanVien.MaCV%TYPE,
    p_TenNV      IN tblNhanVien.TenNV%TYPE,
    p_NgaySinh   IN tblNhanVien.NgaySinh%TYPE,
    p_LuongCB    IN tblNhanVien.LuongCanBan%TYPE,
    p_NgayCong   IN tblNhanVien.NgayCong%TYPE,
    p_PhuCap     IN tblNhanVien.PhuCap%TYPE
)
AS
    v_dem NUMBER := 0;
BEGIN
    -- Kiem tra ma chuc vu co ton tai
    SELECT COUNT(*) INTO v_dem
    FROM tblChucVu
    WHERE MaCV = p_MaCV;

    IF v_dem = 0 THEN
        DBMS_OUTPUT.PUT_LINE('MaCV khong ton tai!');
    ELSE
        UPDATE tblNhanVien
        SET MaCV = p_MaCV,
            TenNV = p_TenNV,
            NgaySinh = p_NgaySinh,
            LuongCanBan = p_LuongCB,
            NgayCong = p_NgayCong,
            PhuCap = p_PhuCap
        WHERE MaNV = p_MaNV;

        DBMS_OUTPUT.PUT_LINE('Cap nhat nhan vien thanh cong!');
    END IF;
END;
--Thu tuc SP_LuongLN
CREATE OR REPLACE PROCEDURE SP_LuongLN
AS
    CURSOR c IS SELECT MaNV, LuongCanBan, NgayCong, PhuCap FROM tblNhanVien;
    v_luong NUMBER;
BEGIN
    FOR r IN c LOOP
        v_luong := r.LuongCanBan * r.NgayCong + r.PhuCap;
        DBMS_OUTPUT.PUT_LINE('Nhan vien ' || r.MaNV || ' co luong: ' || v_luong);
    END LOOP;
END;
--Phieu Bai Tap 3
--Thu tuc sp_them_nhan_vien1
CREATE OR REPLACE PROCEDURE sp_them_nhan_vien1 (
    p_MaNV       IN tblNhanVien.MaNV%TYPE,
    p_MaCV       IN tblNhanVien.MaCV%TYPE,
    p_TenNV      IN tblNhanVien.TenNV%TYPE,
    p_NgaySinh   IN tblNhanVien.NgaySinh%TYPE,
    p_LuongCB    IN tblNhanVien.LuongCanBan%TYPE,
    p_NgayCong   IN tblNhanVien.NgayCong%TYPE,
    p_PhuCap     IN tblNhanVien.PhuCap%TYPE,
    p_ketqua     OUT NUMBER
)
AS
    v_dem NUMBER := 0;
BEGIN
    -- Kiem tra MaCV co ton tai khong
    SELECT COUNT(*) INTO v_dem
    FROM tblChucVu
    WHERE MaCV = p_MaCV;

    IF v_dem = 0 THEN
        p_ketqua := 1;
    ELSE
        INSERT INTO tblNhanVien
        VALUES (p_MaNV, p_MaCV, p_TenNV, p_NgaySinh, p_LuongCB, p_NgayCong, p_PhuCap);

        p_ketqua := 0;
    END IF;
END;
--Sua thu tuc-kiem tra MaNV trung lap
CREATE OR REPLACE PROCEDURE sp_kiemtra_Manv (
    p_MaNV   IN tblNhanVien.MaNV%TYPE,
    p_MaCV   IN tblNhanVien.MaCV%TYPE,
    p_ketqua OUT NUMBER
)
AS
    v_nv NUMBER := 0;
    v_cv NUMBER := 0;
BEGIN
    -- Ki?m tra MaNV
    SELECT COUNT(*) INTO v_nv
    FROM tblNhanVien
    WHERE MaNV = p_MaNV;

    IF v_nv > 0 THEN
        p_ketqua := 0;   -- trùng mã NV
        RETURN;
    END IF;

    -- Ki?m tra MaCV
    SELECT COUNT(*) INTO v_cv
    FROM tblChucVu
    WHERE MaCV = p_MaCV;

    IF v_cv = 0 THEN
        p_ketqua := 1;   -- ch?c v? không t?n t?i
    ELSE
        p_ketqua := 2;   -- h?p l?
    END IF;
END;
--Thu tuc cap nhat Ngaysinh cho nhan vien
CREATE OR REPLACE PROCEDURE sp_capnhat_NgaySinh (
    p_MaNV      IN tblNhanVien.MaNV%TYPE,
    p_NgaySinh  IN tblNhanVien.NgaySinh%TYPE,
    p_ketqua    OUT NUMBER
)
AS
    v_dem NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_dem
    FROM tblNhanVien
    WHERE MaNV = p_MaNV;

    IF v_dem = 0 THEN
        p_ketqua := 0;  -- không tìm th?y NV
    ELSE
        UPDATE tblNhanVien
        SET NgaySinh = p_NgaySinh
        WHERE MaNV = p_MaNV;

        p_ketqua := 1;
    END IF;
END;

