import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PriceService {
  final String baseUrl = 'http://192.168.1.108:8000/prices'; // Altera para o IP do servidor

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<bool> createPrice({
    required String itemName,
    String? itemDescription,
    String? itemCategory,
    String? itemImage,
    required double price,
    required String establishmentName,
    required List<double> establishmentCoordinates,
    String? addressDetails,
    List<String>? images,
    String? comment,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('Token não encontrado.');

    final url = Uri.parse(baseUrl);
    final body = jsonEncode({
      'itemName': itemName,
      'itemDescription': itemDescription,
      'itemCategory': itemCategory,
      'itemImage': itemImage,
      'price': price,
      'establishmentName': establishmentName,
      'establishmentCoordinates': establishmentCoordinates,
      'addressDetails': addressDetails,
      'images': images,
      'comment': comment,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    return response.statusCode == 201;
  }

  Future<List<dynamic>> getPricesByItem(String idOrSlug) async {
    final url = Uri.parse('$baseUrl/$idOrSlug');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar preços: ${response.body}');
    }
  }

  Future<dynamic> getLowestPriceByItem(String idOrSlug) async {
    final url = Uri.parse('$baseUrl/$idOrSlug/lowest');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar menor preço: ${response.body}');
    }
  }

  Future<dynamic> getClosestPriceByItem(String idOrSlug, double lng, double lat) async {
    final url = Uri.parse('$baseUrl/$idOrSlug/closest?lng=$lng&lat=$lat');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar preço mais próximo: ${response.body}');
    }
  }

  Future<List<dynamic>> getPriceHistory(String idOrSlug) async {
    final url = Uri.parse('$baseUrl/$idOrSlug/history');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar histórico de preços: ${response.body}');
    }
  }
}
