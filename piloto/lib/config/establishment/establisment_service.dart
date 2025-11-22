import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/establishment.dart';

class EstablishmentService {
  final String baseUrl = 'http://192.168.196.37:8000';
  //final String baseUrl = 'http://192.168.196.43:8000'; // ou IP da sua máquina no Android

  Future<List<Establishment>> fetchEstablishments() async {
    //final response = await http.get(Uri.parse('$baseUrl/establishments'));
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken');

    if (token == null || token.isEmpty) {
      throw Exception('Token não encontrado. Faça login novamente.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/establishments/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List decoded = jsonDecode(response.body);
      return decoded.map((e) => Establishment.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar estabelecimentos');
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }

  Future<List<dynamic>> fetchProducts(String establishmentId) async {
    final url = Uri.parse('$baseUrl/establishments/$establishmentId/products');
    final token  = await getToken();


    if (token == null) {
      throw Exception('Token não encontrado');
    }

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao buscar produtos: ${response.body}');
    }
  }

  Future<void> createEstablishment(String name, String address, List<double> coordinates) async {
    final url = Uri.parse('$baseUrl/establishments');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken');

    if (token == null) {
      throw Exception('Token não encontrado. Faça login novamente.');
    }

    final body = jsonEncode({
      'name': name,
      'addressDetails': address,
      'coordinates': coordinates,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao criar estabelecimento: ${response.body}');
    }
  }
}
