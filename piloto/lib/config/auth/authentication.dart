import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {

  static const String baseUrl = 'http://172.20.160.1:8000/users';

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
      return true;
    }else{
      print(response.body);
      return false;
    }
  }
}