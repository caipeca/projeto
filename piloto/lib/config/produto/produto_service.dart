import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import '../../model/produto.dart';



class ProductService {

 static Future<bool> _salvarProdutoComImagem(
      String nome,
      String descricao,
      double preco,
      File? imagem,
      ) async {
    final uri = Uri.parse('http://localhost:3000/api/products/upload'); // 👈 seu endpoint deve aceitar multipart
    final request = http.MultipartRequest('POST', uri);

    request.fields['name'] = nome;
    request.fields['description'] = descricao;
    request.fields['price'] = preco.toString();
    request.fields['establishmentId'] = '665c38d18b65440015e4214c';

    if (imagem != null) {
      final mimeType = lookupMimeType(imagem.path)?.split('/');
      final multipartFile = await http.MultipartFile.fromPath(
        'image', // 👈 este campo depende do seu backend
        imagem.path,

      );
      request.files.add(multipartFile);
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return response.statusCode == 201;
    } catch (e) {
      print('Erro no upload: $e');
      return false;
    }
  }


}