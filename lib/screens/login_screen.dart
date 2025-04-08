import 'package:db_sqlite/screens/usuario_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_store.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AuthStore>(context);

    if (store.estado == EstadoAuth.sucesso) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UsuarioScreen()),
        );
      });
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
            if (store.estado == EstadoAuth.carregando)
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () {
                  store.login(emailController.text, senhaController.text);
                },
                child: Text('Entrar'),
              ),
            if (store.estado == EstadoAuth.erro && store.erro != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(store.erro!, style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
