// ignore_for_file: use_build_context_synchronously

import 'package:db_sqlite/screens/usuario_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/auth_store.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AuthStore>(context);

    if (store.estadoAuth == EstadoAuth.erro && store.mensagemErro != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(store.mensagemErro!),
            backgroundColor: Colors.red,
          ),
        );
        store.limparErro();
      });
    } else if (store.estadoAuth == EstadoAuth.sucesso) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UsuarioScreen()),
        );
      });
    } else if (store.estadoAuth == EstadoAuth.carregando) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: senhaController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                store.login(emailController.text, senhaController.text);
              },
              child: Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
