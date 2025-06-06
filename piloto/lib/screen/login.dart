import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(

              ),
              TextFormField(

              ),
              SizedBox(height: 10.0,),
              ElevatedButton(onPressed: () {
              }, child: Text('Entrar'))
            ],
          ),
      ),
    );
  }
}
