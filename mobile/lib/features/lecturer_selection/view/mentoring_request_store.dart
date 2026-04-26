import 'package:flutter/foundation.dart';

class MentoringRequestStore {
  // Mengubah dari objek tunggal menjadi List agar bisa menampung banyak request
  static final ValueNotifier<List<RequestedLecturer>> requests =
      ValueNotifier<List<RequestedLecturer>>([]);

  // Menambah dosen ke dalam daftar
  static void request(RequestedLecturer lecturer) {
    if (!isRequested(lecturer.id)) {
      requests.value = [...requests.value, lecturer];
    }
  }

  // Menghapus dosen tertentu berdasarkan ID
  static void cancel(String lecturerId) {
    requests.value = requests.value.where((r) => r.id != lecturerId).toList();
  }

  // Mengecek apakah dosen tertentu sudah direquest atau belum
  static bool isRequested(String lecturerId) {
    return requests.value.any((r) => r.id == lecturerId);
  }
}

class RequestedLecturer {
  const RequestedLecturer({
    required this.id,
    required this.name,
    required this.major,
    required this.imageUrl,
    required this.nid,
    required this.guidanceQuotaLeft,
  });

  final String id;
  final String name;
  final String major;
  final String imageUrl;
  final String nid;
  final int guidanceQuotaLeft;
}