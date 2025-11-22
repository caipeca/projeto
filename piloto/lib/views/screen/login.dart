import 'package:flutter/material.dart';
import 'package:piloto/config/auth/authentication.dart';
import '../widget_tree.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  bool rememberMe = false;

  void _handleLogin(BuildContext context) async {
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    final success = await Authentication.loginUser(email, password);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login feito com sucesso!')),
      );

      // Navegar para a próxima tela
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WidgetTree()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha no login')),
      );
    }
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset("assets/images/logo.png", height: 150, width: 150),
            ),
            const Center(
              child: Text(
                'Por favor insira as credenciais',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: controllerEmail,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: controllerPassword,
              obscureText: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (bool? value) {
                    setState(() {
                      rememberMe = value ?? false;
                    });
                  },
                ),
                const Text('Lembrar de mim'),
              ],
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => _handleLogin(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250.0, 50.0),
                ),
                child: const Text('Entrar'),
              ),
            ),
            const SizedBox(height: 10.0),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  // Navegar para a tela de cadastro (registo)
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(250.0, 50.0),
                ),
                child: const Text('Registrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
