import 'package:flutter/material.dart';
import 'lecturers_page.dart';
import 'mentoring_request_store.dart';
import '../../main_mahasiswa/navbar_mahasiswa.dart';

class LecturerDetailPage extends StatelessWidget {
  final LecturerModel lecturer;

  const LecturerDetailPage({
    super.key,
    required this.lecturer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F6),
      extendBody: true,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 18),
            _buildHeader(context),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildDetailCard(context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavbarMahasiswa(
        currentIndex: 0,
        onTap: (index) {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2D3238), size: 22),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Text(
            'Lecturer Detail',
            style: TextStyle(color: Color(0xFF2D3238), fontSize: 24, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(lecturer.imageUrl, height: 280, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 24),
          _buildInfoRow('Name :', lecturer.displayName),
          const SizedBox(height: 12),
          _buildInfoRow('NID :', lecturer.nid),
          const SizedBox(height: 12),
          _buildInfoRow('Major :', lecturer.department.label),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(flex: 4, child: Text('Number of guidance left :', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF111111)))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(20)),
                child: Text('${lecturer.quotaLeft}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Memantau daftar request di Store
          ValueListenableBuilder<List<RequestedLecturer>>(
            valueListenable: MentoringRequestStore.requests,
            builder: (context, allRequests, _) {
              // Cek apakah ID dosen ini ada di dalam list request
              bool isThisLecturerRequested = MentoringRequestStore.isRequested(lecturer.id);

              if (isThisLecturerRequested) {
                return Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D4AA3).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('Requested', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () {
                            // Cancel berdasarkan ID spesifik
                            MentoringRequestStore.cancel(lecturer.id);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.redAccent, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Cancel', style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      MentoringRequestStore.request(
                        RequestedLecturer(
                          id: lecturer.id,
                          name: lecturer.name,
                          major: lecturer.department.label,
                          imageUrl: lecturer.imageUrl,
                          nid: lecturer.nid,
                          guidanceQuotaLeft: lecturer.quotaLeft,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D4AA3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Request Counseling', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF111111)))),
        Expanded(flex: 3, child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111111)))),
      ],
    );
  }
}