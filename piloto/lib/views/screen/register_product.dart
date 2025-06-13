import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastroProdutoPage extends StatefulWidget {
  const CadastroProdutoPage({super.key});

  @override
  State<CadastroProdutoPage> createState() => _CadastroProdutoPageState();
}

class _CadastroProdutoPageState extends State<CadastroProdutoPage> {
  final _formKey = GlobalKey<FormState>();
  String nome = '';
  String descricao = '';
  double preco = 0.0;
  String imagemUrl = '';

  bool isLoading = false;

  Future<void> salvarProduto() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('http://localhost:3000/api/products'); // ➜ AJUSTE AQUI

    final body = {
      'name': nome,
      'description': descricao,
      'price': preco,
      'images': [imagemUrl],
      'establishmentId': '665c38d18b65440015e4214c', // ➜ Substituir com valor real se necessário
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer token_aqui' // ➜ se sua API exige autenticação
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produto cadastrado com sucesso!')),
        );
        Navigator.pop(context); // Volta para a tela anterior
      } else {
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar produto')),
        );
      }
    } catch (e) {
      print('Erro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro na comunicação com o servidor')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Produto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                TextFormField(
                  decoration: InputDecoration(labelText: 'URL da Imagem'),
                  onSaved: (value) => imagemUrl = value ?? '',
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      salvarProduto();
                    }
                  },
                  child: Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
