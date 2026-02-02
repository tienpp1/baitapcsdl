-- T?o B?ng
-- B?ng Ngân Hàng
CREATE TABLE NganHang (
    MaNH INT PRIMARY KEY,
    TenNH VARCHAR2(100)
);

-- B?ng Chi Nhánh
CREATE TABLE ChiNhanh (
    MaNH INT,
    MaCN VARCHAR2(10) PRIMARY KEY,
    ThanhPhoCN VARCHAR2(50),
    TaiSan NUMBER,
    FOREIGN KEY (MaNH) REFERENCES NganHang(MaNH)
);

-- B?ng Khách Hàng
CREATE TABLE KhachHang (
    MaKH VARCHAR2(20) PRIMARY KEY,
    TenKH VARCHAR2(100),
    DiaChi VARCHAR2(200)
);

-- B?ng Tài Kho?n Gói
CREATE TABLE TaiKhoanGoi (
    MaKH VARCHAR2(20),
    MaCN VARCHAR2(10),
    SoTKG VARCHAR2(20) PRIMARY KEY,
    SoTienGoi NUMBER,
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
    FOREIGN KEY (MaCN) REFERENCES ChiNhanh(MaCN)
);

-- B?ng Tài Kho?n Vay
CREATE TABLE TaiKhoanVay (
    MaKH VARCHAR2(20),
    MaCN VARCHAR2(10),
    SoTKV VARCHAR2(20) PRIMARY KEY,
    SoTienVay NUMBER,
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
    FOREIGN KEY (MaCN) REFERENCES ChiNhanh(MaCN)
);

--Thêm d? li?u
--B?ng Ngân Hàng
INSERT INTO NganHang VALUES (1, 'Ngan Hang Cong Thuong');
INSERT INTO NganHang VALUES (2, 'Ngan Hang Ngoai Thuong');
INSERT INTO NganHang VALUES (3, 'Ngan Hang Nong Nghiep');
INSERT INTO NganHang VALUES (4, 'Ngan Hang A Chau');
INSERT INTO NganHang VALUES (5, 'Ngan Hang Thuong Tin');

--B?ng Chi Nhánh
INSERT INTO ChiNhanh VALUES (1, 'CN01', 'Da Lat', 2000000000);
INSERT INTO ChiNhanh VALUES (2, 'CN02', 'Nha Trang', 2500000000);
INSERT INTO ChiNhanh VALUES (3, 'CN03', 'Thanh Hoa', 4500000000);
INSERT INTO ChiNhanh VALUES (4, 'CN04', 'TP HCM', 5000000000);
INSERT INTO ChiNhanh VALUES (5, 'CN05', 'Da Nang', 7000000000);
INSERT INTO ChiNhanh VALUES (1, 'CN11', 'TP HCM', 5000000000);
INSERT INTO ChiNhanh VALUES (2, 'CN12', 'Hue', 1400000000);
INSERT INTO ChiNhanh VALUES (3, 'CN13', 'Da Nang', 3600000000);
INSERT INTO ChiNhanh VALUES (4, 'CN14', 'Ha Noi', 5700000000);
INSERT INTO ChiNhanh VALUES (1, 'CN21', 'Ha Noi', 3500000000);
INSERT INTO ChiNhanh VALUES (2, 'CN22', 'Ha Noi', 4500000000);
INSERT INTO ChiNhanh VALUES (3, 'CN23', 'Da Lat', 4500000000);
INSERT INTO ChiNhanh VALUES (1, 'CN31', 'Da Nang', 4000000000);
INSERT INTO ChiNhanh VALUES (2, 'CN32', 'TP HCM', 5600000000);
INSERT INTO ChiNhanh VALUES (3, 'CN33', 'Can Tho', 5400000000);
INSERT INTO ChiNhanh VALUES (3, 'CN43', 'Nam Dinh', 3600000000);

