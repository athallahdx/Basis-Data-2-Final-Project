--DDL Table Jenis_Barang
CREATE TABLE JENIS_BARANG(
    id_jenis_barang          CHAR(5) NOT NULL,
    deskripsi_jenis_barang   VARCHAR(100) NOT NULL
);

ALTER TABLE JENIS_BARANG ADD CONSTRAINT jenis_barang_pk PRIMARY KEY(id_jenis_barang);

--DDL Table Barang
CREATE TABLE BARANG(
    id_barang           CHAR(5) NOT NULL,
    nama_barang         VARCHAR(100) NOT NULL,
    jumlah_stok         INT,
    batas_pinjam        INT,
    dendaPerHari        INT,
    id_jenis_barang     CHAR(5) NOT NULL
);
ALTER TABLE BARANG ADD CONSTRAINT barang_pk PRIMARY KEY(id_barang);
ALTER TABLE BARANG ADD CONSTRAINT barang_fk FOREIGN KEY(id_jenis_barang) REFERENCES JENIS_BARANG(id_jenis_barang);

--DDL Table Divisi
CREATE TABLE DIVISI(
    id_divisi                   CHAR(4) NOT NULL,
    nama_divisi_singkat         VARCHAR(100) NOT NULL,
    nama_divisi_panjang         VARCHAR(100)
);

ALTER TABLE DIVISI ADD CONSTRAINT divisi_pk PRIMARY KEY(id_divisi);


--DDL Table Sub-Divisi
CREATE TABLE SUB_DIVISI(
    id_sub_divisi              CHAR(4) NOT NULL,
    nama_sub_divisi            VARCHAR(100)
);
ALTER TABLE SUB_DIVISI ADD CONSTRAINT sub_divisi_pk PRIMARY KEY(id_sub_divisi);

--DDL Table Anggota
CREATE TABLE ANGGOTA(
    id_anggota          INT NOT NULL,
    nama_anggota        VARCHAR(100) NOT NULL,
    nim_anggota         CHAR(9) NOT NULL,
    id_divisi           CHAR(4) NOT NULL,
    id_sub_divisi       CHAR(4) NOT NULL
);

ALTER TABLE ANGGOTA ADD CONSTRAINT anggota_pk PRIMARY KEY(id_anggota);
ALTER TABLE ANGGOTA ADD CONSTRAINT divisi_fk FOREIGN KEY(id_divisi) REFERENCES DIVISI(id_divisi);
ALTER TABLE ANGGOTA ADD CONSTRAINT sub_divisi_fk FOREIGN KEY(id_sub_divisi) REFERENCES SUB_DIVISI(id_sub_divisi);


--DDL Table Keuangan Divisi
CREATE TABLE KEUANGAN_DIVISI(
    id_divisi    CHAR(4) NOT NULL,
    tanggal      TIMESTAMP NOT NULL,
    pemasukkan   INT,
    pengeluaran  INT,
    keterangan   VARCHAR(255),
    saldo        INT NOT NULL
);

ALTER TABLE KEUANGAN_DIVISI ADD CONSTRAINT keuangan_divisi_pk PRIMARY KEY(id_divisi, tanggal);
ALTER TABLE KEUANGAN_DIVISI ADD CONSTRAINT keuangan_divisi_fk FOREIGN KEY(id_divisi) REFERENCES DIVISI(id_divisi);

--DDL Table Meminjam
CREATE TABLE MEMINJAM(
    id_anggota              INT NOT NULL,
    id_barang               CHAR(5) NOT NULL,
    tanggal_pinjam          TIMESTAMP NOT NULL,
    tanggal_pengembalian    TIMESTAMP,
    jumlah_pinjam           INT NOT NULL,
    denda                   INT
);

ALTER TABLE MEMINJAM
ADD CONSTRAINT meminjam_anggota_fk FOREIGN KEY(id_anggota)
REFERENCES ANGGOTA(id_anggota);

ALTER TABLE MEMINJAM
ADD CONSTRAINT meminjam_barang_fk FOREIGN KEY(id_barang)
REFERENCES BARANG(id_barang);

ALTER TABLE MEMINJAM
ADD CONSTRAINT meminjam_pk PRIMARY KEY(id_anggota,
                                    id_barang,
                                    tanggal_pinjam);