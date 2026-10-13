// 1. Tạo abstract class TaiLieu
abstract class TaiLieu {
  String maSo;
  String tenNhaXuatBan;
  int soLuongPhatHanh;

  TaiLieu({
    required this.maSo,
    required this.tenNhaXuatBan,
    required this.soLuongPhatHanh,
  });

  // Phương thức trừu tượng
  void hienThiThongTin();
}

// 2. Lớp con Sach kế thừa từ TaiLieu
class Sach extends TaiLieu {
  String tenTacGia;
  int soTrang;

  Sach({
    required String maSo,
    required String tenNhaXuatBan,
    required int soLuongPhatHanh,
    required this.tenTacGia,
    required this.soTrang,
  }) : super(
         maSo: maSo,
         tenNhaXuatBan: tenNhaXuatBan,
         soLuongPhatHanh: soLuongPhatHanh,
       );

  // 3. Override phương thức hienThiThongTin
  @override
  void hienThiThongTin() {
    print('--- Sách ---');
    print('Mã số: $maSo');
    print('Nhà xuất bản: $tenNhaXuatBan');
    print('Số lượng phát hành: $soLuongPhatHanh');
    print('Tác giả: $tenTacGia');
    print('Số trang: $soTrang');
  }
}

// 2. Lớp con TapChi kế thừa từ TaiLieu
class TapChi extends TaiLieu {
  int soPhatHanh;
  int thangPhatHanh;

  TapChi({
    required String maSo,
    required String tenNhaXuatBan,
    required int soLuongPhatHanh,
    required this.soPhatHanh,
    required this.thangPhatHanh,
  }) : super(
         maSo: maSo,
         tenNhaXuatBan: tenNhaXuatBan,
         soLuongPhatHanh: soLuongPhatHanh,
       );

  // 3. Override phương thức hienThiThongTin
  @override
  void hienThiThongTin() {
    print('--- Tạp Chí ---');
    print('Mã số: $maSo');
    print('Nhà xuất bản: $tenNhaXuatBan');
    print('Số lượng phát hành: $soLuongPhatHanh');
    print('Số phát hành: $soPhatHanh');
    print('Tháng phát hành: $thangPhatHanh');
  }
}

// 2. Lớp con Bao kế thừa từ TaiLieu
class Bao extends TaiLieu {
  DateTime ngayPhatHanh;

  Bao({
    required String maSo,
    required String tenNhaXuatBan,
    required int soLuongPhatHanh,
    required this.ngayPhatHanh,
  }) : super(
         maSo: maSo,
         tenNhaXuatBan: tenNhaXuatBan,
         soLuongPhatHanh: soLuongPhatHanh,
       );

  // 3. Override phương thức hienThiThongTin
  @override
  void hienThiThongTin() {
    print('--- Báo ---');
    print('Mã số: $maSo');
    print('Nhà xuất bản: $tenNhaXuatBan');
    print('Số lượng phát hành: $soLuongPhatHanh');
    // Định dạng ngày tháng năm cho dễ đọc
    String ngayFormatted =
        '${ngayPhatHanh.day}/${ngayPhatHanh.month}/${ngayPhatHanh.year}';
    print('Ngày phát hành: $ngayFormatted');
  }
}

// 4. Hàm main()
void main() {
  // Tạo List chứa các đối tượng từ lớp cha TaiLieu
  List<TaiLieu> danhSachTaiLieu = [
    Sach(
      maSo: 'S01',
      tenNhaXuatBan: 'NXB Kim Đồng',
      soLuongPhatHanh: 1000,
      tenTacGia: 'Nguyễn Nhật Ánh',
      soTrang: 280,
    ),
    TapChi(
      maSo: 'TC01',
      tenNhaXuatBan: 'NXB Trẻ',
      soLuongPhatHanh: 500,
      soPhatHanh: 45,
      thangPhatHanh: 5,
    ),
    Bao(
      maSo: 'B01',
      tenNhaXuatBan: 'Báo Tuổi Trẻ',
      soLuongPhatHanh: 2000,
      ngayPhatHanh: DateTime(2026, 6, 7),
    ),
  ];

  // Dùng vòng lặp for...in để duyệt qua List và gọi phương thức hienThiThongTin()
  for (var taiLieu in danhSachTaiLieu) {
    taiLieu.hienThiThongTin();
    print(''); // Xuống dòng giữa các tài liệu cho dễ nhìn
  }
}
