import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../config/establishment/establisment_service.dart';

class CadastroEstablishmentHelper {
  static final _formKey = GlobalKey<FormState>();
  static String nome = '';
  static String endereco = '';
  static String coordenadas = '';
  static bool isLoading = false;

  static final service = EstablishmentService();

  static void mostrarFormularioCadastro(BuildContext context, VoidCallback onSuccess) {
    nome = '';
    endereco = '';
    coordenadas = '';
    isLoading = false;

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
                        'Cadastrar Estabelecimento',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      _campoNome(),
                      _campoEndereco(),
                      _campoCoordenadas(setState),
                      SizedBox(height: 16),
                      isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: () => _submitFormulario(context, setState, onSuccess),
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
      validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
    );
  }

  static Widget _campoEndereco() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Endereço'),
      onSaved: (value) => endereco = value ?? '',
    );
  }

  static Widget _campoCoordenadas(StateSetter setState) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Coordenadas (longitude, latitude)'),
            controller: TextEditingController(text: coordenadas),
            readOnly: true,
          ),
        ),
        IconButton(
          icon: Icon(Icons.my_location),
          onPressed: () async {
            bool serviceEnabled;
            LocationPermission permission;

            serviceEnabled = await Geolocator.isLocationServiceEnabled();
            if (!serviceEnabled) {
              ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
                SnackBar(content: Text('Por favor, ative a localização.')),
              );
              return;
            }

            permission = await Geolocator.checkPermission();
            if (permission == LocationPermission.denied) {
              permission = await Geolocator.requestPermission();
              if (permission == LocationPermission.denied) {
                ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
                  SnackBar(content: Text('Permissão de localização negada.')),
                );
                return;
              }
            }

            if (permission == LocationPermission.deniedForever) {
              ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
                SnackBar(content: Text('Permissão de localização permanentemente negada.')),
              );
              return;
            }

            final position = await Geolocator.getCurrentPosition();
            coordenadas = '${position.longitude}, ${position.latitude}';
            setState(() {});
          },
        ),
      ],
    );
  }

  static Future<void> _submitFormulario(
      BuildContext context, StateSetter setState, VoidCallback onSuccess) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() => isLoading = true);

      try {
        final coords = coordenadas.split(',').map((e) => double.parse(e.trim())).toList();
        if (coords.length != 2) throw FormatException();

        await service.createEstablishment(nome, endereco, coords);

        setState(() => isLoading = false);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Estabelecimento cadastrado!')),
        );
        onSuccess();
      } catch (e) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar. Verifique os dados.')),
        );
      }
    }
  }
}
