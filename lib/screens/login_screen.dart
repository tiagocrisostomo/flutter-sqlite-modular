// ignore_for_file: use_build_context_synchronously

import 'package:db_sqlite/screens/home.dart';
// import 'package:db_sqlite/screens/usuario_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/auth_store.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      });
    } else if (store.estadoAuth == EstadoAuth.carregando) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0f2027), Color(0xFF203A43), Color(0xFF2c5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                const Text(
                  'FinanceX',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Controle seus gastos de forma inteligente',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 32),
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            validator:
                                (value) =>
                                    value!.isEmpty ? 'Informe o email' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _senhaController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              labelText: 'Senha',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            validator:
                                (value) =>
                                    value!.isEmpty ? 'Informe a senha' : null,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await store.login(
                                  _emailController.text,
                                  _senhaController.text,
                                );
                              },
                              icon: const Icon(Icons.login),
                              label: const Text('Entrar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1DB954),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                textStyle: const TextStyle(fontSize: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Esqueci minha senha'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // Scaffold(
    //   body: Container(
    //     decoration: const BoxDecoration(
    //       gradient: LinearGradient(
    //         colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
    //         begin: Alignment.topLeft,
    //         end: Alignment.bottomRight,
    //       ),
    //     ),
    //     child: Center(
    //       child: Card(
    //         elevation: 8,
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(16),
    //         ),
    //         margin: const EdgeInsets.symmetric(horizontal: 32),
    //         child: Padding(
    //           padding: const EdgeInsets.all(24),
    //           child: Form(
    //             key: _formKey,
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 const Text(
    //                   'Login',
    //                   style: TextStyle(
    //                     fontSize: 24,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //                 const SizedBox(height: 24),
    //                 TextFormField(
    //                   controller: _emailController,
    //                   decoration: const InputDecoration(
    //                     prefixIcon: Icon(Icons.person),
    //                     labelText: 'Email',
    //                     border: OutlineInputBorder(),
    //                   ),
    //                   validator:
    //                       (value) => value!.isEmpty ? 'Informe o email' : null,
    //                 ),
    //                 const SizedBox(height: 16),
    //                 TextFormField(
    //                   controller: _senhaController,
    //                   decoration: const InputDecoration(
    //                     prefixIcon: Icon(Icons.lock),
    //                     labelText: 'Senha',
    //                     border: OutlineInputBorder(),
    //                   ),
    //                   obscureText: true,
    //                   validator:
    //                       (value) => value!.isEmpty ? 'Informe a senha' : null,
    //                 ),
    //                 const SizedBox(height: 24),
    //                 SizedBox(
    //                   width: double.infinity,
    //                   child: ElevatedButton(
    //                     onPressed: () async {
    //                       await store.login(
    //                         _emailController.text,
    //                         _senhaController.text,
    //                       );
    //                     },
    //                     style: ElevatedButton.styleFrom(
    //                       padding: const EdgeInsets.symmetric(vertical: 16),
    //                       backgroundColor: const Color(0xFF0083B0),
    //                       shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(8),
    //                       ),
    //                     ),
    //                     child: const Text(
    //                       'Entrar',
    //                       style: TextStyle(fontSize: 16),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
