CREATE TABLE PHONGBAN (
    MaPhong INT PRIMARY KEY,
    TenPhong VARCHAR2(50),
    TruongPhong INT,
    NgayNhanChuc DATE
);

CREATE TABLE NHANVIEN (
    MaNV INT PRIMARY KEY,
    HoNV VARCHAR2(50),
    TenNV VARCHAR2(50),
    NgaySinh DATE,
    DiaChi VARCHAR2(50),
    Phai VARCHAR2(50),
    Luong NUMBER,
    MaNQL INT,
    Phong INT,
    FOREIGN KEY (MaNQL) REFERENCES NHANVIEN(MaNV),
    FOREIGN KEY (Phong) REFERENCES PHONGBAN(MaPhong)
);

CREATE TABLE DIADIEMPHONG (
    MaPhong INT,
    DiaDiem VARCHAR2(50),
    PRIMARY KEY (MaPhong, DiaDiem),
    FOREIGN KEY (MaPhong) REFERENCES PHONGBAN(MaPhong)
);

CREATE TABLE DEAN (
    MaDA VARCHAR2(50) PRIMARY KEY,
    TenDA VARCHAR2(50),
    DdiemDA VARCHAR2(50),
    Phong INT,
    FOREIGN KEY (Phong) REFERENCES PHONGBAN(MaPhong)
);

CREATE TABLE PHANCONG (
    MaNV INT,
    MaDA VARCHAR2(50),
    ThoiGian NUMBER,
    PRIMARY KEY (MaNV, MaDA),
    FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV),
    FOREIGN KEY (MaDA) REFERENCES DEAN(MaDA)
);

CREATE TABLE THANNHAN (
    MaTN INT PRIMARY KEY,
    HoTN VARCHAR2(50),
    TenTN VARCHAR2(50),
    Phai VARCHAR2(50),
    NgaySinh DATE
);

CREATE TABLE NVIEN_TNHAN (
    MaNV INT,
    MaTN INT,
    QuanHe VARCHAR2(50),
    PRIMARY KEY (MaNV, MaTN),
    FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV),
    FOREIGN KEY (MaTN) REFERENCES THANNHAN(MaTN)
);

INSERT INTO PHONGBAN VALUES (1, 'Hành Chính', 101, TO_DATE('2020-01-01','YYYY-MM-DD'));
INSERT INTO PHONGBAN VALUES (2, 'Tài V?', 102, TO_DATE('2021-02-01','YYYY-MM-DD'));
INSERT INTO PHONGBAN VALUES (3, 'K? Toán', 103, TO_DATE('2022-03-01','YYYY-MM-DD'));

-- Nhân viên
INSERT INTO NHANVIEN VALUES (100, 'Nguyen', 'An', TO_DATE('1990-05-15','YYYY-MM-DD'), 'Hà N?i', 'Nam', 600000, NULL, 1);
INSERT INTO NHANVIEN VALUES (101, 'Pham', 'Huynh', TO_DATE('1985-07-20','YYYY-MM-DD'), '?à N?ng', 'Nam', 800000, NULL, 1);
INSERT INTO NHANVIEN VALUES (102, 'Tran', 'Binh', TO_DATE('1992-08-10','YYYY-MM-DD'), 'HCM', 'Nam', 450000, 101, 2);
INSERT INTO NHANVIEN VALUES (103, 'Le', 'Huynh', TO_DATE('1995-09-12','YYYY-MM-DD'), 'Hu?', 'N?', 700000, 101, 2);
INSERT INTO NHANVIEN VALUES (104, 'Pham', 'Lan', TO_DATE('1998-10-05','YYYY-MM-DD'), 'Hà N?i', 'N?', 550000, 102, 3);
INSERT INTO NHANVIEN VALUES (105, 'Nguyen', 'Minh', TO_DATE('1999-11-11','YYYY-MM-DD'), 'Hà N?i', 'Nam', 600000, NULL, 1);


INSERT INTO DIADIEMPHONG VALUES (1, 'T?ng 1');
INSERT INTO DIADIEMPHONG VALUES (2, 'T?ng 2');
INSERT INTO DIADIEMPHONG VALUES (3, 'T?ng 3');

INSERT INTO DEAN VALUES ('DA01', '?? án A', 'Hà N?i', 1);
INSERT INTO DEAN VALUES ('DA02', '?? án B', '?à N?ng', 2);
INSERT INTO DEAN VALUES ('DA03', '?? án C', 'HCM', 3);

INSERT INTO PHANCONG VALUES (100, 'DA01', 20);
INSERT INTO PHANCONG VALUES (101, 'DA01', 35);
INSERT INTO PHANCONG VALUES (102, 'DA02', 40);
INSERT INTO PHANCONG VALUES (103, 'DA02', 25);
INSERT INTO PHANCONG VALUES (104, 'DA03', 30);
INSERT INTO PHANCONG VALUES (101, 'DA02', 40);
INSERT INTO PHANCONG VALUES (101, 'DA03', 25);


INSERT INTO THANNHAN VALUES (201, 'Nguyen', 'An', 'Nam', TO_DATE('2010-06-01','YYYY-MM-DD')); -- cùng tên v?i NV100
INSERT INTO THANNHAN VALUES (202, 'Pham', 'Huynh', 'N?', TO_DATE('2012-07-01','YYYY-MM-DD')); -- cùng tên v?i NV101
INSERT INTO THANNHAN VALUES (203, 'Tran', 'Mai', 'N?', TO_DATE('2015-08-01','YYYY-MM-DD'));

INSERT INTO NVIEN_TNHAN VALUES (100, 201, 'Con');
INSERT INTO NVIEN_TNHAN VALUES (101, 202, 'V?');
INSERT INTO NVIEN_TNHAN VALUES (102, 203, 'Em gái');

