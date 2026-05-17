import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DosenService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1';

  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dosen/profile'),
      headers: await _headers(),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getPermohonan() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dosen/permohonan'),
      headers: await _headers(),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> terimaPermohonan(int id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/dosen/permohonan/$id/terima'),
      headers: await _headers(),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> tolakPermohonan(int id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/dosen/permohonan/$id/tolak'),
      headers: await _headers(),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getMahasiswaBimbingan() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dosen/mahasiswa-bimbingan'),
      headers: await _headers(),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getProgresMahasiswa(int mahasiswaId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/dosen/mahasiswa-bimbingan/$mahasiswaId/progres'),
      headers: await _headers(),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getFeedback() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dosen/feedback'),
      headers: await _headers(),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> storeFeedback({
    required int dokumenId,
    required String isiFeedback,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/dosen/feedback'),
      headers: await _headers(),
      body: {
        'dokumen_id': dokumenId.toString(),
        'isi_feedback': isiFeedback,
      },
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getJadwal() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dosen/jadwal'),
      headers: await _headers(),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> konfirmasiJadwal(int id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/dosen/jadwal/$id/konfirmasi'),
      headers: await _headers(),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getNotifikasi() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dosen/notifikasi'),
      headers: await _headers(),
    );

    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    throw Exception(data['message'] ?? 'Terjadi kesalahan server.');
  }
}