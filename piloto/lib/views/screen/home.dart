import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:piloto/app.dart';
import 'package:http/http.dart' as http;
import 'package:piloto/model/item.dart';
import 'package:piloto/views/screen/register_product.dart';
import '../../helper/preco_helper.dart';
import '../../helper/product_helper.dart';
import '../../model/produto.dart';
import '../widget/categoria.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Item> produtos = [];
  List<Item> produtosFiltrados = [];
  String termoBusca = '';

  @override
  void initState() {
    super.initState();
    buscarProdutos();
  }

  Future<void> buscarProdutos() async {
    final response = await http.get(Uri.parse('http://192.168.196.37:8000/items/')); // AJUSTE AQUI
    //final response = await http.get(Uri.parse('http://192.168.196.43:8000/products')); // AJUSTE AQUI
    if (response.statusCode == 200) {
      final List dados = jsonDecode(response.body);
      setState(() {
        produtos = dados.map((json) => Item.fromJson(json)).toList();
        produtosFiltrados = produtos;
      });
    } else {
      print('Erro ao buscar produtos: ${response.statusCode}');
    }
  }

  void filtrarProdutos(String termo) {
    setState(() {
      termoBusca = termo;
      produtosFiltrados = produtos.where((p) {
        return p.nome.toLowerCase().contains(termo.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Pesquisa',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),

            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: carousel_slider.CarouselSlider(
                items:
                    [
                      Categoria(categoria: 'Álcool'),
                      Categoria(categoria: 'Aperetivos'),
                      Categoria(categoria: 'Legumes'),
                      Categoria(categoria: 'Aves'),
                      Categoria(categoria: 'Bebida'),
                    ].map((widget) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: widget,
                      );
                    }).toList(),
                options: carousel_slider.CarouselOptions(
                  viewportFraction: 0.33,
                  enableInfiniteScroll: true,
                  enlargeCenterPage: false,
                  autoPlay: true,
                ),
              ),
            ),

            SizedBox(height: 10),

            Expanded(
              child: produtosFiltrados.isEmpty
                  ? Center(child: Text('Nenhum produto encontrado'))
                  : GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: produtosFiltrados.length,
                itemBuilder: (context, index) {
                  final produto = produtosFiltrados[index];
                  return Card(
                    color: Color(0xFFE8DED4),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: produto.imagem.isNotEmpty
                              ? ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(8)),
                            child: Image.network(
                              produto.imagem,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                              : Image.asset('assets/images/placeholder.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                produto.nome,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              //Text('${produto.preco.toStringAsFixed(2)}kz'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //CadastroProdutoHelper.mostrarFormularioCadastro(context);
          CadastroPrecoHelper.mostrarFormularioCadastro(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Adicionar Produto',
      ),
    );
  }
}
