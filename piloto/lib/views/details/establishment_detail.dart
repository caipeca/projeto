import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:piloto/config/establishment/establisment_service.dart';

class EstablishmentDetailPage extends StatefulWidget {
  final String establishmentId;
  final String establishmentName;

  const EstablishmentDetailPage({
    super.key,
    required this.establishmentId,
    required this.establishmentName,
  });

  @override
  State<EstablishmentDetailPage> createState() =>
      _EstablishmentDetailPageState();
}

class _EstablishmentDetailPageState extends State<EstablishmentDetailPage> {
  final TextEditingController _searchController = TextEditingController();
  final EstablishmentService _service = EstablishmentService();
  List<dynamic> allProducts = [];
  List<dynamic> filteredProducts = [];
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _searchController.addListener(_filterProducts);
  }


  Future<void> _fetchProducts() async {
    try {
      final products = await _service.fetchProducts(widget.establishmentId);
      setState(() {
        allProducts = products;
        filteredProducts = products;
        isLoading = false;
      });
    } catch (e) {
      print('Erro: $e');
      setState(() => isLoading = false);
    }
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredProducts = allProducts.where((product) {
        final name = (product['name'] ?? '').toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget buildProductItem(Map product) {
    final imageUrl = (product['images'] != null && product['images'].isNotEmpty)
        ? product['images'][0]
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: imageUrl != null
            ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
            : Icon(Icons.medical_services, size: 40),
        title: Text(product['name']),
        subtitle: Text('Preço: ${product['price']} Kz'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.establishmentName)),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar produto...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(child: Text('Nenhum produto encontrado'))
                : ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return buildProductItem(filteredProducts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
