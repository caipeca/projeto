import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piloto/views/details/establishment_detail.dart';

import '../../config/establishment/establisment_service.dart';
import '../../helper/store_helper.dart';
import '../../model/establishment.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  final service = EstablishmentService();
  late Future<List<Establishment>> futureEstablishments;

  @override
  void initState() {
    super.initState();
    futureEstablishments = service.fetchEstablishments();
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

            SizedBox(height: 10),
            FutureBuilder<List<Establishment>>(
              future: futureEstablishments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                final establishments = snapshot.data ?? [];

                if (establishments.isEmpty) {
                  return Center(child: Text('Nenhum estabelecimento encontrado.'));
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: establishments.length,
                    itemBuilder: (context, index) {
                      final est = establishments[index];
                      return Card(
                        color: Color(0xFFE8DED4),
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: ListTile(
                          title: Text(est.name),
                          subtitle: Text('• ${est.address}'),
                          leading: Icon(Icons.store),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => EstablishmentDetailPage(establishmentId: est.id, establishmentName: est.name)));
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CadastroEstablishmentHelper.mostrarFormularioCadastro(context, () {
            setState(() {
              futureEstablishments = service.fetchEstablishments();
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
