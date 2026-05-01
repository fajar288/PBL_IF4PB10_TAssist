// lib/data/dummy_data.dart
import '../model/models.dart';
import '../theme/app_theme.dart';

class DummyData {
  DummyData._();

  static final List<CounselingRequest> counselingRequests = [
    CounselingRequest(
      id: '1',
      studentName: 'Andi Pratama',
      nim: '20210010001',
      major: 'Informatics Engineering',
      avatarUrl: 'https://i.pravatar.cc/300?img=11',
      status: RequestStatus.pending,
      requestDate: DateTime(2025, 7, 15, 9, 30),
      message:
          'I need guidance regarding my thesis topic selection. I have two ideas in mind and would love your professional perspective on which direction is more feasible for a final-year student.',
    ),
    CounselingRequest(
      id: '2',
      studentName: 'Sari Dewi Kusuma',
      nim: '20210010002',
      major: 'Computer Science',
      avatarUrl: 'https://i.pravatar.cc/300?img=5',
      status: RequestStatus.pending,
      requestDate: DateTime(2025, 7, 14, 14, 0),
      message:
          'I\'ve been struggling with my academic performance this semester. My grades have dropped significantly and I\'m worried about my scholarship status. I would really appreciate your advice.',
    ),
    CounselingRequest(
      id: '3',
      studentName: 'Budi Santoso',
      nim: '20210010003',
      major: 'Information Systems',
      avatarUrl: 'https://i.pravatar.cc/300?img=15',
      status: RequestStatus.pending,
      requestDate: DateTime(2025, 7, 14, 10, 15),
      message:
          'Seeking advice on internship opportunities in the software engineering field. I have received two offers and need help deciding which aligns better with my career goals.',
    ),
    CounselingRequest(
      id: '4',
      studentName: 'Maya Putri Rahma',
      nim: '20210010004',
      major: 'Software Engineering',
      avatarUrl: 'https://i.pravatar.cc/300?img=9',
      status: RequestStatus.accepted,
      requestDate: DateTime(2025, 7, 13, 8, 0),
      message:
          'I need help planning my course schedule for the upcoming semester to ensure I meet all graduation requirements on time.',
    ),
    CounselingRequest(
      id: '5',
      studentName: 'Reza Firmansyah',
      nim: '20210010005',
      major: 'Informatics Engineering',
      avatarUrl: 'https://i.pravatar.cc/300?img=12',
      status: RequestStatus.declined,
      requestDate: DateTime(2025, 7, 12, 16, 45),
      message:
          'Would like to discuss transferring to a different major and understand the process and implications.',
    ),
    CounselingRequest(
      id: '6',
      studentName: 'Dika Maulana',
      nim: '20210010006',
      major: 'Data Science',
      avatarUrl: 'https://i.pravatar.cc/300?img=33',
      status: RequestStatus.pending,
      requestDate: DateTime(2025, 7, 15, 11, 0),
      message:
          'Feeling overwhelmed with the workload and deadlines. Would like to discuss time management strategies and mental wellness resources available at the university.',
    ),
  ];

  static final List<MeetingRequest> meetingRequests = [
    MeetingRequest(
      id: '1',
      studentName: 'Andi Pratama',
      nim: '20210010001',
      major: 'Informatics Engineering',
      avatarUrl: 'https://i.pravatar.cc/300?img=11',
      meetingDate: DateTime(2025, 7, 21),
      meetingTime: '09:00 AM',
      description:
          'I have prepared my thesis outline and would like to present it to you for feedback. The research focuses on implementing machine learning algorithms for early dropout detection in university students. I believe this aligns well with the current challenges our institution faces.',
      status: RequestStatus.pending,
    ),
    MeetingRequest(
      id: '2',
      studentName: 'Sari Dewi Kusuma',
      nim: '20210010002',
      major: 'Computer Science',
      avatarUrl: 'https://i.pravatar.cc/300?img=5',
      meetingDate: DateTime(2025, 7, 22),
      meetingTime: '02:00 PM',
      description:
          'I need to discuss my current grade situation urgently. My GPA has fallen below the minimum threshold for my scholarship, and I need to understand what remedial steps or appeals are available to me before the end of this academic period.',
      status: RequestStatus.pending,
    ),
    MeetingRequest(
      id: '3',
      studentName: 'Dika Maulana',
      nim: '20210010006',
      major: 'Data Science',
      avatarUrl: 'https://i.pravatar.cc/300?img=33',
      meetingDate: DateTime(2025, 7, 24),
      meetingTime: '11:00 AM',
      description:
          'I have received two competing internship offers — one from a large tech corporation and another from an exciting startup in the AI space. I would greatly value your mentorship in evaluating which path is more beneficial for my long-term career trajectory.',
      status: RequestStatus.accepted,
    ),
    MeetingRequest(
      id: '4',
      studentName: 'Maya Putri Rahma',
      nim: '20210010004',
      major: 'Software Engineering',
      avatarUrl: 'https://i.pravatar.cc/300?img=9',
      meetingDate: DateTime(2025, 7, 25),
      meetingTime: '10:30 AM',
      description:
          'Following up on my accepted counseling session, I\'d like to map out my remaining semester schedule. I want to make sure I can complete all the required credits while also participating in the upcoming hackathon competition.',
      status: RequestStatus.pending,
    ),
  ];
}