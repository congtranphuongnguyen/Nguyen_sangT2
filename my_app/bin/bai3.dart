import 'package:http/http.dart' as http;

import 'dart:convert';

// ==========================================
// PHẦN 1: Future, async, await với Public API
// ==========================================

// 2. Viết hàm Future<String> fetchApiData()
Future<String> fetchApiData() async {
  // Sử dụng Uri.parse để phân tích URL của API
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');

  // Gọi API bằng http.get và đợi kết quả trả về
  final response = await http.get(url);

  // Kiểm tra mã trạng thái HTTP
  if (response.statusCode == 200) {
    return response.body; // Trả về chuỗi JSON
  } else {
    throw Exception('Tải dữ liệu thất bại!');
  }
}

// 3. Viết hàm Map<String, dynamic> parseData(String responseBody)
Map<String, dynamic> parseData(String responseBody) {
  // Chuyển chuỗi JSON thành đối tượng Map
  return jsonDecode(responseBody) as Map<String, dynamic>;
}

// ==========================================
// PHẦN 2: Stream, async*, yield
// ==========================================

// 1. Viết hàm Stream<int> countDown()
Stream<int> countDown() async* {
  // Vòng lặp đếm ngược từ 5 về 1
  for (int i = 5; i >= 1; i--) {
    // Đợi 1 giây trong mỗi bước lặp
    await Future.delayed(const Duration(seconds: 1));
    // Phát ra số đếm hiện tại
    yield i;
  }
}

// ==========================================
// HÀM MAIN CHÍNH
// ==========================================
void main() async {
  // --- Chạy Phần 1 ---
  print('=== PHẦN 1: GỌI API VÀ XỬ LÝ DỮ LIỆU ===');
  try {
    // Gọi fetchApiData() và await kết quả
    String responseBody = await fetchApiData();

    // Gọi parseData() để lấy dataMap
    Map<String, dynamic> dataMap = parseData(responseBody);

    // In ra tiêu đề và nội dung
    print('Tiêu đề: ${dataMap['title']}');
    print('Nội dung: ${dataMap['body']}\n');
  } catch (e) {
    print('Đã xảy ra lỗi ở Phần 1: $e\n');
  }

  // --- Chạy Phần 2 ---
  print('=== PHẦN 2: STREAM ĐẾM NGƯỢC ===');
  print('Chuẩn bị đếm ngược...');

  // Sử dụng await for để lắng nghe Stream từ countDown()
  await for (int number in countDown()) {
    print(number);
  }

  print('Kết thúc!');
}
