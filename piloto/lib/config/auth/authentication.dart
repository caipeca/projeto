import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {

   static const String baseUrl = 'http://192.168.196.37:8000/users';
  //static const String baseUrl = 'http://192.168.196.43:8000/users';

  static Future<bool> loginUser(String email, String password) async {

    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type':'application/json'},
      body: jsonEncode({'email':email, 'password': password}),
    );

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      final token = data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwtToken', token);
      print('Token Salvo Com sucesso');
      print(token);
      return true;
    }else{
      print(response.body);
      return false;
    }
  }

  static Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}