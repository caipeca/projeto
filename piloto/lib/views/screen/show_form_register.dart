import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:piloto/config/produto/produto_service.dart';


void _mostrarFormularioCadastro(BuildContext context) {

  final _formKey = GlobalKey<FormState>();
  String nome = '';
  String descricao = '';
  double preco = 0.0;
  File? imagemSelecionada;
  bool isLoading = false;

  final picker = ImagePicker();

  Future<void> _escolherImagem() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imagemSelecionada = File(pickedFile.path);
    }
  }

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
        child: StatefulBuilder(builder: (context, setState) {
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
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nome'),
                    onSaved: (value) => nome = value ?? '',
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o nome' : null,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Descrição'),
                    onSaved: (value) => descricao = value ?? '',
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Preço'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) =>
                    preco = double.tryParse(value ?? '0') ?? 0.0,
                  ),
                  SizedBox(height: 10),
                  imagemSelecionada != null
                      ? Image.file(imagemSelecionada!, height: 100)
                      : Text('Nenhuma imagem selecionada'),
                  TextButton.icon(
                    onPressed: () async {
                      await _escolherImagem();
                      setState(() {}); // Atualiza preview
                    },
                    icon: Icon(Icons.image),
                    label: Text('Selecionar Imagem'),
                  ),
                  SizedBox(height: 16),
                  isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        setState(() => isLoading = true);

                        final success = true;

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
                    },
                    child: Text('Salvar'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        }),
      );
    },
  );
}
