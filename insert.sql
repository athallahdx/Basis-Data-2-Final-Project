INSERT INTO DIVISIa
VALUES
    ('SRT01', 'KRAI', 'Kontes Robot Abu Indonesia'),
    ('SRT02', 'KRSRI', 'Kontes Robot SAR Indonesia'),
    ('SRT03', 'KRTMI', 'Kontes Robot Tematik Indonesia'),
    ('SRT04', 'KRTI-FW', 'Kontes Robot Terbang Indonesia Fixed-Wings'),
    ('SRT05', 'KRTI-RP', 'Kontes Robot Terbang Indonesia Racing Plane');

INSERT INTO SUB_DIVISI
VALUES
    ('SUB01', 'Mekanik'),
    ('SUB02', 'Elektronik'),
    ('SUB03', 'Programmer'),
    ('SUB04', 'System');

INSERT INTO ANGGOTA
VALUES
    ('101', 'Rafif', 'H1D023008', 'SRT02', 'SUB01'),
    ('102', 'Athallah', 'H1D023013', 'SRT01', 'SUB03'),
    ('103', 'Bagus', 'H1D023042', 'SRT03', 'SUB01');

INSERT INTO JENIS_BARANG
VALUES
    ('JBR01', 'Mekanik Produksi'),
    ('JBR02', 'Inventaris Umum'),
    ('JBR03', 'Elektronik'),
    ('JBR04', 'Mikrokontroler'),


INSERT INTO BARANG
VALUES 
    ('BR001', 'Bor Tangan', 2, 7, 15000, 'JBR01'),
    ('BR002', 'Kipas Angin', 4, 4, 5000, 'JBR02'),
    ('BR003', 'Multimeter', 3, 5, 7000, 'JBR03'),
    ('BR004', 'Arduino Uno', 5, 12, 10000, 'JBR04');

INSERT INTO ANGGOTA
VALUES
    ('101', 'Rafif', 'H1D023008', 'SRT02', 'SUB01'),
    ('102', 'Athallah', 'H1D023013', 'SRT01', 'SUB03'),
    ('103', 'Bagus', 'H1D023042', 'SRT03', 'SUB01');
    