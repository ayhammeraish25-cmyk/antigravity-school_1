import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';

class ApiService {

  // عنوان السيرفر
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // ---------------- TOKEN ----------------

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // ---------------- HEADERS ----------------

  Map<String, String> _headers(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ---------------- LOGIN ----------------

  Future<bool> login(String nationalId, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers(null),
        body: jsonEncode({
          'nationalId': nationalId,
          'password': password,
        }),
      );

      debugPrint("LOGIN STATUS: ${response.statusCode}");
      debugPrint("LOGIN BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['token'] != null) {
          await saveToken(data['token']);
          return true;
        }
      }

      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  // ---------------- REGISTER ----------------

  Future<bool> register({
    required String fullName,
    required String nationalId,
    required String dob,
    required String username,
    required String email,
    required String password,
  }) async {

    try {

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: _headers(null),
        body: jsonEncode({
          'fullName': fullName,
          'nationalId': nationalId,
          'dob': dob,
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      debugPrint("REGISTER STATUS: ${response.statusCode}");
      debugPrint("REGISTER BODY: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;

    } catch (e) {

      debugPrint('Register error: $e');
      return false;

    }
  }

  // ---------------- POSTS ----------------

  Future<List<PostModel>> getPosts() async {

    try {

      final token = await getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/posts/feed'),
        headers: _headers(token),
      );

      debugPrint("POSTS STATUS: ${response.statusCode}");

      if (response.statusCode == 200) {

        final List<dynamic> data = jsonDecode(response.body);

        return data.map((json) => PostModel.fromJson(json)).toList();

      }

      throw Exception('Failed to load posts');

    } catch (e) {

      debugPrint('Get posts error: $e');
      throw Exception('Network error');

    }
  }

  // ---------------- CREATE POST ----------------

  Future<bool> createPost(String content) async {

    try {

      final token = await getToken();

      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: _headers(token),
        body: jsonEncode({
          'content': content,
          'type': 'TEXT',
          'title': 'New Post',
        }),
      );

      debugPrint("CREATE POST STATUS: ${response.statusCode}");

      return response.statusCode == 201;

    } catch (e) {

      debugPrint('Create post error: $e');
      return false;

    }
  }

  // ---------------- PROFILE ----------------

  Future<Map<String, dynamic>> getUserProfile() async {

    try {

      final token = await getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/users/me'),
        headers: _headers(token),
      );

      if (response.statusCode == 200) {

        return jsonDecode(response.body);

      }

      throw Exception("Failed to load profile");

    } catch (e) {

      debugPrint('Profile error: $e');
      throw Exception('Network error');

    }
  }

}