import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

enum ScheduleState { initial, expanded, submitted }

class _SchedulePageState extends State<SchedulePage> {
  ScheduleState _currentState = ScheduleState.initial;

  DateTime? _selectedDate;
  int _selectedHour = 0;
  int _selectedMinute = 0;
  String? _selectedLecturer;
  final TextEditingController _descriptionController = TextEditingController();

  final List<Map<String, String>> _lecturers = [
    {
      'name': 'Aruna Fajar S.tu, V.wx',
      'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=600&q=80'
    },
    {
      'name': 'Dr. Budi Santoso',
      'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=600&q=80'
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Kita bungkus dengan GestureDetector untuk fitur "klik luar untuk menutup"
    return GestureDetector(
      onTap: () {
        if (_currentState == ScheduleState.expanded) {
          setState(() => _currentState = ScheduleState.initial);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEEF2F6),
        body: SafeArea(
          child: SingleChildScrollView(
            // Agar klik di dalam scrollview tidak memicu GestureDetector di atas secara tidak sengaja
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Let's Schedule Your Meet!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const Text(
                  "with mr. lecturer",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),

                // Animasi perubahan antar state UI
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: _buildMainContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_currentState) {
      case ScheduleState.initial:
        return _buildInitialButton();
      case ScheduleState.expanded:
        return _buildScheduleForm();
      case ScheduleState.submitted:
        return _buildSubmittedCard();
    }
  }

  Widget _buildInitialButton() {
    return GestureDetector(
      onTap: () => setState(() => _currentState = ScheduleState.expanded),
      child: Container(
        width: double.infinity,
        decoration: _cardDecoration(),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFF0D47A1),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Set Date and Time",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 10),
            const Icon(Icons.keyboard_arrow_down, color: Color(0xFF0D47A1), size: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleForm() {
    // GestureDetector di sini untuk menghentikan "bubbling" tap agar klik di dalam form tidak menutup form
    return GestureDetector(
      onTap: () {}, 
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Set Date", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 10),
            _buildDateField(),
            
            const SizedBox(height: 20),
            const Text("Set Time", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            _buildTimePicker(),

            const SizedBox(height: 20),
            const Text("Select Lecturer", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 10),
            _buildLecturerDropdown(),

            const SizedBox(height: 20),
            const Text("Add Description", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 10),
            _buildDescriptionField(),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitSchedule,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Set Meeting Schedule", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            
            // --- BAGIAN BARU: Icon Arrow Up untuk menutup form ---
            const SizedBox(height: 15),
            Center(
              child: GestureDetector(
                onTap: () => setState(() => _currentState = ScheduleState.initial),
                child: const Icon(
                  Icons.keyboard_arrow_up, 
                  color: Color(0xFF0D47A1), 
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmittedCard() {
    return Column(
      children: [
        _buildInitialButton(),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => _showDetailOptions(),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: _cardDecoration(),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(_lecturers[0]['image']!),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Pending",
                        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        "Meet with mr. ${_selectedLecturer ?? _lecturers[0]['name']}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (picked != null) setState(() => _selectedDate = picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate == null 
                ? "DD/MM/YYYY" 
                : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
              style: TextStyle(color: _selectedDate == null ? Colors.grey : Colors.black),
            ),
            const Icon(Icons.calendar_today, color: Color(0xFF0D47A1)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return SizedBox(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _timeColumn("H", 24, (val) => _selectedHour = val),
          const Text(":", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          _timeColumn("M", 60, (val) => _selectedMinute = val),
        ],
      ),
    );
  }

  Widget _timeColumn(String label, int count, Function(int) onChanged) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Expanded(
            child: CupertinoPicker(
              itemExtent: 40,
              onSelectedItemChanged: (index) => setState(() => onChanged(index)),
              children: List.generate(count, (index) => Center(
                child: Text(
                  index.toString().padLeft(2, '0'),
                  style: const TextStyle(fontSize: 20),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLecturerDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: _selectedLecturer,
          decoration: const InputDecoration(border: InputBorder.none),
          items: _lecturers.map((lec) {
            return DropdownMenuItem(
              value: lec['name'],
              child: Row(
                children: [
                  CircleAvatar(radius: 12, backgroundImage: NetworkImage(lec['image']!)),
                  const SizedBox(width: 10),
                  Text(lec['name']!, style: const TextStyle(fontSize: 14)),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedLecturer = val),
          hint: const Text("Pilih Dosen"),
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: "....",
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  void _submitSchedule() {
    if (_selectedDate == null || _selectedLecturer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon lengkapi data jadwal!")),
      );
      return;
    }

    final String timeString = "${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')}";
    
    setState(() => _currentState = ScheduleState.submitted);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Jadwal pada jam $timeString telah berhasil dibuat!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showDetailOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Opsi Jadwal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text("Lihat Info Detail"),
                onTap: () {
                  print("Jam terpilih: $_selectedHour:$_selectedMinute");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text("Edit Jadwal"),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Hapus Jadwal"),
                onTap: () {
                  setState(() => _currentState = ScheduleState.initial);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}