--B?ng Khách Hàng
INSERT INTO KhachHang VALUES ('111222333', 'Ho Thi Thanh Thao', '456 Le Duan, Ha Noi');
INSERT INTO KhachHang VALUES ('112233445', 'Tran Van Tien', '12 Dien Bien Phu, Q1, TP HCM');
INSERT INTO KhachHang VALUES ('123123123', 'Phan Thi Quynh Nhu', '54 Hai Ba Trung, Ha Noi');
INSERT INTO KhachHang VALUES ('123412341', 'Nguyen Van Thao', '34 Tran Phu, TP Nha Trang');
INSERT INTO KhachHang VALUES ('123456789', 'Nguyen Thi Hoa', '1/4 Hoang Van Thu, Da Lat');
INSERT INTO KhachHang VALUES ('221133445', 'Nguyen Thi Kim Mai', '4 Tran Binh Trong, Da Lat');
INSERT INTO KhachHang VALUES ('221113335', 'Do Tien Dong', '123 Tran Phu, Nam Dinh');
INSERT INTO KhachHang VALUES ('331124456', 'Bui Thi Dong', '345 Tran Hung Dao, Thanh Hoa');
INSERT INTO KhachHang VALUES ('333111222', 'Tran Dinh Hung', '783 Ly Thuong Kiet, Can Tho');
INSERT INTO KhachHang VALUES ('441122335', 'Nguyen Dinh Cuong', 'P12 Thanh Xuan Nam, Q Thanh Xuan');
INSERT INTO KhachHang VALUES ('456456456', 'Tran Nam Son', '5 Le Duan, TP Da Nang');
INSERT INTO KhachHang VALUES ('551122334', 'Tran Thi Khanh Van', '1A Ho Tung Mau, Da Lat');
INSERT INTO KhachHang VALUES ('987654321', 'Ho Thanh Son', '209 Tran Hung Dao, Q5, TP HCM');
INSERT INTO KhachHang VALUES ('222111333', 'Tran Thi Hang', 'TP HCM');

--B?ng Tài Kho?n Gói
INSERT INTO TaiKhoanGoi VALUES ('123123123','CN01','00001A',10000000);
INSERT INTO TaiKhoanGoi VALUES ('123456789','CN01','00001B',12000000);
INSERT INTO TaiKhoanGoi VALUES ('221133445','CN02','00002A',12500000);
INSERT INTO TaiKhoanGoi VALUES ('456456456','CN03','00003D',34500000);
INSERT INTO TaiKhoanGoi VALUES ('123412341','CN05','00005A',12500000);
INSERT INTO TaiKhoanGoi VALUES ('123412341','CN05','00005B',20000000);
INSERT INTO TaiKhoanGoi VALUES ('123123123','CN11','00011A',15000000);
INSERT INTO TaiKhoanGoi VALUES ('551122334','CN14','00014D',9000000);
INSERT INTO TaiKhoanGoi VALUES ('123456789','CN14','00014E',7000000);
INSERT INTO TaiKhoanGoi VALUES ('123412341','CN22','00022A',5400000);
INSERT INTO TaiKhoanGoi VALUES ('987654321','CN22','00022B',5000000);
INSERT INTO TaiKhoanGoi VALUES ('987654321','CN23','00023D',4700000);
INSERT INTO TaiKhoanGoi VALUES ('333111222','CN33','00033A',4000000);
INSERT INTO TaiKhoanGoi VALUES ('987654321','CN33','00033D',4700000);

--B?ng Tài Kho?n Vay
INSERT INTO TaiKhoanVay VALUES ('111222333','CN01','10001A',10000000);
INSERT INTO TaiKhoanVay VALUES ('333111222','CN02','10002A',15000000);
INSERT INTO TaiKhoanVay VALUES ('551122334','CN03','10003A',20000000);
INSERT INTO TaiKhoanVay VALUES ('221133445','CN05','10005A',15000000);
INSERT INTO TaiKhoanVay VALUES ('123123123','CN11','10011A',10000000);
INSERT INTO TaiKhoanVay VALUES ('111222333','CN12','10012A',12000000);
INSERT INTO TaiKhoanVay VALUES ('123123123','CN14','10014A',15000000);
INSERT INTO TaiKhoanVay VALUES ('987654321','CN22','10022A',30000000);
INSERT INTO TaiKhoanVay VALUES ('987654321','CN23','10023A',17000000);
INSERT INTO TaiKhoanVay VALUES ('221113335','CN33','10033A',25000000);

--truy v?n

