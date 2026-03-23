-- T?o b?ng Hãng S?n Xu?t
CREATE TABLE HangSX (
    MaHangSX VARCHAR2(10) PRIMARY KEY,
    TenHang NVARCHAR2(50),
    DiaChi NVARCHAR2(100),
    SoDT VARCHAR2(20),
    Email VARCHAR2(50)
);

-- T?o b?ng Nhân Viên 
CREATE TABLE NhanVien (
    MaNV VARCHAR2(10) PRIMARY KEY,
    TenNV NVARCHAR2(50),
    GioiTinh NVARCHAR2(5),
    DiaChi NVARCHAR2(100),
    SoDT VARCHAR2(20),
    Email VARCHAR2(50),
    TenPhong NVARCHAR2(50)
);

-- T?o b?ng S?n Ph?m 
CREATE TABLE SanPham (
    MaSP VARCHAR2(10) PRIMARY KEY,
    MaHangSX VARCHAR2(10),
    TenSP NVARCHAR2(50),
    SoLuong NUMBER DEFAULT 0,
    MauSac NVARCHAR2(20),
    GiaBan NUMBER,
    DonViTinh NVARCHAR2(20),
    MoTa NVARCHAR2(200),
    CONSTRAINT FK_SP_HangSX FOREIGN KEY (MaHangSX) REFERENCES HangSX(MaHangSX)
);
-- T?o b?ng Phi?u Nh?p 
CREATE TABLE PNhap (
    SoHDN VARCHAR2(10) PRIMARY KEY,
    NgayNhap DATE,
    MaNV VARCHAR2(10),
    CONSTRAINT FK_PNhap_NV FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

-- T?o b?ng chi ti?t Nh?p 
CREATE TABLE Nhap (
    SoHDN VARCHAR2(10),
    MaSP VARCHAR2(10),
    SoLuongN NUMBER,
    DonGiaN NUMBER,
    CONSTRAINT PK_Nhap PRIMARY KEY (SoHDN, MaSP), -- Khóa chính k?t h?p [cite: 24]
    CONSTRAINT FK_Nhap_PNhap FOREIGN KEY (SoHDN) REFERENCES PNhap(SoHDN),
    CONSTRAINT FK_Nhap_SP FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

-- T?o b?ng Phi?u Xu?t 
CREATE TABLE PXuat (
    SoHDX VARCHAR2(10) PRIMARY KEY,
    NgayXuat DATE,
    MaNV VARCHAR2(10),
    CONSTRAINT FK_PXuat_NV FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

-- T?o b?ng chi ti?t Xu?t 
CREATE TABLE Xuat (
    SoHDX VARCHAR2(10),
    MaSP VARCHAR2(10),
    SoLuongX NUMBER,
    CONSTRAINT PK_Xuat PRIMARY KEY (SoHDX, MaSP), -- Khóa chính k?t h?p [cite: 25]
    CONSTRAINT FK_Xuat_PXuat FOREIGN KEY (SoHDX) REFERENCES PXuat(SoHDX),
    CONSTRAINT FK_Xuat_SP FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);
--Phieuhoctap1
--INSERT b?ng NHAP – trg_Nhap
CREATE OR REPLACE TRIGGER trg_Nhap
BEFORE INSERT ON Nhap
FOR EACH ROW
DECLARE
    v_dem NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_dem FROM SanPham WHERE MaSP = :NEW.MaSP;
    IF v_dem = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Ma san pham khong ton tai'); -- [cite: 5, 16]
    END IF;
    IF :NEW.SoLuongN <= 0 OR :NEW.DonGiaN <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'SoLuong va DonGia phai > 0'); -- 
    END IF;
    UPDATE SanPham SET SoLuong = SoLuong + :NEW.SoLuongN WHERE MaSP = :NEW.MaSP;
END;
SELECT * FROM Nhap;
INSERT INTO Nhap (SoHDN, MaSP, SoLuongN, DonGiaN) VALUES ('N01', 'SP01', 5, 12000000);
SELECT MaSP, SoLuong FROM SanPham WHERE MaSP = 'SP01'; 
--INSERT b?ng XUAT – trg_xuat
CREATE OR REPLACE TRIGGER trg_xuat
BEFORE INSERT ON Xuat
FOR EACH ROW
DECLARE
 v_dem NUMBER := 0;
v_soluong NUMBER := 0; 
BEGIN
    SELECT COUNT(*) INTO v_dem FROM SanPham WHERE MaSP = :NEW.MaSP;
    IF v_dem = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Ma san pham khong ton tai');
    END IF;
    SELECT SoLuong INTO v_soluong FROM SanPham WHERE MaSP = :NEW.MaSP;
    IF :NEW.SoLuongX > v_soluong THEN
        RAISE_APPLICATION_ERROR(-20003, 'So luong xuat vuot qua ton kho');
    END IF;
    UPDATE SanPham SET SoLuong = SoLuong - :NEW.SoLuongX WHERE MaSP = :NEW.MaSP;
END;
SELECT * FROM Xuat;
INSERT INTO Xuat (SoHDX, MaSP, SoLuongX) VALUES ('X01', 'SP01', 3);
SELECT MaSP, SoLuong FROM SanPham WHERE MaSP = 'SP01'; 
--DELETE b?ng XUAT – trg_XoaXuat
CREATE OR REPLACE TRIGGER trg_XoaXuat
AFTER DELETE ON Xuat
FOR EACH ROW
BEGIN
 UPDATE SanPham SET SoLuong = SoLuong + :OLD.SoLuongX WHERE MaSP = :OLD.MaSP;
END;
SELECT * FROM Xuat;
DELETE FROM Xuat WHERE SoHDX = 'X01' AND MaSP = 'SP01';
SELECT MaSP, SoLuong FROM SanPham WHERE MaSP = 'SP01';
--T?o Package l?u bi?n ??m chung
CREATE OR REPLACE PACKAGE pkg_state AS
    g_row_count NUMBER := 0;
END pkg_state;
--Phieuhoctap 2
--Trigger UPDATE b?ng XUAT – trg_CapNhatXuat
CREATE OR REPLACE TRIGGER trg_CapNhatXuat
FOR UPDATE ON Xuat
COMPOUND TRIGGER
BEFORE STATEMENT IS
BEGIN
pkg_state.g_row_count := 0; 
END BEFORE STATEMENT;
 BEFORE EACH ROW IS
v_soluong NUMBER := 0;
BEGIN
pkg_state.g_row_count := pkg_state.g_row_count + 1;
 IF pkg_state.g_row_count > 1 THEN
 RAISE_APPLICATION_ERROR(-20001, 'Chi duoc cap nhat 1 ban ghi'); 
END IF;
IF :NEW.SoLuongX <> :OLD.SoLuongX THEN
SELECT SoLuong INTO v_soluong FROM SanPham WHERE MaSP = :NEW.MaSP;
IF (:NEW.SoLuongX - :OLD.SoLuongX) > v_soluong THEN
RAISE_APPLICATION_ERROR(-20004, 'Khong du hang de xuat');
END IF;
 UPDATE SanPham SET SoLuong = SoLuong - (:NEW.SoLuongX - :OLD.SoLuongX)
 WHERE MaSP = :NEW.MaSP;
 END IF;
 END BEFORE EACH ROW;
END trg_CapNhatXuat;
SELECT * FROM XUAT;
INSERT INTO Xuat (SoHDX, MaSP, SoLuongX) VALUES ('X01', 'SP01', 3);
UPDATE Xuat SET SoLuongX = 5 WHERE SoHDX = 'X01' AND MaSP = 'SP01';
SELECT MaSP, SoLuong FROM SanPham WHERE MaSP = 'SP01';
--Trigger UPDATE b?ng NHAP – trg_CapNhatNhap
CREATE OR REPLACE TRIGGER trg_CapNhatNhap
FOR UPDATE ON Nhap
COMPOUND TRIGGER
BEFORE STATEMENT IS
BEGIN
pkg_state.g_row_count := 0;
END BEFORE STATEMENT;
 BEFORE EACH ROW IS
BEGIN
pkg_state.g_row_count := pkg_state.g_row_count + 1;
IF pkg_state.g_row_count > 1 THEN
RAISE_APPLICATION_ERROR(-20001, 'Chi duoc cap nhat 1 ban ghi');
END IF;
IF :NEW.SoLuongN <> :OLD.SoLuongN THEN
UPDATE SanPham SET SoLuong = SoLuong + (:NEW.SoLuongN - :OLD.SoLuongN)
WHERE MaSP = :NEW.MaSP;
END IF;
END BEFORE EACH ROW;
END trg_CapNhatNhap;
SELECT * FROM NHAP;
UPDATE Nhap SET SoLuongN = 10 WHERE SoHDN = 'N01' AND MaSP = 'SP01';
SELECT MaSP, SoLuong FROM SanPham WHERE MaSP = 'SP01';
--Trigger DELETE b?ng NHAP – trg_XoaNhap
CREATE OR REPLACE TRIGGER trg_XoaNhap
AFTER DELETE ON Nhap
FOR EACH ROW
BEGIN
UPDATE SanPham SET SoLuong = SoLuong - :OLD.SoLuongN WHERE MaSP = :OLD.MaSP;
END;
SELECT MaSP, TenSP, SoLuong FROM SanPham WHERE MaSP = 'SP01';
DELETE FROM Nhap WHERE SoHDN = 'N01' AND MaSP = 'SP01';
--phieuhoctap 3
-- T?o b?ng Phong
CREATE TABLE Phong (
    MaPhong VARCHAR2(10) PRIMARY KEY,
    LoaiPhong NVARCHAR2(50),
    TrangThai VARCHAR2(20), 
    GiaTheoGio NUMBER,
    GiaTheoNgay NUMBER,
    SoNguoiToiDa NUMBER
);

-- T?o b?ng KhachHang
CREATE TABLE KhachHang (
    MaKH VARCHAR2(10) PRIMARY KEY,
    HoTen NVARCHAR2(100),
    CCCD VARCHAR2(20),
    SoDT VARCHAR2(20),
    Email VARCHAR2(50),
    QuocTich NVARCHAR2(50)
);
-- T?o b?ng HoaDon
CREATE TABLE HoaDon (
    MaHD VARCHAR2(10) PRIMARY KEY,
    MaKH VARCHAR2(10),
    MaPhong VARCHAR2(10),
    NgayNhan DATE,
    NgayTra DATE,
    SoNguoi NUMBER,
    TongTien NUMBER DEFAULT 0,
    TrangThai VARCHAR2(20), -- 'CHO_NHAN' | 'DANG_O' | 'DA_TRA' | 'HUY'
    CONSTRAINT FK_HD_KhachHang FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
    CONSTRAINT FK_HD_Phong FOREIGN KEY (MaPhong) REFERENCES Phong(MaPhong)
);

-- T?o b?ng ChiPhiPhuThu
CREATE TABLE ChiPhiPhuThu (
    MaCP VARCHAR2(10) PRIMARY KEY,
    MaHD VARCHAR2(10),
    MoTa NVARCHAR2(200),
    SoTien NUMBER,
    ThoiGian DATE,
    CONSTRAINT FK_CP_HoaDon FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD)
);

-- T?o b?ng LichSuPhong
CREATE TABLE LichSuPhong (
    MaLS NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY, -- T? ??ng t?ng
    MaPhong VARCHAR2(10),
    MaHD VARCHAR2(10),
    NgayNhan DATE,
    NgayTra DATE,
    GhiChu NVARCHAR2(200),
    CONSTRAINT FK_LS_Phong FOREIGN KEY (MaPhong) REFERENCES Phong(MaPhong),
    CONSTRAINT FK_LS_HoaDon FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD)
);
--Trigger INSERT b?ng HoaDon — trg_DatPhong
CREATE OR REPLACE TRIGGER trg_DatPhong
BEFORE INSERT ON HoaDon
FOR EACH ROW
DECLARE
    v_trangthai VARCHAR2(20);
    v_toida NUMBER;
    v_gia NUMBER;
