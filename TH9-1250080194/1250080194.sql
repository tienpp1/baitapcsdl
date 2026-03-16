--phieu hoc tap 1
-- B?ng HANG và HOADON (Phi?u 1)
CREATE TABLE Hang (
  Mahang   VARCHAR2(5) CONSTRAINT pk_hang PRIMARY KEY,
  Tenhang  VARCHAR2(50),
  Soluong  NUMBER(10),
  Giaban   NUMBER(15,2)
);

CREATE TABLE Hoadon (
  Mahd      VARCHAR2(10) CONSTRAINT pk_hoadon PRIMARY KEY,
  Mahang    VARCHAR2(5) REFERENCES Hang(Mahang),
  Soluongban NUMBER(10),
  Ngayban   DATE
);
COMMIT;
--insert hoadon
CREATE OR REPLACE TRIGGER trg_insert_hd
BEFORE INSERT ON Hoadon
FOR EACH ROW
DECLARE
    sl NUMBER;
BEGIN
    SELECT Soluong INTO sl
    FROM Hang
    WHERE Mahang = :NEW.Mahang;

    IF :NEW.Soluongban > sl THEN
        RAISE_APPLICATION_ERROR(-20001,'Khong du hang');
    END IF;

    UPDATE Hang
    SET Soluong = Soluong - :NEW.Soluongban
    WHERE Mahang = :NEW.Mahang;
END;
SELECT * FROM Hang;
INSERT INTO Hang VALUES ('H2','Keo',50,5000);
SELECT * FROM Hang;
INSERT INTO Hoadon VALUES ('HD1','H1',10,SYSDATE);
--update hoadon
CREATE OR REPLACE TRIGGER trg_update_hd
AFTER UPDATE ON Hoadon
FOR EACH ROW
BEGIN
    UPDATE Hang
    SET Soluong = Soluong - (:NEW.Soluongban - :OLD.Soluongban)
    WHERE Mahang = :NEW.Mahang;
END;
UPDATE Hoadon
SET Soluongban = 20
WHERE Mahd='HD1';
SELECT * FROM Hoadon;
UPDATE Hoadon
SET Soluongban = 30
WHERE Mahd='HD1';
SELECT * FROM Hoadon, Hang;
--delete hoadon
CREATE OR REPLACE TRIGGER trg_delete_hd
AFTER DELETE ON Hoadon
FOR EACH ROW
BEGIN
    UPDATE Hang
    SET Soluong = Soluong + :OLD.Soluongban
    WHERE Mahang = :OLD.Mahang;
END;
SELECT * FROM Hoadon, Hang;
DELETE FROM Hoadon
WHERE Mahd='HD1';
--phieu hoc tap 2
CREATE TABLE Mathang (
Mahang VARCHAR2(5) CONSTRAINT pk_mathang PRIMARY KEY,
Tenhang VARCHAR2(50) NOT NULL,
Soluong NUMBER(10)
);
CREATE TABLE Nhatkybanhang (
Stt NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
Ngay DATE,
Nguoimua VARCHAR2(50),
Mahang VARCHAR2(5) REFERENCES Mathang(Mahang),
Soluong NUMBER(10),
Giaban NUMBER(15,2)
);
INSERT INTO Mathang VALUES ('1','Hang A', 100);
INSERT INTO Mathang VALUES ('2','Hang B', 200);
INSERT INTO Mathang VALUES ('3','Hang C', 150);
COMMIT;
--insert giam  mathang
CREATE OR REPLACE TRIGGER trg_nhatkybanhang_insert
AFTER INSERT ON Nhatkybanhang
FOR EACH ROW
BEGIN
  UPDATE Mathang
  SET Soluong = Soluong - :NEW.Soluong
  WHERE Mahang = :NEW.Mahang;
END;
SELECT * FROM Mathang;
INSERT INTO Nhatkybanhang(Ngay,Nguoimua,Mahang,Soluong,Giaban)
VALUES(SYSDATE,'An','1',10,5000);
SELECT * FROM Mathang;
--update soluong
CREATE OR REPLACE TRIGGER trg_nhatkybanhang_update_soluong
AFTER UPDATE OF Soluong ON Nhatkybanhang
FOR EACH ROW
BEGIN
  UPDATE Mathang
  SET Soluong = Soluong - (:NEW.Soluong - :OLD.Soluong)
  WHERE Mahang = :NEW.Mahang;
END;
SELECT * FROM Nhatkybanhang;
UPDATE Nhatkybanhang
SET Soluong = 20
WHERE Stt = 1;
SELECT * FROM Nhatkybanhang;
--kiem tra so luong
CREATE OR REPLACE TRIGGER trg_check_insert
BEFORE INSERT ON Nhatkybanhang
FOR EACH ROW
DECLARE
  sl NUMBER;
BEGIN
  SELECT Soluong INTO sl
  FROM Mathang
  WHERE Mahang = :NEW.Mahang;

  IF :NEW.Soluong > sl THEN
    RAISE_APPLICATION_ERROR(-20001,'Khong du hang');
  END IF;
END;
INSERT INTO Nhatkybanhang(Ngay,Nguoimua,Mahang,Soluong,Giaban)
VALUES(SYSDATE,'Binh','1',1000,5000);
--update kiem soat so dong
CREATE OR REPLACE TRIGGER trg_update_1row
BEFORE UPDATE ON Nhatkybanhang
FOR EACH ROW
BEGIN
  NULL;
END;
UPDATE Nhatkybanhang
SET Giaban = Giaban + 1000;
--delete cong lai ton kho
CREATE OR REPLACE TRIGGER trg_delete_nhatky
AFTER DELETE ON Nhatkybanhang
FOR EACH ROW
BEGIN
  UPDATE Mathang
  SET Soluong = Soluong + :OLD.Soluong
  WHERE Mahang = :OLD.Mahang;
END;
SELECT * FROM Mathang;
SELECT * FROM Nhatkybanhang;
DELETE FROM Nhatkybanhang
WHERE Stt = 1;
SELECT * FROM Mathang;
--update kiem tra dieu kien
CREATE OR REPLACE TRIGGER trg_update_check
BEFORE UPDATE ON Nhatkybanhang
FOR EACH ROW
DECLARE
  sl NUMBER;
BEGIN
  SELECT Soluong INTO sl
  FROM Mathang
  WHERE Mahang = :NEW.Mahang;

  IF :NEW.Soluong > sl THEN
    RAISE_APPLICATION_ERROR(-20002,'Cap nhat sai');
  END IF;
END;
UPDATE Nhatkybanhang
SET Soluong = 1000
WHERE Stt = 2;
--xoa mathang
CREATE OR REPLACE PROCEDURE xoa_mathang(p_ma VARCHAR2)
IS
BEGIN
  DELETE FROM Nhatkybanhang
  WHERE Mahang = p_ma;

  DELETE FROM Mathang
  WHERE Mahang = p_ma;
END;
SELECT * FROM Mathang;
EXEC xoa_mathang('1');
SELECT * FROM Mathang;
--tinh tong theo ten hang 
CREATE OR REPLACE FUNCTION tong_tien(p_ten VARCHAR2)
RETURN NUMBER
IS
  tong NUMBER;
BEGIN
  SELECT SUM(n.Soluong*n.Giaban)
  INTO tong
  FROM Nhatkybanhang n, Mathang m
  WHERE n.Mahang = m.Mahang
  AND m.Tenhang = p_ten;

  RETURN tong;
END;
SELECT tong_tien('Hang A') FROM dual;