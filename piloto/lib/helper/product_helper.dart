import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class CadastroProdutoHelper {
  static final _formKey = GlobalKey<FormState>();
  static String nome = '';
  static String descricao = '';
  static double preco = 0.0;
  static File? imagemSelecionada;
  static bool isLoading = false;
  static final picker = ImagePicker();

  static void mostrarFormularioCadastro(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Cadastrar Produto',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      _campoNome(),
                      _campoDescricao(),
                      _campoPreco(),
                      _previewImagem(setState),
                      _botaoImagem(setState),
                      SizedBox(height: 16),
                      isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: () => _submitFormulario(context, setState),
                        child: Text('Salvar'),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  static Widget _campoNome() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Nome'),
      onSaved: (value) => nome = value ?? '',
      validator: (value) =>
      value == null || value.isEmpty ? 'Informe o nome' : null,
    );
  }

  static Widget _campoDescricao() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Descrição'),
      onSaved: (value) => descricao = value ?? '',
    );
  }

  static Widget _campoPreco() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Preço'),
      keyboardType: TextInputType.number,
      onSaved: (value) => preco = double.tryParse(value ?? '0') ?? 0.0,
    );
  }

  static Widget _previewImagem(StateSetter setState) {
    return imagemSelecionada != null
        ? Image.file(imagemSelecionada!, height: 100)
        : Text('Nenhuma imagem selecionada');
  }

  static Widget _botaoImagem(StateSetter setState) {
    return TextButton.icon(
      onPressed: () async {
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          imagemSelecionada = File(pickedFile.path);
          setState(() {});
        }
      },
      icon: Icon(Icons.image),
      label: Text('Selecionar Imagem'),
    );
  }

  static Future<void> _submitFormulario(
      BuildContext context, StateSetter setState) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() => isLoading = true);

      final success = await _salvarProdutoComImagem();

      setState(() => isLoading = false);

      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produto cadastrado!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar')),
        );
      }
    }
  }

  static Future<bool> _salvarProdutoComImagem() async {
    //final uri = Uri.parse('http://localhost:3000/api/products/upload'); // Ajuste conforme seu endpoint real
    final uri = Uri.parse('http://192.168.89.1:8000/products/'); // Ajuste conforme seu endpoint real
    final request = http.MultipartRequest('POST', uri);

    request.fields['name'] = nome;
    request.fields['description'] = descricao;
    request.fields['price'] = preco.toString();
    request.fields['establishmentId'] = '665c38d18b65440015e4214c';

    if (imagemSelecionada != null) {
      final mimeType = lookupMimeType(imagemSelecionada!.path)?.split('/');
      final multipartFile = await http.MultipartFile.fromPath(
        'image',
        imagemSelecionada!.path,
        contentType: MediaType(mimeType?[0] ?? 'image', mimeType?[1] ?? 'jpeg'),
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