BEGIN
    SELECT TrangThai, SoNguoiToiDa, GiaTheoNgay 
    INTO v_trangthai, v_toida, v_gia
    FROM Phong WHERE MaPhong = :NEW.MaPhong;
    IF v_trangthai <> 'TRONG' THEN
        RAISE_APPLICATION_ERROR(-20005, 'Phong nay hien tai khong trong');
    END IF;
    IF :NEW.SoNguoi > v_toida THEN
        RAISE_APPLICATION_ERROR(-20006, 'Vuot qua so nguoi toi da');
    END IF;
    IF :NEW.NgayNhan >= :NEW.NgayTra OR :NEW.NgayNhan < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20007, 'Ngay thue khong hop le');
    END IF;
    :NEW.TongTien := (:NEW.NgayTra - :NEW.NgayNhan) * v_gia;
    UPDATE Phong SET TrangThai = 'DA_THUE' WHERE MaPhong = :NEW.MaPhong;
END;
SELECT * FROM HOADON;
SELECT MaHD, TongTien, TrangThai FROM HoaDon WHERE MaHD = 'HD10';
SELECT MaPhong, TrangThai FROM Phong WHERE MaPhong = 'P201';
INSERT INTO HoaDon (MaHD, MaKH, MaPhong, NgayNhan, NgayTra, SoNguoi, TrangThai)
VALUES ('HD10', 'KH02', 'P201', TRUNC(SYSDATE), TRUNC(SYSDATE) + 2, 2, 'CHO_NHAN');
--Trigger UPDATE TrangThai HoaDon — trg_CapNhatTrangThaiHD
CREATE OR REPLACE TRIGGER trg_CapNhatTrangThaiHD
BEFORE UPDATE OF TrangThai ON HoaDon
FOR EACH ROW
BEGIN
    IF :OLD.TrangThai = 'CHO_NHAN' THEN
        IF :NEW.TrangThai NOT IN ('DANG_O', 'HUY') THEN
            RAISE_APPLICATION_ERROR(-20008, 'Trang thai chuyen doi khong hop le');
        END IF;
    ELSIF :OLD.TrangThai = 'DANG_O' THEN
        IF :NEW.TrangThai <> 'DA_TRA' THEN
            RAISE_APPLICATION_ERROR(-20008, 'Phai chuyen sang DA_TRA');
        END IF;
    ELSIF :OLD.TrangThai IN ('DA_TRA', 'HUY') THEN
        RAISE_APPLICATION_ERROR(-20009, 'Khong the thay doi hoa don da ket thuc');
    END IF;
    IF :NEW.TrangThai = 'DA_TRA' THEN
        UPDATE Phong SET TrangThai = 'TRONG' WHERE MaPhong = :NEW.MaPhong;
        INSERT INTO LichSuPhong(MaPhong, MaHD, NgayNhan, NgayTra, GhiChu)
        VALUES(:NEW.MaPhong, :NEW.MaHD, :NEW.NgayNhan, :NEW.NgayTra, 'Khach da tra phong');
    ELSIF :NEW.TrangThai = 'HUY' THEN
        UPDATE Phong SET TrangThai = 'TRONG' WHERE MaPhong = :NEW.MaPhong;
    END IF;
