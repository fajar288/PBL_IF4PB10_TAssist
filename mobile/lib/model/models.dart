// lib/models/models.dart
import '../theme/app_theme.dart';

export '../theme/app_theme.dart' show RequestStatus;

class CounselingRequest {
  final String id;
  final String studentName;
  final String nim;
  final String major;
  final String avatarUrl;
  final RequestStatus status;
  final DateTime requestDate;
  final String message;

  const CounselingRequest({
    required this.id,
    required this.studentName,
    required this.nim,
    required this.major,
    required this.avatarUrl,
    required this.status,
    required this.requestDate,
    this.message = '',
  });

  String get initials {
    final parts = studentName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, 2).toUpperCase();
  }
}

class StudentModel {
  final String id; // data real: bimbingan_id
  final String? mahasiswaId;
  final String name;
  final String nim;
  final String major;
  final String year;
  final String imageInitials;
  final String status;
  final double progress;
  final String counselingSince;
  final String email;
  final String phone;
  final int meetingCount;
  final int taskCount;
  final int taskCompleted;
  final String? topikTa;
  final String? judulTa;

  const StudentModel({
    required this.id,
    this.mahasiswaId,
    required this.name,
    required this.nim,
    required this.major,
    required this.year,
    required this.imageInitials,
    required this.status,
    required this.progress,
    required this.counselingSince,
    required this.email,
    required this.phone,
    required this.meetingCount,
    required this.taskCount,
    required this.taskCompleted,
    this.topikTa,
    this.judulTa,
  });

  int? get bimbinganIdAsInt => int.tryParse(id);
  int? get mahasiswaIdAsInt => int.tryParse(mahasiswaId ?? '');

  factory StudentModel.fromBimbinganJson(Map<String, dynamic> json) {
    final mahasiswaRaw = json['mahasiswa'];
    final mahasiswa = mahasiswaRaw is Map
        ? Map<String, dynamic>.from(mahasiswaRaw)
        : <String, dynamic>{};

    final progresRaw = json['progres_terkini'];
    final progres = progresRaw is Map
        ? Map<String, dynamic>.from(progresRaw)
        : <String, dynamic>{};

    final name = mahasiswa['nama']?.toString() ?? '-';
    final persentaseRaw =
        double.tryParse(progres['persentase']?.toString() ?? '') ?? 0;
    final progressValue = persentaseRaw > 1
        ? (persentaseRaw / 100).clamp(0.0, 1.0)
        : persentaseRaw.clamp(0.0, 1.0);

    return StudentModel(
      id: json['bimbingan_id']?.toString() ?? '',
      mahasiswaId: mahasiswa['mahasiswa_id']?.toString(),
      name: name,
      nim: mahasiswa['nim']?.toString() ?? '-',
      major: mahasiswa['prodi']?.toString() ?? '-',
      year: mahasiswa['angkatan']?.toString() ?? '-',
      imageInitials: _initialsFromName(name),
      status: _mapStatus(json['status_bimbingan']?.toString()),
      progress: progressValue,
      counselingSince: json['tanggal_mulai']?.toString() ?? '-',
      email: '-',
      phone: '-',
      meetingCount: 0,
      taskCount: 0,
      taskCompleted: 0,
      topikTa: mahasiswa['topik_ta']?.toString(),
      judulTa: mahasiswa['judul_ta']?.toString(),
    );
  }

  static String _mapStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'aktif':
        return 'active';
      case 'selesai':
        return 'completed';
      case 'dibatalkan':
        return 'warning';
      default:
        return 'active';
    }
  }

  static String _initialsFromName(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();

    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

class MeetingRequest {
  final String id;
  final String studentName;
  final String nim;
  final String major;
  final String avatarUrl;
  final DateTime meetingDate;
  final String meetingTime;
  final String description;
  final RequestStatus status;

  const MeetingRequest({
    required this.id,
    required this.studentName,
    required this.nim,
    required this.major,
    required this.avatarUrl,
    required this.meetingDate,
    required this.meetingTime,
    required this.description,
    required this.status,
  });

  String get initials {
    final parts = studentName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, 2).toUpperCase();
  }

  String get dayName {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[meetingDate.weekday - 1];
  }

  String get formattedDate {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '$dayName, ${meetingDate.day} ${months[meetingDate.month - 1]} ${meetingDate.year}';
  }
}