-- 1. Thông tin cá nhân v? nh?ng nhân viên có tên ‘Huynh’
SELECT * 
FROM NHANVIEN 
WHERE TenNV = 'Huynh';

-- 2. Mã NV, h? tên, ??a ch? nhân viên làm vi?c phòng ‘Hành Chính’
SELECT MaNV, HoNV || ' ' || TenNV AS HoTen, DiaChi
FROM NHANVIEN NV
JOIN PHONGBAN PB ON NV.Phong = PB.MaPhong
WHERE PB.TenPhong = 'Hành Chính';

-- 3. Nhân viên làm vi?c phòng ‘Hành Chính’ và ‘Tài V?’
SELECT MaNV, HoNV || ' ' || TenNV AS HoTen, DiaChi
FROM NHANVIEN NV
JOIN PHONGBAN PB ON NV.Phong = PB.MaPhong
WHERE PB.TenPhong IN ('Hành Chính','Tài V?');


-- Câu 4: Mã NV, h? tên NV và tên các ?? án mà NV tham gia (workaround)
SELECT NV.MaNV, NV.HoNV || ' ' || NV.TenNV AS HoTen, DA.TenDA
FROM NHANVIEN NV
JOIN PHANCONG PC ON NV.MaNV = PC.MaNV
JOIN DEAN DA ON PC.MaDA = DA.MaDA;

-- 5. Mã ?? án, tên ?? án, tên phòng ban ch? trì, mã tr??ng phòng, tên tr??ng phòng
SELECT DA.MaDA, DA.TenDA, PB.TenPhong, PB.TruongPhong, NV.HoNV || ' ' || NV.TenNV AS TruongPhongTen
FROM DEAN DA
JOIN PHONGBAN PB ON DA.Phong = PB.MaPhong
JOIN NHANVIEN NV ON PB.TruongPhong = NV.MaNV;

-- 6. Nhân viên tham gia ?? án ‘DA01’ và có th?i gian > 30
SELECT NV.MaNV, NV.HoNV || ' ' || NV.TenNV AS HoTen
FROM NHANVIEN NV
JOIN PHANCONG PC ON NV.MaNV = PC.MaNV
WHERE PC.MaDA = 'DA01' AND PC.ThoiGian > 30;

-- 7. Nhân viên có cùng tên v?i ng??i thân
SELECT DISTINCT NV.MaNV, NV.HoNV || ' ' || NV.TenNV AS HoTen
FROM NHANVIEN NV
JOIN NVIEN_TNHAN NT ON NV.MaNV = NT.MaNV
JOIN THANNHAN TN ON NT.MaTN = TN.MaTN
WHERE NV.TenNV = TN.TenTN;

-- 8. Nhân viên có tr??ng phòng h? tên ‘Ph?m Huynh’
SELECT NV.MaNV, NV.HoNV || ' ' || NV.TenNV AS HoTen
FROM NHANVIEN NV
JOIN PHONGBAN PB ON NV.Phong = PB.MaPhong
JOIN NHANVIEN TP ON PB.TruongPhong = TP.MaNV
WHERE TP.HoNV = 'Pham' AND TP.TenNV = 'Huynh';

-- 9. Nhân viên có qu?n lý h? tên ‘Ph?m Huynh’
SELECT NV.MaNV, NV.HoNV || ' ' || NV.TenNV AS HoTen
FROM NHANVIEN NV
JOIN NHANVIEN QL ON NV.MaNQL = QL.MaNV
WHERE QL.HoNV = 'Pham' AND QL.TenNV = 'Huynh';

-- 10. Nhân viên tham gia m?i ?? án c?a công ty
SELECT NV.MaNV, NV.HoNV || ' ' || NV.TenNV AS HoTen
FROM NHANVIEN NV
WHERE NOT EXISTS (
    SELECT DA.MaDA FROM DEAN DA
    MINUS
    SELECT PC.MaDA FROM PHANCONG PC WHERE PC.MaNV = NV.MaNV
);

-- 11. Nhân viên không tham gia ?? án nào
SELECT NV.MaNV, NV.HoNV || ' ' || NV.TenNV AS HoTen
FROM NHANVIEN NV
WHERE NV.MaNV NOT IN (SELECT MaNV FROM PHANCONG);

-- 12. M?c l??ng trung bình c?a nhân viên
SELECT AVG(Luong) AS LuongTB
FROM NHANVIEN;

-- 13. M?c l??ng trung bình c?a nhân viên nam
SELECT AVG(Luong) AS LuongTB_Nam
FROM NHANVIEN
WHERE Phai = 'Nam';

-- 14. T?ng s? ?? án c?a công ty
SELECT COUNT(*) AS TongSoDeAn
FROM DEAN;

-- 15. V?i m?i ?? án, t?ng s? nhân viên tham gia
SELECT MaDA, COUNT(MaNV) AS TongNV
FROM PHANCONG
GROUP BY MaDA;

-- 16. V?i m?i ?? án, t?ng s? nhân viên n? tham gia
SELECT PC.MaDA, COUNT(*) AS TongNVNu
FROM PHANCONG PC
JOIN NHANVIEN NV ON PC.MaNV = NV.MaNV
WHERE NV.Phai = 'N?'
GROUP BY PC.MaDA;

-- 17. T?ng th?i gian tham gia ?? án c?a nhân viên nam thêm 4 gi?/tu?n
UPDATE PHANCONG PC
SET ThoiGian = ThoiGian + 4
WHERE PC.MaNV IN (SELECT MaNV FROM NHANVIEN WHERE Phai = 'Nam');

-- 18. Xóa t?t c? nhân viên có m?c l??ng d??i 500000
DELETE FROM NHANVIEN
WHERE Luong < 500000;



SELECT * FROM NHANVIEN;



