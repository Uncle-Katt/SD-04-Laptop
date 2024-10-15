CREATE DATABASE LaptopK;
GO
USE LaptopK;
GO

-- Tạo bảng Vai trò (VaiTro)
CREATE TABLE VaiTro (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ma VARCHAR(50) NOT NULL UNIQUE,
    ten_vai_tro VARCHAR(50) NOT NULL
);
GO

-- Tạo bảng Khách hàng (KhachHang)
CREATE TABLE KhachHang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ma VARCHAR(50) NOT NULL UNIQUE,
    ten_khach_hang VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    so_dien_thoai VARCHAR(20) NOT NULL,
    dia_chi VARCHAR(255),
    vai_tro_id INT,
    ngay_tao DATETIME2 DEFAULT GETDATE(),
    ngay_cap_nhat DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (vai_tro_id) REFERENCES VaiTro(id)
);
GO

-- Trigger để tự động cập nhật 'ngay_cap_nhat' khi dữ liệu thay đổi trong bảng KhachHang
CREATE TRIGGER trg_UpdateNgayCapNhat_KhachHang
ON KhachHang
AFTER UPDATE
AS
BEGIN
    UPDATE KhachHang
    SET ngay_cap_nhat = GETDATE()
    WHERE id IN (SELECT DISTINCT id FROM Inserted);
END;
GO

-- Tạo bảng Hãng sản xuất (HangSX)
CREATE TABLE HangSX (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ma VARCHAR(50) NOT NULL UNIQUE,
    ten_hang_sx VARCHAR(255) NOT NULL,
    quoc_gia VARCHAR(255),
    mo_ta TEXT
);
GO

-- Tạo bảng Màu sắc (MauSac)
CREATE TABLE MauSac (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ma VARCHAR(50) NOT NULL UNIQUE,
    ten_mau VARCHAR(50) NOT NULL
);
GO

-- Tạo bảng Danh mục sản phẩm (DanhMuc)
CREATE TABLE DanhMuc (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ma VARCHAR(50) NOT NULL UNIQUE,
    ten_danh_muc VARCHAR(255) NOT NULL,
    mo_ta TEXT
);
GO

-- Tạo bảng Sản phẩm laptop (Laptop)
CREATE TABLE Laptop (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ma VARCHAR(50) NOT NULL UNIQUE,
    ten_laptop VARCHAR(255) NOT NULL,
    hang_sx_id INT NOT NULL,
    mau_sac_id INT NOT NULL,
    danh_muc_id INT NOT NULL,
    cpu NVARCHAR(100),
    ram NVARCHAR(50),
    o_cung NVARCHAR(50),
    man_hinh NVARCHAR(50),
    card_man_hinh NVARCHAR(50),
    dung_luong_pin NVARCHAR(50),
    he_dieu_hanh NVARCHAR(50),
    thong_tin_bao_hanh VARCHAR(255),
    gia DECIMAL(10, 2) NOT NULL,
    so_luong_ton_kho INT NOT NULL,
    mo_ta TEXT,
    anh_url VARCHAR(255),
    ngay_tao DATETIME2 DEFAULT GETDATE(),
    ngay_cap_nhat DATETIME2 DEFAULT GETDATE(),
	trang_thai VARCHAR(50) DEFAULT 'chua_ban',
    FOREIGN KEY (hang_sx_id) REFERENCES HangSX(id),
    FOREIGN KEY (mau_sac_id) REFERENCES MauSac(id),
    FOREIGN KEY (danh_muc_id) REFERENCES DanhMuc(id)
);
GO

-- Trigger tự động cập nhật 'ngay_cap_nhat' cho bảng Laptop
CREATE TRIGGER trg_UpdateNgayCapNhat_Laptop
ON Laptop
AFTER UPDATE
AS
BEGIN
    UPDATE Laptop
    SET ngay_cap_nhat = GETDATE()
    WHERE id IN (SELECT DISTINCT id FROM Inserted);
END;
GO

-- Tạo bảng Đơn hàng (DonHang)
CREATE TABLE DonHang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ma VARCHAR(50) NOT NULL UNIQUE,
    khach_hang_id INT NOT NULL,
    ngay_dat DATETIME2 DEFAULT GETDATE(),
    tong_tien DECIMAL(10, 2) NOT NULL,
    dia_chi_giao_hang VARCHAR(255),
    trang_thai VARCHAR(50) DEFAULT 'dang_xu_ly', -- Dùng VARCHAR thay cho ENUM
    phuong_thuc_thanh_toan VARCHAR(255),
    ngay_tao DATETIME2 DEFAULT GETDATE(),
    ngay_cap_nhat DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (khach_hang_id) REFERENCES KhachHang(id)
);
GO

-- Trigger tự động cập nhật 'ngay_cap_nhat' cho bảng DonHang
CREATE TRIGGER trg_UpdateNgayCapNhat_DonHang
ON DonHang
AFTER UPDATE
AS
BEGIN
    UPDATE DonHang
    SET ngay_cap_nhat = GETDATE()
    WHERE id IN (SELECT DISTINCT id FROM Inserted);
END;
GO

-- Tạo bảng Chi tiết đơn hàng (ChiTietDonHang)
CREATE TABLE ChiTietDonHang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ma VARCHAR(50) NOT NULL UNIQUE,
    don_hang_id INT NOT NULL,
    laptop_id INT NOT NULL,
    so_luong INT NOT NULL,
    gia DECIMAL(10, 2) NOT NULL,
    tong_tien DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (don_hang_id) REFERENCES DonHang(id),
    FOREIGN KEY (laptop_id) REFERENCES Laptop(id)
);
GO

-- Tạo bảng Giỏ hàng (GioHang)
CREATE TABLE GioHang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ma VARCHAR(50) NOT NULL UNIQUE,
    khach_hang_id INT NOT NULL,
    laptop_id INT NOT NULL,
    so_luong INT NOT NULL,
    ngay_tao DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (khach_hang_id) REFERENCES KhachHang(id),
    FOREIGN KEY (laptop_id) REFERENCES Laptop(id)
);
GO

CREATE TABLE GioHangChiTiet (
    id INT IDENTITY(1,1) PRIMARY KEY,
    gio_hang_id INT NOT NULL,         
    laptop_id INT NOT NULL,           
    so_luong INT NOT NULL,            
    gia DECIMAL(10, 2) NOT NULL,      
    tong_tien AS (so_luong * gia) PERSISTED,
    ngay_tao DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (gio_hang_id) REFERENCES GioHang(id), 
    FOREIGN KEY (laptop_id) REFERENCES Laptop(id)   
);
GO

-- Tạo bảng Đánh giá sản phẩm (DanhGia)
CREATE TABLE DanhGia (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ma VARCHAR(50) NOT NULL UNIQUE,
    khach_hang_id INT NOT NULL,
    laptop_id INT NOT NULL,
    diem_danh_gia INT CHECK (diem_danh_gia >= 1 AND diem_danh_gia <= 5),
    binh_luan TEXT,
    ngay_tao DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (khach_hang_id) REFERENCES KhachHang(id),
    FOREIGN KEY (laptop_id) REFERENCES Laptop(id)
);
GO

-- Trigger tạo mã tự động cho Laptop với định dạng "LT+id"
CREATE TRIGGER trg_Laptop_Ma
AFTER INSERT ON Laptop
AS
BEGIN
    UPDATE Laptop
    SET ma = CONCAT('LT', id)
    WHERE id IN (SELECT id FROM inserted);
END;
GO
