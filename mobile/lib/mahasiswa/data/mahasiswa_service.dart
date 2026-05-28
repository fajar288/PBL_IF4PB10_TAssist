import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/api_config.dart';
import '../../features/auth/data/auth_service.dart';

class MahasiswaService {
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _headers({bool json = false}) async {
    final token = await _authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      if (json) 'Content-Type': 'application/json',
    };
  }

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');

    if (query == null || query.isEmpty) {
      return uri;
    }

    return uri.replace(
      queryParameters: query.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Format response server tidak valid.');
    }

    final success = decoded['success'] == true;

    if (response.statusCode < 200 || response.statusCode >= 300 || !success) {
      throw Exception(
        decoded['message']?.toString() ?? 'Request gagal.',
      );
    }

    return decoded;
  }

  List<Map<String, dynamic>> _extractList(Map<String, dynamic> decoded) {
    final rootData = decoded['data'];

    dynamic rows;

    // Format Laravel paginator:
    // { success, message, data: { data: [...] } }
    if (rootData is Map<String, dynamic> && rootData['data'] is List) {
      rows = rootData['data'];
    }

    // Format list langsung:
    // { success, message, data: [...] }
    else if (rootData is List) {
      rows = rootData;
    }

    else {
      rows = const [];
    }

    return (rows as List)
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getBimbingan({
    int perPage = 10,
  }) async {
    final response = await http.get(
      _uri('/mahasiswa/bimbingan', {
        'per_page': perPage,
      }),
      headers: await _headers(),
    );

    final decoded = _decodeResponse(response);
    return _extractList(decoded);
  }

  Future<bool> hasActiveBimbingan() async {
    final bimbinganList = await getBimbingan(perPage: 20);

    return bimbinganList.any((item) {
      final status = item['status_bimbingan']?.toString().toLowerCase();
      return status == 'aktif';
    });
  }

  Future<List<Map<String, dynamic>>> getDosen({
    String? bidangKeahlian,
    bool? adaKuota,
    int perPage = 50,
  }) async {
    final query = <String, dynamic>{
      'per_page': perPage,
    };

    if (bidangKeahlian != null && bidangKeahlian.trim().isNotEmpty) {
      query['bidang_keahlian'] = bidangKeahlian.trim();
    }

    if (adaKuota != null) {
      query['ada_kuota'] = adaKuota ? 1 : 0;
    }

    final response = await http.get(
      _uri('/mahasiswa/dosen', query),
      headers: await _headers(),
    );

    final decoded = _decodeResponse(response);
    return _extractList(decoded);
  }

  Future<List<Map<String, dynamic>>> getPermohonan({
    int perPage = 20,
  }) async {
    final response = await http.get(
      _uri('/mahasiswa/permohonan', {
        'per_page': perPage,
      }),
      headers: await _headers(),
    );

    final decoded = _decodeResponse(response);
    return _extractList(decoded);
  }

  Future<Map<String, dynamic>> ajukanPermohonan({
    required int dosenId,
    required String topikTa,
  }) async {
    final response = await http.post(
      _uri('/mahasiswa/permohonan'),
      headers: await _headers(json: true),
      body: jsonEncode({
        'dosen_id': dosenId,
        'topik_ta': topikTa.trim(),
      }),
    );

    final decoded = _decodeResponse(response);

    final data = decoded['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }

    return {};
  }
}