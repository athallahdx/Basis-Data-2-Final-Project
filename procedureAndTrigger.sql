--Insert Pinjam Trigger
CREATE OR REPLACE TRIGGER insert_meminjam_pinjam
AFTER INSERT ON MEMINJAM
FOR EACH ROW
DECLARE
    v_stock BARANG.jumlah_stok%type;
BEGIN
    SELECT jumlah_stok INTO v_stock
    FROM BARANG
    WHERE id_barang = :NEW.id_barang;
    
    v_stock := v_stock - :NEW.jumlah_pinjam;
    UPDATE BARANG SET jumlah_stok=v_stock 
    WHERE id_barang = :NEW.id_barang;  
END;
/

--Insert Kembali Trigger
CREATE OR REPLACE TRIGGER update_meminjam_kembali
AFTER UPDATE OF tanggal_pengembalian ON MEMINJAM 
FOR EACH ROW
DECLARE
    v_stock BARANG.jumlah_stok%type;
BEGIN
        SELECT jumlah_stok INTO v_stock
        FROM BARANG
        WHERE id_barang = :NEW.id_barang;

        UPDATE BARANG SET jumlah_stok = v_stock + :NEW.jumlah_pinjam
        WHERE id_barang = :NEW.id_barang;
END;
/

--Procedure Pinjam
CREATE OR REPLACE PROCEDURE pinjam(
    v_id_anggota IN MEMINJAM.id_anggota%type,
    v_id_barang  IN MEMINJAM.id_barang%type,
    v_jumlah_pinjam IN MEMINJAM.jumlah_pinjam%type
) 
AS
    v_jumlah_stok BARANG.jumlah_stok%type;
BEGIN
    SELECT jumlah_stok INTO v_jumlah_stok FROM BARANG
    WHERE id_barang = v_id_barang;
    IF v_jumlah_pinjam <= v_jumlah_stok THEN
        INSERT INTO MEMINJAM (id_anggota, id_barang, tanggal_pinjam, jumlah_pinjam) 
        VALUES(v_id_anggota, v_id_barang, SYSTIMESTAMP, v_jumlah_pinjam);
        DBMS_OUTPUT.PUT_LINE('Berhasil Dipinjam!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error: Jumlah Peminjaman Melebihi Stok Buku Tersedia!');
    END IF;
END;
/

--Procedure Kembali
CREATE OR REPLACE PROCEDURE kembali(
    v_id_anggota MEMINJAM.id_anggota%type,
    v_id_barang  MEMINJAM.id_barang%type,
    v_tanggal_pinjam MEMINJAM.tanggal_pinjam%type
)
AS
    v_old_tanggal_pengembalian MEMINJAM.tanggal_pengembalian%type;
BEGIN
    -- Attempt to retrieve the existing return date
    BEGIN
        SELECT tanggal_pengembalian INTO v_old_tanggal_pengembalian
        FROM MEMINJAM 
        WHERE id_anggota = v_id_anggota 
          AND id_barang = v_id_barang 
          AND tanggal_pinjam = v_tanggal_pinjam;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_old_tanggal_pengembalian := NULL;
    END;

    -- Check if the book has been returned
    IF v_old_tanggal_pengembalian IS NULL THEN
        UPDATE MEMINJAM 
        SET tanggal_pengembalian = SYSTIMESTAMP
        WHERE id_anggota = v_id_anggota 
          AND id_barang = v_id_barang 
          AND tanggal_pinjam = v_tanggal_pinjam;
        DBMS_OUTPUT.PUT_LINE('Berhasil Dikembalikan!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error: Buku Sudah Dikembalikkan!');
    END IF;
END;
/


--Procedure Pemasukkan
CREATE OR REPLACE PROCEDURE pemasukkan(
    v_id_divisi KEUANGAN_DIVISI.id_divisi%type,
    v_total_pemasukkan KEUANGAN_DIVISI.pemasukkan%type,
    v_keterangan KEUANGAN_DIVISI.keterangan%type
)
AS
    latest_saldo KEUANGAN_DIVISI.saldo%type := 0;
    newest_saldo KEUANGAN_DIVISI.saldo%type;
BEGIN
    BEGIN
        SELECT saldo
        INTO latest_saldo
        FROM KEUANGAN_DIVISI
        WHERE id_divisi = v_id_divisi
        ORDER BY tanggal DESC
        FETCH FIRST ROW ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            latest_saldo := 0;
    END;

    newest_saldo := latest_saldo + v_total_pemasukkan;

    INSERT INTO KEUANGAN_DIVISI (id_divisi, tanggal, pemasukkan, keterangan, saldo)
    VALUES (v_id_divisi, SYSTIMESTAMP, v_total_pemasukkan, v_keterangan, newest_saldo);
    DBMS_OUTPUT.PUT_LINE('Pemasukkan berhasil dicatat!');
END;
/


--Procedure Pengeluaran
CREATE OR REPLACE PROCEDURE pengeluaran(
    v_id_divisi KEUANGAN_DIVISI.id_divisi%type,
    v_total_pengeluaran KEUANGAN_DIVISI.pengeluaran%type,
    v_keterangan KEUANGAN_DIVISI.keterangan%type
)
AS
    latest_saldo KEUANGAN_DIVISI.saldo%type;
    newest_saldo KEUANGAN_DIVISI.saldo%type;
BEGIN
    BEGIN
        SELECT saldo
        INTO latest_saldo
        FROM KEUANGAN_DIVISI
        WHERE id_divisi = v_id_divisi
        ORDER BY tanggal DESC
        FETCH FIRST ROW ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            latest_saldo := 0;
    END;
    
    IF v_total_pengeluaran > latest_saldo THEN
        DBMS_OUTPUT.PUT_LINE('Error: Pengeluaran melebihi saldo terkini!');
    ELSE
        newest_saldo := latest_saldo - v_total_pengeluaran;

        INSERT INTO KEUANGAN_DIVISI (id_divisi, tanggal, pengeluaran, keterangan, saldo)
        VALUES (v_id_divisi, SYSTIMESTAMP, v_total_pengeluaran, v_keterangan, newest_saldo);

        DBMS_OUTPUT.PUT_LINE('Pengeluaran berhasil dicatat!');
    END IF;
END;
/

