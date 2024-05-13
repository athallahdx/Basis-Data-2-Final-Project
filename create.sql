--DDL

CREATE TABLE BARANG(
    id_barang           INT NOT NULL PRIMARY KEY,
    nama_barang         VARCHAR(100) NOT NULL,
    jumlah_stok         INT NOT NULL,
    batas_pinjam        INT NOT NULL,
    dendaPerHari        INT NOT NULL,
    id_jenis_barang     VARCHAR(100) NOT NULL,
);

ALTER TABLE BARANG ADD CONSTRAINT barang_pk PRIMARY KEY(id_barang);

CREATE TABLE ANGGOTA(
    id_anggota          INT NOT NULL PRIMARY KEY,
    nama_anggota        VARCHAR(100) NOT NULL,
    nim_anggota         CHAR(9) NOT NULL,
    no_hp               VARCHAR(15) NOT NULL,
    alamat              VARCHAR(100)
);

ALTER TABLE ANGGOTA ADD CONSTRAINT anggota_pk PRIMARY KEY(id_anggota);

CREATE TABLE MEMINJAM(
    id_anggota              INT NOT NULL,
    id_barang               INT NOT NULL,
    tanggal_pinjam          DATETIME NOT NULL,
    tanggal_pengembalian    DATETIME,
    jumlah_pinjam           INT NOT NULL,
    denda                   INT,
);

ALTER TABLE MEMINJAM
ADD CONSTRAINT meminjam_anggota_fk FOREIGN KEY(id_barang)
REFERENCES ANGGOTA(id_anggota)

ALTER TABLE MEMINJAM
ADD CONSTRAINT meminjam_barang_fk FOREIGN KEY(id_barang)
REFERENCES ANGGOTA(id_barang);

ALTER TABLE MEMINJAM
ADD CONSTRAINT meminjam_pk PRIMARY KEY(id_anggota,
                                    id_barang,
                                    tanggal_pinjam)

--TRIGGER

CREATE OR REPLACE TRIGGER insert_meminjam_pinjam
BEFORE INSERT OF id_anggota, id_barang, tanggal_pinjam, jumlah_pinjam ON MEMINJAM
FOR EACH ROW
DECLARE
    v_stock INT;
BEGIN
    SELECT jumlah_stok INTO v_stock
    FROM BARANG
    WHERE id_barang = :NEW.id_barang;
    
    IF NEW.jumlah_pinjam <= v_stock THEN
        v_stock:=v_stock-NEW.jumlah_pinjam
        UPDATE BARANG SET jumlah_stok=v_stock WHERE id_barang = :NEW.id_barang;  
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Jumlah Peminjaman Melebihi Stok Buku Tersedia!');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER update_meminjam_kembali
BEFORE UPDATE OF tanggal_pengembalian ON MEMINJAM 
FOR EACH ROW
DECLARE
    returnDate INT;
    borrowDate MEMINJAM.tanggal_pinjam%type;
    borrowLimit BARANG.batas_pinjam%type;
    fine BARANG.dendaPerHari%type;
BEGIN
    SELECT batas_pinjam INTO borrowLimit
    FROM BARANG
    WHERE 
    returnDate := NEW.tanggal_pengembalian - borrowDate;
    IF returnDate>borrowLimit

    
END;
/

CREATE OR REPLACE TRIGGER update_meminjam_kembali
BEFORE UPDATE OF tanggal_pengembalian ON MEMINJAM 
FOR EACH ROW
DECLARE
    returnDate INT;
    borrowDate DATE;
    borrowLimit INT;
    fine INT;
BEGIN
    SELECT batas_pinjam, dendaPerHari INTO borrowLimit, fine
    FROM BARANG
    WHERE id_barang = NEW.id_barang;

    -- Calculate the number of days overdue
    borrowDate := NEW.tanggal_pinjam;
    returnDate := TRUNC(:NEW.tanggal_pengembalian) - TRUNC(borrowDate);

    IF returnDate > borrowLimit THEN
        :NEW.denda := (returnDate - borrowLimit) * fine;
    ELSE
        :NEW.denda := 0;
    END IF;
END;
/

