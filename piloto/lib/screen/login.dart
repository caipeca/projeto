import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    bool value = true;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.only(top: 56.0, left: 24.0,bottom: 24.0, right: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(height: 150, width: 150, image: AssetImage("assets/images/logo.png")),
                  ],
                ),
                 Center(
                   child: FittedBox(
                      child: Text('Por favor insira as credênciais', style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                      ),),
                    ),
                 ),
                SizedBox(height: 10,),
                TextFormField(
                  controller: controllerEmail,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    label: Text('Insira o Email'),
                    border: OutlineInputBorder(borderRadius:BorderRadius.vertical()),
                  ),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  controller: controllerPassword,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    label: Text('Insira a palavra passe'),
                    border: OutlineInputBorder(borderRadius:BorderRadius.vertical()),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(value: value , onChanged: (value) {
                        }, ),
                        SizedBox(height: 10.0,),
                      ],
                    )
                  ],
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () {},
                  style:ElevatedButton.styleFrom(
                      minimumSize: Size(250.0 , 50.0),
                    backgroundColor: Colors.teal,
                    shape: LinearBorder()
                  ),
                    child: Text('Entrar'),
                  ),
        
                ),
                SizedBox(height: 10.0,),
                Center(
                    child: OutlinedButton(
                      onPressed: (){},
                      style:OutlinedButton.styleFrom(
                          minimumSize: Size(250.0 , 50.0),
                          shape: ContinuousRectangleBorder()
                      ),
                      child: Text('Registar'),)),
              ],
            ),
        ),
      ),
    );
  }
}
