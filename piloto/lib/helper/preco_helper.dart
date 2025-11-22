import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../config/establishment/establisment_service.dart';
import '../model/establishment.dart';

class CadastroPrecoHelper {
  static final _formKey = GlobalKey<FormState>();
  static String itemName = '';
  static String itemDescription = '';
  static String itemCategory = '';
  static double price = 0.0;
  static String? establishmentIdSelecionado;
  static bool isLoading = false;
  static List<Establishment> estabelecimentos = [];
  static File? imagemSelecionada;
  static final picker = ImagePicker();

  static void mostrarFormularioCadastro(BuildContext context) async {
    final service = EstablishmentService();
    estabelecimentos = await service.fetchEstablishments();

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
                        'Cadastrar Preço',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      _campoNome(),
                      _campoDescricao(),
                      _campoCategoria(),
                      _campoPreco(),
                      _campoEstabelecimento(setState),
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
      decoration: InputDecoration(labelText: 'Nome do Produto'),
      onSaved: (value) => itemName = value ?? '',
      validator: (value) =>
      value == null || value.isEmpty ? 'Informe o nome' : null,
    );
  }

  static Widget _campoDescricao() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Descrição'),
      onSaved: (value) => itemDescription = value ?? '',
    );
  }

  static Widget _campoCategoria() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Categoria'),
      onSaved: (value) => itemCategory = value ?? '',
    );
  }

  static Widget _campoPreco() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Preço'),
      keyboardType: TextInputType.number,
      onSaved: (value) => price = double.tryParse(value ?? '0') ?? 0.0,
      validator: (value) =>
      value == null || value.isEmpty ? 'Informe o preço' : null,
    );
  }

  static Widget _campoEstabelecimento(StateSetter setState) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: 'Estabelecimento'),
      items: estabelecimentos.map((e) {
        return DropdownMenuItem<String>(
          value: e.id,
          child: Text(e.name),
        );
      }).toList(),
      value: establishmentIdSelecionado,
      onChanged: (value) {
        establishmentIdSelecionado = value;
        setState(() {});
      },
      validator: (value) =>
      value == null ? 'Selecione um estabelecimento' : null,
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

  static Future<void> _submitFormulario(BuildContext context, StateSetter setState) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() => isLoading = true);

      final success = await _salvarPrecoComImagem();

      setState(() => isLoading = false);

      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Preço cadastrado!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar preço')),
        );
      }
    }
  }

  static Future<bool> _salvarPrecoComImagem() async {
    final uri = Uri.parse('http://192.168.196.37:8000/prices'); // Ajusta o endpoint
    final request = http.MultipartRequest('POST', uri);

    request.fields['itemName'] = itemName;
    request.fields['itemDescription'] = itemDescription;
    request.fields['itemCategory'] = itemCategory;
    request.fields['price'] = price.toString();
    request.fields['establishmentId'] = establishmentIdSelecionado ?? '';

    if (imagemSelecionada != null) {
      final mimeType = lookupMimeType(imagemSelecionada!.path)?.split('/');
      final multipartFile = await http.MultipartFile.fromPath(
        'itemImage',
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