END;
SELECT MaPhong, TrangThai FROM Phong WHERE MaPhong = 'P201';
SELECT * FROM LichSuPhong WHERE MaHD = 'HD10';
UPDATE HoaDon SET TrangThai = 'DANG_O' WHERE MaHD = 'HD10';
UPDATE HoaDon SET TrangThai = 'DA_TRA' WHERE MaHD = 'HD10';
--Compound Trigger UPDATE ChiPhiPhuThu — trg_SuaChiPhi
CREATE OR REPLACE TRIGGER trg_SuaChiPhi
FOR INSERT OR UPDATE ON ChiPhiPhuThu
COMPOUND TRIGGER
    v_dem_cp NUMBER := 0; 
    BEFORE STATEMENT IS BEGIN
        v_dem_cp := 0; 
    END BEFORE STATEMENT;
    BEFORE EACH ROW IS BEGIN
        v_dem_cp := v_dem_cp + 1;
        IF v_dem_cp > 5 THEN
            RAISE_APPLICATION_ERROR(-20010, 'Toi da 5 chi phi trong 1 lan');
        END IF;
        IF :NEW.SoTien <= 0 OR :NEW.SoTien >= 50000000 THEN
            RAISE_APPLICATION_ERROR(-20011, 'So tien phu thu khong hop le');
        END IF;
    END BEFORE EACH ROW;
    AFTER STATEMENT IS BEGIN
        UPDATE HoaDon h
        SET TongTien = TongTien + (SELECT NVL(SUM(SoTien),0) FROM ChiPhiPhuThu WHERE MaHD = h.MaHD)
        WHERE MaHD IN (SELECT MaHD FROM ChiPhiPhuThu);
    END AFTER STATEMENT;
