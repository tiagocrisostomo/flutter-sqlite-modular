import 'package:db_sqlite/screens/desktop/home_desktop.dart';
import 'package:db_sqlite/widgets/recuperacao_senha.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../store/auth_store.dart';

class LoginScreenDesktop extends StatelessWidget {
  final _userController = TextEditingController();
  final _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LoginScreenDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final store = Provider.of<AuthStore>(context);

    if (store.estadoAuth == EstadoAuth.erro && store.mensagemErro != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(store.mensagemErro!),
            backgroundColor: Colors.red,
            showCloseIcon: true,
            // width: Material, // Width of the SnackBar.
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0, // Inner padding for SnackBar content.
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            elevation: 10,
            dismissDirection: DismissDirection.horizontal,
            animation: CurvedAnimation(parent: const AlwaysStoppedAnimation(1.5), curve: Curves.easeIn),
          ),
        );
        store.limparErro();
      });
    } else if (store.estadoAuth == EstadoAuth.logado) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePageDesktop()));
      });
    } else if (store.estadoAuth == EstadoAuth.logando) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF0f2027), Color(0xFF203A43), Color(0xFF2c5364)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_balance_wallet_rounded, size: 80, color: Colors.white),
                const SizedBox(height: 16),
                const Text('ESTUDO DO TIAGO', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                const Text('Controle seus gastos de forma inteligente', style: TextStyle(fontSize: 16, color: Colors.white70)),
                const SizedBox(height: 32),
                SizedBox(
                  height: size.height * 0.4,
                  width: size.width * 0.3,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextFormField(
                              controller: _userController,
                              decoration: const InputDecoration(prefixIcon: Icon(Icons.email), labelText: 'Usuário', border: OutlineInputBorder()),
                              validator: (value) => value!.isEmpty ? 'Informe o usuário' : null,
                            ),
                            // const SizedBox(height: 16),
                            TextFormField(
                              controller: _senhaController,
                              decoration: const InputDecoration(prefixIcon: Icon(Icons.lock), labelText: 'Senha', border: OutlineInputBorder()),
                              obscureText: true,
                              validator: (value) => value!.isEmpty ? 'Informe a senha' : null,
                            ),
                            // const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: size.height * 0.05,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  if (!_formKey.currentState!.validate()) return;
                                  await store.login(_userController.text, _senhaController.text);
                                },
                                icon: const Icon(Icons.login),
                                label: const Text('Entrar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1DB954),
                                  // padding: const EdgeInsets.symmetric(vertical: 16),
                                  textStyle: const TextStyle(fontSize: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            // const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => showDialog(context: context, builder: (context) => RecuperacaoSenha()),
                              child: const Text('Esqueci minha senha'),
                            ),
                          ],
                        ),
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
  }
}
