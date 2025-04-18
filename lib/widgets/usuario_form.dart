import 'package:db_sqlite/data/model/usuario.dart';
import 'package:db_sqlite/store/usuario_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormularioUsuario extends StatefulWidget {
  const FormularioUsuario({super.key});

  @override
  State<FormularioUsuario> createState() => FormularioUsuarioState();
}

class FormularioUsuarioState extends State<FormularioUsuario> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final senhaController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<UsuarioStore>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastrar novo usuário',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, top: 8),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min, // tamanho automático
            children: [
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: senhaController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator:
                    (v) =>
                        v == null || v.length < 4
                            ? 'Mínimo 4 caracteres'
                            : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (v) => v == null || !v.contains('@')
                    ? 'Informe um email válido'
                    : null,
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text('Salvar'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await store.adicionarUsuario(
                      Usuario(
                        nome: nomeController.text,
                        email: emailController.text,
                        senha: senhaController.text,
                      ),
                    );

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context); // fecha o BottomSheet
                  }
                },
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