--câu1
SELECT DISTINCT NH.TenNH
FROM NganHang NH
JOIN ChiNhanh CN ON NH.MaNH = CN.MaNH
WHERE cn.thanhphocn = 'Da Lat';
--câu2
SELECT DISTINCT ThanhPhoCN
FROM ChiNhanh
WHERE MaNH = (
    SELECT MaNH FROM NganHang WHERE TenNH = 'Ngan Hang Cong Thuong'
);
--câu3
SELECT *
FROM ChiNhanh
WHERE MaNH = (
    SELECT MaNH FROM NganHang WHERE TenNH = 'Ngan Hang Cong Thuong'
)
AND ThanhPhoCN = 'TP HCM';
--câu4
SELECT NH.TenNH, CN.*
FROM NganHang NH
JOIN ChiNhanh CN ON NH.MaNH = CN.MaNH;
--câu5
SELECT *
FROM KhachHang
WHERE DiaChi LIKE '%Ha Noi%';
--câu6
SELECT *
FROM KhachHang
WHERE TenKH LIKE '%Son%';
--câu7
SELECT *
FROM KhachHang
WHERE DiaChi LIKE '%Tran Hung Dao%';
--câu8
SELECT *
FROM KhachHang
WHERE TenKH LIKE '%Thao%';
--câu9
SELECT *
FROM KhachHang
WHERE MaKH LIKE '11%'
AND DiaChi LIKE '%TP HCM%';
--câu10
SELECT NH.TenNH, CN.ThanhPhoCN, CN.TaiSan
FROM ChiNhanh CN
JOIN NganHang NH ON CN.MaNH = NH.MaNH
ORDER BY CN.TaiSan ASC, CN.ThanhPhoCN ASC;
--câu11
SELECT NH.TenNH, CN.*
FROM ChiNhanh CN
JOIN NganHang NH ON CN.MaNH = NH.MaNH
WHERE CN.TaiSan > 3000000000
  AND CN.TaiSan < 5000000000;
--câu12
SELECT MaNH, AVG(TaiSan) AS TaiSanTrungBinh
FROM ChiNhanh
GROUP BY MaNH;
--câu13
SELECT KH.*
FROM KhachHang KH
JOIN TaiKhoanVay TKV ON KH.MaKH = TKV.MaKH
JOIN ChiNhanh CN ON TKV.MaCN = CN.MaCN
WHERE CN.MaNH = (SELECT MaNH FROM NganHang WHERE TenNH = 'Ngan Hang Cong Thuong')
AND KH.TenKH LIKE '%Thao%';
--câu14
SELECT NH.TenNH, SUM(CN.TaiSan) AS TongTaiSan
FROM NganHang NH
JOIN ChiNhanh CN ON NH.MaNH = CN.MaNH
GROUP BY NH.TenNH;
--câu15
SELECT MaCN, TaiSan
FROM ChiNhanh
WHERE TaiSan = (SELECT MAX(TaiSan) FROM ChiNhanh);
--câu16
SELECT DISTINCT KH.*
FROM KhachHang KH
JOIN TaiKhoanGoi TKG ON KH.MaKH = TKG.MaKH
JOIN ChiNhanh CN ON TKG.MaCN = CN.MaCN
JOIN NganHang NH ON CN.MaNH = NH.MaNH
WHERE NH.TenNH = 'Ngan Hang A Chau';
--câu17
SELECT *
FROM TaiKhoanVay TKV
JOIN ChiNhanh CN ON TKV.MaCN = CN.MaCN
WHERE CN.MaNH = (
    SELECT MaNH FROM NganHang WHERE TenNH = 'Ngan Hang Ngoai Thuong'
)
AND TKV.SoTienVay > 1200000;
--câu18
SELECT TKG.MaCN, SUM(TKG.SoTienGoi) AS TongTienGoi
FROM TaiKhoanGoi TKG
GROUP BY TKG.MaCN;
--câu19
SELECT KH.TenKH, 'TK Vay' AS Loai, TKV.SoTienVay
FROM KhachHang KH
JOIN TaiKhoanVay TKV ON KH.MaKH = TKV.MaKH
WHERE KH.TenKH LIKE '%Son%'
UNION ALL
SELECT KH.TenKH, 'TK Goi', TKG.SoTienGoi
FROM KhachHang KH
JOIN TaiKhoanGoi TKG ON KH.MaKH = TKG.MaKH
WHERE KH.TenKH LIKE '%Son%';
--câu20
SELECT MaKH, SUM(SoTienVay) AS TongVay
FROM TaiKhoanVay
GROUP BY MaKH
HAVING SUM(SoTienVay) > 3000000;




