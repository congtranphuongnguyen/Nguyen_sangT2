// Bài thực hành 1: Tính điểm trung bình và Xếp loại

// Hàm tính điểm trung bình từ danh sách điểm
double tinhDiemTrungBinh(List<double> diem) {
  if (diem.isEmpty) return 0.0;
  double tong = 0;
  for (double d in diem) {
    tong += d;
  }
  return tong / diem.length;
}

// Hàm xếp loại học lực dựa trên điểm trung bình
String xepLoai(double dtb) {
  if (dtb >= 9.0) return 'Xuất sắc';
  if (dtb >= 8.0) return 'Giỏi';
  if (dtb >= 6.5) return 'Khá';
  if (dtb >= 5.0) return 'Trung bình';
  return 'Yếu';
}

void main() {
  // 1. Khai báo Map lưu điểm các môn học
  Map<String, double> diemMonHoc = {'Toán': 9.0, 'Văn': 7.5, 'Anh': 8.0};

  // 2. Lấy danh sách điểm từ values của Map
  List<double> danhSachDiem = diemMonHoc.values.toList();

  // 3. Tính điểm trung bình
  double dtb = tinhDiemTrungBinh(danhSachDiem);

  // 4. Xếp loại học lực
  String hocLuc = xepLoai(dtb);

  // 5. In kết quả
  print('Điểm các môn: $diemMonHoc');
  print('Điểm trung bình: ${dtb.toStringAsFixed(2)}. Xếp loại: $hocLuc');
}