END;
SELECT MaHD, TongTien FROM HoaDon WHERE MaHD = 'HD10';
INSERT INTO ChiPhiPhuThu (MaCP, MaHD, MoTa, SoTien, ThoiGian)
VALUES ('CP01', 'HD10', 'Tien nuoc uong', 50000, SYSDATE);
-- T?o trình t? ch?y t? 1, dùng ?? t?o mã HD0001, HD0002...
CREATE SEQUENCE SEQ_HD 
START WITH 1 
INCREMENT BY 1;
-- View này ch? hi?n các phòng ?ang có tr?ng thái 'TRONG'
CREATE OR REPLACE VIEW vw_PhongTrong AS
SELECT MaPhong, LoaiPhong, GiaTheoNgay, SoNguoiToiDa
FROM Phong
WHERE TrangThai = 'TRONG';
--INSTEAD OF Trigger trên View — trg_vwPhongTrong_ins
CREATE OR REPLACE TRIGGER trg_vwPhongTrong_ins
INSTEAD OF INSERT ON vw_PhongTrong
FOR EACH ROW
DECLARE
    v_MaKH VARCHAR2(10);
    v_MaHD VARCHAR2(10);
BEGIN
    v_MaHD := 'HD' || TO_CHAR(SEQ_HD.NEXTVAL, 'FM0000');
    SELECT MaKH INTO v_MaKH FROM (SELECT MaKH FROM KhachHang ORDER BY MaKH) WHERE ROWNUM = 1;
    INSERT INTO HoaDon (MaHD, MaKH, MaPhong, NgayNhan, NgayTra, SoNguoi, TrangThai)
    VALUES (v_MaHD, v_MaKH, :NEW.MaPhong, TRUNC(SYSDATE), TRUNC(SYSDATE) + 1, :NEW.SoNguoiToiDa, 'CHO_NHAN');
    DBMS_OUTPUT.PUT_LINE('Da tu dong tao hoa don: ' || v_MaHD);
END;
SELECT * FROM HoaDon WHERE MaPhong = 'P201' AND TrangThai = 'CHO_NHAN';
INSERT INTO vw_PhongTrong (MaPhong, SoNguoiToiDa) VALUES ('P201', 2);