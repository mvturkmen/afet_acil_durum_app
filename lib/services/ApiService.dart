import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Platform ve environment bazında base URL ayarı
  static String get baseUrl {
    // Production için gerçek IP adresi kullanın
    const String productionIP =
        '192.168.1.106'; // Bilgisayarınızın IP adresini buraya yazın

    try {
      if (Platform.isAndroid) {
        // Android emülatör mü gerçek cihaz mı kontrol et
        return 'http://10.0.2.2:8080'; // Emülatör için
        // return 'http://$productionIP:8080'; // Gerçek cihaz için bu satırı kullanın
      } else if (Platform.isIOS) {
        return 'http://localhost:8080'; // iOS simulator için
        // return 'http://$productionIP:8080'; // Gerçek iOS cihazı için bu satırı kullanın
      } else {
        return 'http://$productionIP:8080';
      }
    } catch (e) {
      return 'http://$productionIP:8080';
    }
  }

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Token'ı header'a ekleyen method
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    Map<String, String> headers = {'Content-Type': 'application/json'};

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // Login işlemi
  Future<Map<String, dynamic>> authenticate(
    String username,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/authenticate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'error': 'Giriş başarısız. Kod: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Bağlantı hatası: ${e.toString()}'};
    }
  }

  // Register işlemi
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String birthDate,
    required String firstName,
    required String lastName,
    required String password,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'birthDate': birthDate,
          'firstName': firstName,
          'lastName': lastName,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': 'Kayıt işlemi başarılı'};
      } else {
        return {
          'success': false,
          'error': 'Kayıt başarısız. Kod: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Bağlantı hatası: ${e.toString()}'};
    }
  }

  Future<void> saveToken(String token, String role, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_role', role);
    await prefs.setString('username', username);
  }

  // Token'ı alma
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Kullanıcı bilgilerini alma
  Future<Map<String, String?>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'token': prefs.getString('auth_token'),
      'role': prefs.getString('user_role'),
      'username': prefs.getString('username'),
    };
  }

  // Logout işlemi
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_role');
    await prefs.remove('username');
  }

  // Token'ın geçerliliğini kontrol etme
  Future<bool> isTokenValid() async {
    final token = await getToken();
    if (token == null) return false;

    // Token'ın süresini kontrol etmek için bir API çağrısı yapabilirsiniz
    // Örneğin: /api/validate-token endpoint'i
    return true;
  }

  // Genel GET isteği
  Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    return await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
  }

  // Genel POST isteği
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  // Genel PUT isteği
  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    return await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  // Genel DELETE isteği
  Future<http.Response> delete(String endpoint) async {
    final headers = await _getHeaders();
    return await http.delete(Uri.parse('$baseUrl$endpoint'), headers: headers);
  }
}
