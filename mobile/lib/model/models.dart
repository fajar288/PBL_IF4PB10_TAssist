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
  final String id;
  final String name;
  final String nim;
  final String major;
  final String year;
  final String imageInitials;
  final String status; // 'active', 'warning', 'completed'
  final double progress; // 0.0 - 1.0
  final String counselingSince;
  final String email;
  final String phone;
  final int meetingCount;
  final int taskCount;
  final int taskCompleted;
 
  const StudentModel({
    required this.id,
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
  });
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
      'Monday', 'Tuesday', 'Wednesday',
      'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    return days[meetingDate.weekday - 1];
  }

  String get formattedDate {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '$dayName, ${meetingDate.day} ${months[meetingDate.month - 1]} ${meetingDate.year}';
  }
}   