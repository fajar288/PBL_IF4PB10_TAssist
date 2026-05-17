import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1';

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPassword = password.trim();

    if (normalizedEmail.isEmpty || normalizedPassword.isEmpty) {
      return const AuthResult(
        isSuccess: false,
        message: 'Email dan password wajib diisi.',
      );
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(normalizedEmail)) {
      return const AuthResult(
        isSuccess: false,
        message: 'Format email tidak valid.',
      );
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'email': normalizedEmail,
          'password': normalizedPassword,
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final responseData = data['data'];

        String? token;
        String? role;

        if (responseData is Map<String, dynamic>) {
          token = responseData['token']?.toString();

          final user = responseData['user'];
          if (user is Map<String, dynamic>) {
            role = user['role']?.toString();
          }
        }

        role = role?.trim().toLowerCase();

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          if (role != null) {
            await prefs.setString('role', role);
          }
        }

        return AuthResult(
          isSuccess: true,
          message: data['message']?.toString() ?? 'Login berhasil.',
          role: role,
          token: token,
        );
      }

      return AuthResult(
        isSuccess: false,
        message: data['message']?.toString() ?? 'Email atau password salah.',
      );
    } catch (e) {
      return AuthResult(
        isSuccess: false,
        message: 'Gagal terhubung ke server: $e',
      );
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    }

    await prefs.remove('token');
    await prefs.remove('role');
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }
}

class AuthResult {
  final bool isSuccess;
  final String message;
  final String? role;
  final String? token;

  const AuthResult({
    required this.isSuccess,
    required this.message,
    this.role,
    this.token,
  });
}